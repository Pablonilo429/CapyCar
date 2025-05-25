import 'package:capy_car/data/services/firebase/store_service.dart';
import 'package:capy_car/domain/models/rota/rota.dart';
import 'package:capy_car/domain/dtos/credentials_rota.dart';
import 'package:capy_car/data/repositories/rota/rota_repository.dart';
import 'package:capy_car/domain/validators/credentials_rota_validator.dart';
import 'package:capy_car/utils/validation/LucidValidatorExtension.dart';

import 'package:result_dart/result_dart.dart';
import 'package:result_dart/src/unit.dart';

class RemoteRotaRepository implements RotaRepository {
  final FirestoreService _storeService = FirestoreService();
  final String _collection = 'usuarios';

  @override
  AsyncResult<Rota> criarRota(
    String userId,
    CredentialsRota credentials,
  ) async {
    try {
      final doc = await _storeService.getDocumentById(
        collection: _collection,
        docId: userId,
      );

      if (!doc.exists) {
        return Failure(Exception('Usuário não encontrado'));
      }

      if (credentials.pontos.isEmpty) {
        return Failure(Exception("Adicione pelo menos um ponto"));
      }
      if (credentials.pontos.length > 10) {
        return Failure(Exception("O número máximo de pontos é 10"));
      }

      final userData = doc.data() as Map<String, dynamic>;
      final rotasJson = List<Map<String, dynamic>>.from(
        userData['rotasCadastradas'] ?? [],
      );

      // Criar rota sem ID manual, deixando o Firestore gerar o ID
      final newRotaRef = await _storeService.addDocument(
        collection: _collection,
        data: {},
      );
      final newRotaId = newRotaRef.id;
      final rota = Rota(
        id: newRotaId,
        nome: credentials.nomeRota,
        saida: credentials.cidadeSaida,
        campus: credentials.campus,
        pontos: credentials.pontos,
      );

      rotasJson.add(rota.toJson());

      await _storeService.updateDocument(
        collection: _collection,
        docId: userId,
        data: {'rotasCadastradas': rotasJson},
      );

      return Success(rota);
    } catch (e) {
      return Failure(Exception('Erro ao criar rota: $e'));
    }
  }

  @override
  AsyncResult<Rota> editarRota(String userId, Rota rota) async {
    try {
      // Validação passou, então seguimos com o processo de editar a rota
      final doc = await _storeService.getDocumentById(
        collection: _collection,
        docId: userId,
      );

      if (!doc.exists) {
        return Failure(Exception('Usuário não encontrado'));
      }

      final userData = doc.data() as Map<String, dynamic>;
      final rotasJson = List<Map<String, dynamic>>.from(
        userData['rotasCadastradas'] ?? [],
      );

      final index = rotasJson.indexWhere((r) => r['id'] == rota.id);
      if (index == -1) {
        return Failure(Exception('Rota não encontrada'));
      }

      // Atualizando a rota com os dados validados
      rotasJson[index] =
          rota
              .copyWith(
                nome: rota.nome,
                saida: rota.saida,
                campus: rota.campus,
                pontos: rota.pontos,
              )
              .toJson();

      if (rota.pontos.isEmpty) {
        return Failure(Exception("Adicione pelo menos um ponto"));
      }
      if (rota.pontos.length > 10) {
        return Failure(Exception("O número máximo de pontos é 10"));
      }

      // Atualiza o documento do usuário com as rotas modificadas
      await _storeService.updateDocument(
        collection: _collection,
        docId: userId,
        data: {'rotasCadastradas': rotasJson},
      );

      return Success(rota);
    } catch (e) {
      return Failure(Exception('Erro ao editar rota: $e'));
    }
  }

  @override
  AsyncResult<Unit> excluirRota(String userId, String rotaId) async {
    try {
      final doc = await _storeService.getDocumentById(
        collection: _collection,
        docId: userId,
      );

      if (!doc.exists) {
        return Failure(Exception('Usuário não encontrado'));
      }

      final userData = doc.data() as Map<String, dynamic>;
      final rotasJson = List<Map<String, dynamic>>.from(
        userData['rotasCadastradas'] ?? [],
      );
      rotasJson.removeWhere((r) => r['id'] == rotaId);

      await _storeService.updateDocument(
        collection: _collection,
        docId: userId,
        data: {'rotasCadastradas': rotasJson},
      );

      return const Success(unit);
    } catch (e) {
      return Failure(Exception('Erro ao excluir rota: $e'));
    }
  }
}
