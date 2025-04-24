import 'package:capy_car/domain/dtos/credentials_rota.dart';
import 'package:capy_car/domain/models/rota/rota.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class RotaRepository {
  AsyncResult<Rota> criarRota(String userId, CredentialsRota credentials);

  AsyncResult<Rota> editarRota(String userId, Rota rota);

  AsyncResult<Unit> excluirRota(String userId, String rotaId);
}
