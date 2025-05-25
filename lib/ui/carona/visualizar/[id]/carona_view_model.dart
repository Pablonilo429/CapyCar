import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/data/repositories/carona/carona_repository.dart';
import 'package:capy_car/domain/models/carona/carona.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CaronaViewModel extends ChangeNotifier {
  final CaronaRepository _caronaRepository;
  final AuthRepository _authRepository;

  CaronaViewModel(this._caronaRepository, this._authRepository);

  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  Usuario? _motorista;

  Usuario? get motorista => _motorista;

  Carona? _carona;

  Carona? get carona => _carona;

  List<Usuario> _passageiros = [];

  List<Usuario> get passageiros => _passageiros;

  late final buscarCaronaCommand = Command1(_buscarCarona);
  late final entrarCaronaCommand = Command0(_entrarCarona);
  late final sairCaronaCommand = Command0(_sairCarona);
  late final cancelarCaronaCommand = Command0(_cancelarCarona);

  AsyncResult<Carona> _buscarCarona(String id) async {
    final resultUsuario = await _authRepository.getUser();

    resultUsuario.fold(
      (user) {
        _usuario = user;
        notifyListeners();
      },
      (exception) {
        debugPrint('Erro ao carregar usuário');
      },
    );

    final resultCarona = await _caronaRepository.getCarona(id);

    resultCarona.fold(
      (carona) {
        _carona = carona;
        notifyListeners();
      },
      (exception) {
        debugPrint('Erro ao carregar carona');
      },
    );

    // Buscar passageiros da carona
    if (carona!.idsPassageiros?.isNotEmpty ?? false) {
      final passageirosFuturos = await Future.wait(
        carona!.idsPassageiros!.map(_authRepository.getUserById),
      );

      _passageiros =
          passageirosFuturos
              .where((result) => result.isSuccess())
              .map((result) => result.getOrThrow())
              .toList();

      notifyListeners();
    }

    final resultMotorista = await _authRepository.getUserById(
      carona!.motoristaId,
    );

    resultMotorista.fold(
      (motorista) {
        _motorista = motorista;
        notifyListeners();
      },
      (exception) {
        debugPrint('Erro ao carregar motorista');
      },
    );

    return resultCarona;
  }

  AsyncResult<Unit> _entrarCarona() async {
    return await _caronaRepository.entrarCarona(usuario!.uId, carona!.id!);
  }

  AsyncResult<Unit> _sairCarona() async {
    return await _caronaRepository.sairCarona(
      caronaId: carona!.id!,
      userId: usuario!.uId,
    );
  }

  AsyncResult<Unit> _cancelarCarona() async {
    return await _caronaRepository.cancelarCarona(carona!.id!);
  }
}
