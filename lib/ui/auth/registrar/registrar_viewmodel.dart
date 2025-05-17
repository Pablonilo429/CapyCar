import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/dtos/credentials_registrar.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class RegistrarViewModel extends ChangeNotifier{
  final AuthRepository _authRepository;

  RegistrarViewModel(this._authRepository);

  late final registrarCommand = Command1(_registrar);

  AsyncResult<Usuario> _registrar(CredentialsRegistrar credentials){
    return _authRepository.registar(credentials);
  }

}