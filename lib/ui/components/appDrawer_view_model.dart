import 'dart:async';

import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import 'package:capy_car/data/repositories/carona/carona_repository.dart';
import 'package:capy_car/domain/models/carona/carona.dart';

class AppDrawerViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  late final StreamSubscription _userSubscription;


  AppDrawerViewModel(this._authRepository) {
    _userSubscription = _authRepository.userObserver().listen((usuario) {
      _usuario = usuario;
      notifyListeners();
    });
  }
  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
