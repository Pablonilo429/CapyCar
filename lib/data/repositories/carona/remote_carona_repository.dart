import 'dart:async';

import 'package:capy_car/data/repositories/carona/carona_repository.dart';
import 'package:capy_car/data/services/firebase/store_service.dart';
import 'package:capy_car/domain/dtos/credentials_carona.dart';
import 'package:capy_car/domain/dtos/credentials_rota.dart';
import 'package:capy_car/domain/models/carona/carona.dart';
import 'package:capy_car/domain/models/rota/rota.dart';
import 'package:capy_car/domain/validators/credentials_carona_validator.dart';
import 'package:capy_car/domain/validators/credentials_rota_validator.dart';
import 'package:capy_car/utils/validation/LucidValidatorExtension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';
import 'package:result_dart/src/unit.dart';

class RemoteCaronaRepository implements CaronaRepository {
  final _streamController = StreamController<Carona>.broadcast();

  final FirestoreService _storeService = FirestoreService();
  final String _collection = 'caronas';

  /// Cria uma nova carona com validação
  @override
  AsyncResult<Carona> criarCarona(CredentialsCarona credentials) async {
    try {
      // Verifica se já há carona ativa (não finalizada) do tipo correspondente (ida/volta) para o motorista
      final caronasAtuais = await _storeService.getDocumentsWithFilter(
        collection: _collection,
        filters: {
          'isFinalizada': false,
          'isVolta': credentials.isVolta!,
          'motoristaId': credentials.idMotorista,
        },
      );

      for (final doc in caronasAtuais) {
        final data = doc.data() as Map<String, dynamic>;
        final horarioChegadaStr = data['horarioChegada'] as String;
        final horarioChegada = DateTime.parse(horarioChegadaStr);

        if (horarioChegada.isBefore(DateTime.now())) {
          await _storeService.updateDocument(
            collection: _collection,
            docId: doc.id,
            data: {'isFinalizada': true, 'status': 'concluída'},
          );
        } else {
          return Failure(
            Exception(
              'Você já possui uma carona ${credentials.isVolta! ? 'de volta' : 'de ida'} ativa.',
            ),
          );
        }
      }


      final carona = Carona(
        id: '',
        motoristaId: credentials.idMotorista,
        rota: Rota(
          campus: credentials.rota!.campus,
          pontos: credentials.rota!.pontos,
          saida: credentials.rota!.cidadeSaida,
        ),
        qtdePassageiros: credentials.qtdePassageiros,
        isVolta: credentials.isVolta!,
        idsPassageiros: [],
        status: 'ativa',
        horarioSaidaCarona: credentials.horarioSaida!,
        horarioChegada: credentials.horarioChegada!,
        dataCarona: DateTime.now(),
        preco: credentials.preco,
        isFinalizada: false,
      );

      final data = carona.toJson()..remove('id');
      final docRef = await _storeService.addDocument(
        collection: _collection,
        data: data,
      );

      final doc = await docRef.get();
      final newCarona = carona.copyWith(id: doc.id);
      _streamController.add(newCarona);
      return Success(newCarona);
    } catch (e) {
      print(e);
      return Failure(Exception('Erro ao criar carona: $e'));
    }
  }

  /// Edita uma carona existente
  @override
  AsyncResult<Carona> editarCarona(Carona carona) async {
    // Transforma o modelo em DTO para validação
    final credentials = CredentialsCarona(
      idMotorista: carona.motoristaId,
      isVolta: carona.isVolta,
      horarioSaida: carona.horarioSaidaCarona,
      horarioChegada: carona.horarioChegada,
      rota: CredentialsRota(
        campus: carona.rota.campus,
        cidadeSaida: carona.rota.saida,
        pontos: carona.rota.pontos,
      ),
    );

    final validated = await CredentialsCaronaValidator().validateResult(
      credentials,
    );
    final validatedRota = await CredentialsRotaValidator().validateResult(
      credentials.rota!,
    );

    return await validated.fold((creds) async {
      return await validatedRota.fold((_) async {
        try {
          await _storeService.updateDocument(
            collection: _collection,
            docId: carona.id!,
            data: carona.toJson(),
          );
          _streamController.add(carona);
          return Success(carona);
        } catch (e) {
          return Failure(Exception('Erro ao editar carona: $e'));
        }
      }, (rotaError) => Failure(rotaError));
    }, (error) => Failure(error));
  }

  /// Busca uma carona por ID
  @override
  AsyncResult<Carona> getCarona(String id) async {
    try {
      final doc = await _storeService.getDocumentById(
        collection: _collection,
        docId: id,
      );

      if (!doc.exists) {
        return Failure(Exception('Carona não encontrada'));
      }

      final carona = Carona.fromJson(
        doc.data() as Map<String, dynamic>,
      ).copyWith(id: doc.id);

      return Success(carona);
    } catch (e) {
      return Failure(Exception('Erro ao buscar carona: $e'));
    }
  }

  /// Lista caronas com filtro opcional
  @override
  AsyncResult<List<Carona?>> getAllCarona(
    String? campus,
    bool? isVolta,// busca textual
    String? rotaFiltro,
  ) async {
    try {
      final docs = await _storeService.getFilteredCaronas(
        collection: _collection,
        textoBusca: rotaFiltro,
        campusFiltro: campus,
        isVoltaFiltro: isVolta,
      );

      final caronas = docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Carona.fromJson(data).copyWith(id: doc.id);
      }).toList();
      print(caronas.length);

      if(caronas.isEmpty){

        return Failure(Exception('Não há caronas para as próximas 24 horas.'));
      }

      return Success(caronas);
    } catch (e) {

      print("Erro ao buscar caronas: $e");
      return Failure(Exception('Erro ao buscar caronas: $e'));
    }
  }


  /// Cancela uma carona
  @override
  AsyncResult<Unit> cancelarCarona(String id) async {
    try {
      await _storeService.updateDocument(
        collection: _collection,
        docId: id,
        data: {'status': 'cancelada', 'isFinalizada': true},
      );
      return const Success(unit);
    } catch (e) {
      return Failure(Exception('Erro ao cancelar carona: $e'));
    }
  }

  /// Sai de uma carona (remove o usuário da lista de passageiros)
  @override
  AsyncResult<Unit> sairCarona({
    required String caronaId,
    required String userId,
  }) async {
    try {
      final doc = await _storeService.getDocumentById(
        collection: _collection,
        docId: caronaId,
      );

      if (!doc.exists) {
        return Failure(Exception('Carona não encontrada'));
      }

      final data = doc.data() as Map<String, dynamic>;
      final passageiros = List<String>.from(data['idsPassageiros'] ?? []);

      if (!passageiros.contains(userId)) {
        return Failure(Exception('Usuário não está na carona'));
      }

      passageiros.remove(userId);

      await _storeService.updateDocument(
        collection: _collection,
        docId: caronaId,
        data: {'idsPassageiros': passageiros},
      );

      final updatedDoc = await _storeService.getDocumentById(
        collection: _collection,
        docId: caronaId,
      );
      final updatedCarona = Carona.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
      ).copyWith(id: updatedDoc.id);
      _streamController.add(updatedCarona);

      return const Success(unit);
    } catch (e) {
      return Failure(Exception('Erro ao sair da carona: $e'));
    }
  }

  @override
  AsyncResult<Unit> entrarCarona(String userId, String caronaId) async {
    try {
      // Passo 1: Obter a carona que o usuário deseja entrar
      final caronaDoc = await _storeService.getDocumentById(
        collection: _collection,
        docId: caronaId,
      );

      if (!caronaDoc.exists) {
        return Failure(Exception('Carona não encontrada.'));
      }

      final caronaData = caronaDoc.data() as Map<String, dynamic>;
      final isVolta = caronaData['isVolta'] as bool;

      // Passo 2: Verificar se já está em uma carona do mesmo tipo (ida/volta)
      final caronasAtivas = await _storeService.getDocumentsWithFilter(
        collection: _collection,
        filters: {
          'isFinalizada': false,
          'isVolta': isVolta,
          'idsPassageiros': userId,
        },
      );

      for (final doc in caronasAtivas) {
        final data = doc.data() as Map<String, dynamic>;
        final horarioChegadaStr = data['horarioChegada'] as String;
        final horarioChegada = DateTime.parse(horarioChegadaStr);

        if (horarioChegada.isBefore(DateTime.now())) {
          await _storeService.updateDocument(
            collection: _collection,
            docId: doc.id,
            data: {'isFinalizada': true, 'status': 'concluída'},
          );
        } else {
          return Failure(
            Exception(
              'Você já está em uma carona',
            ),
          );
        }
      }

      // Passo 3: Verificar se já está na lista de passageiros
      final idsPassageiros = List<String>.from(
        caronaData['idsPassageiros'] ?? [],
      );
      if (idsPassageiros.contains(userId)) {
        return Failure(Exception('O usuário já está na carona.'));
      }

      if (idsPassageiros.length == caronaData['qtdePassageiros']) {
        return Failure(
          Exception('Esta carona atingiu seu máximo de passageiros.'),
        );
      }

      // Passo 4: Adicionar o usuário
      idsPassageiros.add(userId);
      await _storeService.updateDocument(
        collection: _collection,
        docId: caronaId,
        data: {'idsPassageiros': idsPassageiros},
      );

      final updatedDoc = await _storeService.getDocumentById(
        collection: _collection,
        docId: caronaId,
      );
      final updatedCarona = Carona.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
      ).copyWith(id: updatedDoc.id);
      _streamController.add(updatedCarona);

      return const Success(unit);
    } catch (e) {
      return Failure(Exception('Erro ao entrar na carona: $e'));
    }
  }

  void dispose() {
    _streamController.close();
  }
}
