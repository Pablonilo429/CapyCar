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

  final StoreService _storeService = StoreService();
  final String _collection = 'caronas';

  /// Cria uma nova carona com validação
  @override
  AsyncResult<Carona> criarCarona(CredentialsCarona credentials) async {
    final validated = await CredentialsCaronaValidator().validateResult(
      credentials,
    );
    final validatedRota = await CredentialsRotaValidator().validateResult(
      credentials.rota!,
    );

    return await validated.fold((creds) async {
      return await validatedRota.fold((_) async {
        try {
          // Verifica se já há carona ativa (não finalizada) do tipo correspondente (ida/volta) para o motorista
          final caronasAtuais = await _storeService.getDocumentsWithFilter(
            collection: _collection,
            filters: {
              'isFinalizada': false,
              'isVolta': creds.isVolta!,
              'motoristaId': creds.idMotorista,
            },
          );

          for (final doc in caronasAtuais) {
            final data = doc.data() as Map<String, dynamic>;
            final horarioChegada =
                (data['horarioChegada'] as Timestamp).toDate();

            if (horarioChegada.isBefore(DateTime.now())) {
              await _storeService.updateDocument(
                collection: _collection,
                docId: doc.id,
                data: {'isFinalizada': true, 'status': 'concluída'},
              );
            } else {
              return Failure(
                Exception(
                  'Você já possui uma carona ${creds.isVolta! ? 'de volta' : 'de ida'} ativa.',
                ),
              );
            }
          }

          final carona = Carona(
            id: '',
            motoristaId: creds.idMotorista,
            rota: Rota(
              campus: creds.rota!.campus,
              pontos: creds.rota!.pontos,
              saida: creds.rota!.cidadeSaida,
            ),
            qtdePassageiros: creds.qtdePassageiros,
            isVolta: creds.isVolta!,
            idsPassageiros: [],
            status: 'ativa',
            horarioSaidaCarona: creds.horarioSaida!,
            horarioChegada: creds.horarioChegada!,
            dataCarona: DateTime.now(),
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
          return Failure(Exception('Erro ao criar carona: $e'));
        }
      }, (rotaError) => Failure(rotaError));
    }, (err) => Failure(err));
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

  /// Lista caronas com paginação e filtro opcional por rota
  @override
  AsyncResult<List<Carona>> getAllCarona({
    int page = 1,
    int pageSize = 10,
    String? rotaFiltro,
    String? campus,
    bool? isVolta,
  }) async {
    try {
      final docs = await _storeService.getDocumentsWithPaginationAndFilter(
        collection: _collection,
        page: page,
        pageSize: pageSize,
        rotaFiltro: rotaFiltro,
        campusFiltro: campus,
        isVoltaFiltro: isVolta,
      );

      final caronas =
          docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Carona.fromJson(data).copyWith(id: doc.id);
          }).toList();

      return Success(caronas);
    } catch (e) {
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
        final horarioChegada = (data['horarioChegada'] as Timestamp).toDate();

        if (horarioChegada.isBefore(DateTime.now())) {
          await _storeService.updateDocument(
            collection: _collection,
            docId: doc.id,
            data: {'isFinalizada': true, 'status': 'concluída'},
          );
        } else {
          return Failure(
            Exception(
              'O usuário já está em uma carona ${isVolta ? 'de volta' : 'de ida'} não finalizada.',
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
