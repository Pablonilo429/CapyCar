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
  late final sairCaronaCommand = Command1(_sairCarona);
  late final removerPassageiroCaronaCommand = Command1(
    _removerPassageiroCarona,
  );
  late final cancelarCaronaCommand = Command0(_cancelarCarona);

  AsyncResult<Carona> _buscarCarona(String id) async {
    final resultUsuario = await _authRepository.getUser();
    resultUsuario.fold(
      (user) => _usuario = user,
      (_) => debugPrint('Erro ao carregar usuário'),
    );

    // Limpar dados antigos antes de buscar novos para evitar mostrar dados inconsistentes rapidamente
    // _carona = null;
    // _passageiros = [];
    // _motorista = null;
    // notifyListeners(); // Opcional: notificar que está limpando/carregando

    final resultCarona = await _caronaRepository.getCarona(id);
    if (!resultCarona.isSuccess()) {
      _carona = null; // Limpar se a busca falhar
      _passageiros = [];
      _motorista = null;
      notifyListeners();
      return resultCarona;
    }

    final caronaAtualizada = resultCarona.getOrThrow();
    _carona = caronaAtualizada;
    _passageiros = []; // Limpar antes de preencher

    if (caronaAtualizada.idsPassageiros?.isNotEmpty ?? false) {
      final passageirosFuturos = await Future.wait(
        caronaAtualizada.idsPassageiros!.map(_authRepository.getUserById),
      );
      _passageiros =
          passageirosFuturos
              .where((result) => result.isSuccess())
              .map((result) => result.getOrThrow())
              .toList();
    }

    final resultMotorista = await _authRepository.getUserById(
      caronaAtualizada.motoristaId,
    );
    resultMotorista.fold((motorista) => _motorista = motorista, (_) {
      _motorista = null; // Limpar se falhar
      debugPrint('Erro ao carregar motorista');
    });

    notifyListeners();
    return resultCarona;
  }

  AsyncResult<Unit> _entrarCarona() async {
    if (_carona == null || _usuario == null) {
      debugPrint("Erro: Carona ou Usuário nulo antes de entrar na carona.");
      return Failure(Exception("Dados da carona ou usuário indisponíveis."));
    }

    final result = await _caronaRepository.entrarCarona(
      _usuario!.uId,
      _carona!.id!,
    );

    return await result.fold((success) async {
      // Recarregar os dados da carona para refletir a entrada
      await _buscarCarona(
        _carona!.id!,
      ); // _buscarCarona já chama notifyListeners
      return Success.unit();
    }, (failure) => Failure(failure));
  }

  AsyncResult<Unit> _sairCarona(String passageiroId) async {
    if (_carona == null || _usuario == null) {
      debugPrint("Erro: Carona ou Usuário nulo antes de sair da carona.");
      return Failure(Exception("Dados da carona ou usuário indisponíveis."));
    }

    final result = await _caronaRepository.sairCarona(
      caronaId: _carona!.id!,
      userId: passageiroId,
    );

    return await result.fold((success) async {
      // Recarregar os dados da carona para refletir a saída
      await _buscarCarona(
        _carona!.id!,
      ); // _buscarCarona já chama notifyListeners
      return Success.unit();
    }, (failure) => Failure(failure));
  }

  AsyncResult<Unit> _removerPassageiroCarona(String passageiroId) async {
    if (_carona == null) {
      debugPrint("Erro: Carona nula antes de remover passageiro.");
      return Failure(Exception("Dados da carona indisponíveis."));
    }

    final result = await _caronaRepository.sairCarona(
      // sairCarona é usado para remover também
      caronaId: _carona!.id!,
      userId: passageiroId,
    );

    return await result.fold((success) async {
      // Recarregar os dados da carona para refletir a remoção
      await _buscarCarona(
        _carona!.id!,
      ); // _buscarCarona já chama notifyListeners
      return Success.unit();
    }, (failure) => Failure(failure));
  }

  AsyncResult<Unit> _cancelarCarona() async {
    if (_carona == null) {
      debugPrint("Erro: Carona nula antes de cancelar.");
      return Failure(Exception("Dados da carona indisponíveis."));
    }
    final caronaId = _carona!.id!; // Salvar ID caso _carona seja nulificado
    final result = await _caronaRepository.cancelarCarona(caronaId);

    return result.fold((success) {
      // Após cancelar, os dados desta carona não são mais relevantes aqui.
      // Poderia limpar o estado local ou deixar que a navegação na View cuide disso.
      _carona = null;
      _passageiros = [];
      _motorista = null;
      notifyListeners(); // Notificar que a carona foi removida/cancelada
      return Success.unit();
    }, (failure) => Failure(failure));
  }
}
