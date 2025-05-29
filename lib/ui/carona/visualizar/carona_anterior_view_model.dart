import 'dart:async';

import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import 'package:capy_car/data/repositories/carona/carona_repository.dart';
import 'package:capy_car/domain/models/carona/carona.dart';

class CaronaAnteriorViewModel extends ChangeNotifier {
  final CaronaRepository _caronaRepository;
  final AuthRepository _authRepository;
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  late final StreamSubscription _userSubscription;

  CaronaAnteriorViewModel(this._caronaRepository, this._authRepository) {
    _userSubscription = _authRepository.userObserver().listen((usuario) {
      _usuario = usuario;
      notifyListeners();
    });
  }

  final ValueNotifier<List<Carona?>> caronas = ValueNotifier([]);
  final ValueNotifier<Map<String, String>> fotosUsuarios = ValueNotifier({});
  final isLoading = ValueNotifier<bool>(true);

  late final buscarCaronasCommand = Command0(_buscarCaronas);

  AsyncResult<List<Carona?>> _buscarCaronas() async {
    // Limpa imediatamente para forçar a UI a mostrar "nenhuma carona"
    isLoading.value = true;
    caronas.value = [];
    // _buscarUsuario();
    try {
      final result = await _caronaRepository.getAllByUserCarona(
        isFinalizada: true,
        userId: usuario!.uId,
      );

      return result.fold((lista) async {
        final caronasFiltradas = lista.whereType<Carona>().toList();
        caronas.value = caronasFiltradas;

        final motoristasIds =
        caronasFiltradas.map((c) => c.motoristaId).toSet().toList();

        final mapa = <String, String>{};
        for (final id in motoristasIds) {
          final usuarioResult = await _authRepository.getUserById(id);
          usuarioResult.fold((usuario) {
            if (usuario.fotoPerfilUrl != null) {
              mapa[id] = usuario.fotoPerfilUrl!;
            }
          }, (e) => debugPrint("Erro ao buscar foto do usuário $id: $e"));
        }

        fotosUsuarios.value = mapa;
        return Success(caronasFiltradas);
      }, (e) => Failure(e));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
