import 'package:capy_car/domain/dtos/credentials_carona.dart';
import 'package:capy_car/domain/models/carona/carona.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class CaronaRepository {
  AsyncResult<Carona> criarCarona(CredentialsCarona credentials);

  AsyncResult<Carona> editarCarona(Carona carona);

  AsyncResult<Unit> sairCarona({
    required String caronaId,
    required String userId,
  });

  AsyncResult<Unit> entrarCarona(String userId, String caronaId);

  AsyncResult<Unit> cancelarCarona(String id);

  AsyncResult<Carona> getCarona(String id);

  AsyncResult<List<Carona?>> getAllCarona();
}
