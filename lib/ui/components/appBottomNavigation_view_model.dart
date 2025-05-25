import 'dart:async';

import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';


class AppBottomNavigationViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  late final StreamSubscription _userSubscription;


  AppBottomNavigationViewModel(this._authRepository) {
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
