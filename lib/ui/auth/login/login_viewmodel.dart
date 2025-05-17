import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/dtos/credentials_login.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';


class LoginViewModel extends ChangeNotifier{
  final AuthRepository _authRepository;

  LoginViewModel(this._authRepository);

  late final loginCommand = Command1(_login);

  AsyncResult<Usuario> _login(CredentialsLogin credentials){
    return _authRepository.login(credentials);
  }

}