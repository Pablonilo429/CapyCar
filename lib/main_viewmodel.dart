import 'dart:async';

import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:routefly/routefly.dart';

class MainViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  final Completer<void> _usuarioReady = Completer<void>();
  Future<void> get onUsuarioReady => _usuarioReady.future;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  late final StreamSubscription _userSubscription;

  MainViewModel(this._authRepository) {
    _userSubscription = _authRepository.userObserver().listen((usuario) {
      _usuario = usuario;
      if (!_usuarioReady.isCompleted) {
        _usuarioReady.complete();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}

