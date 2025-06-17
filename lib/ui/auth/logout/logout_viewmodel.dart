import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class LogoutViewModel extends ChangeNotifier{
  final AuthRepository _authRepository;
  LogoutViewModel(this._authRepository);

  late final logoutCommand = Command0(_logout);

  AsyncResult<Unit> _logout(){
    return _authRepository.logout();
  }
}