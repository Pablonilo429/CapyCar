import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Adiciona um documento à coleção especificada
  Future<DocumentReference> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    return await _firestore.collection(collection).add(data);
  }

  /// Busca todos os documentos da coleção especificada
  Future<List<QueryDocumentSnapshot>> getDocumentsWithPaginationAndFilter({
    required String collection,
    int page = 1,
    int pageSize = 10,
    bool? isFuturo,
    String? rotaFiltro,
    bool? isVoltaFiltro,
    String? campusFiltro,
  }) async {
    Query query = _firestore.collection(collection);

    // Filtro por campo aninhado: rota.campus
    if (campusFiltro != null && campusFiltro.isNotEmpty) {
      query = query.where('rota.campus', isEqualTo: campusFiltro);
    }

    // Filtro por carona de volta ou ida
    if (isVoltaFiltro != null) {
      query = query.where('isVolta', isEqualTo: isVoltaFiltro);
    }

    // Filtro por caronas futuras (com orderBy obrigatório no mesmo campo)
    if (isFuturo == true) {
      query = query
          .orderBy('horarioSaidaCarona')
          .where(
            'horarioSaidaCarona',
            isGreaterThan: Timestamp.fromDate(DateTime.now()),
          );
    } else if (rotaFiltro != null && rotaFiltro.isNotEmpty) {
      // Filtro por rota (como prefixo)
      final end =
          rotaFiltro.substring(0, rotaFiltro.length - 1) +
          String.fromCharCode(rotaFiltro.codeUnitAt(rotaFiltro.length - 1) + 1);
      query = query
          .orderBy('rota.saida')
          .where('rota.saida', isGreaterThanOrEqualTo: rotaFiltro)
          .where('rota.saida', isLessThan: end);
    }

    final offset = (page - 1) * pageSize;
    final snapshot = await query.limit(offset + pageSize).get();

    final pagedDocs = snapshot.docs.skip(offset).toList();
    return pagedDocs;
  }

  Future<List<QueryDocumentSnapshot>> getDocumentsWithFilter({
    required String collection,
    required Map<String, dynamic> filters,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      // Adiciona filtros dinamicamente
      filters.forEach((field, value) {
        query = query.where(field, isEqualTo: value);
      });

      // Executa a consulta e obtém os documentos
      final snapshot = await query.get();
      return snapshot.docs;
    } catch (e) {
      rethrow; // Caso ocorra algum erro, ele é propagado.
    }
  }

  /// Busca um documento específico por ID
  Future<DocumentSnapshot> getDocumentById({
    required String collection,
    required String docId,
  }) async {
    return await _firestore.collection(collection).doc(docId).get();
  }

  /// Atualiza um documento por ID
  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }

  /// Deleta um documento por ID
  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    await _firestore.collection(collection).doc(docId).delete();
  }

  CollectionReference getCollection(String collectionName) {
    return _firestore.collection(collectionName);
  }
}
