import 'dart:async';

import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import 'package:capy_car/data/repositories/carona/carona_repository.dart';
import 'package:capy_car/domain/models/carona/carona.dart';

class CaronaHomeViewModel extends ChangeNotifier {
  final CaronaRepository _caronaRepository;
  final AuthRepository _authRepository;
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  late final StreamSubscription _userSubscription;

  CaronaHomeViewModel(this._caronaRepository, this._authRepository){
    _userSubscription = _authRepository.userObserver().listen((usuario) {
      _usuario = usuario;
      notifyListeners();
    });
  }

  final ValueNotifier<String?> campusSelecionado = ValueNotifier('Seropédica');
  final ValueNotifier<bool?> isVolta = ValueNotifier(false);
  final ValueNotifier<String> textoBusca = ValueNotifier('');
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
      if (campusSelecionado.value!.isEmpty) {
          campusSelecionado.value = usuario!.campus;
      }
      final result = await _caronaRepository.getAllCarona(
        campusSelecionado.value,
        isVolta.value,
        textoBusca.value.isNotEmpty ? textoBusca.value : null,
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

  void setCampus(String novoCampus) {
    campusSelecionado.value = novoCampus;
    buscarCaronasCommand.execute(); // corrigido
  }

  void toggleVolta(bool value) {
    isVolta.value = value;
    buscarCaronasCommand.execute(); // corrigido
  }

  void setTextoBusca(String novoTexto) {
    textoBusca.value = novoTexto;
    buscarCaronasCommand.execute(); // corrigido
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
