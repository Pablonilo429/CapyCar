import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/dtos/credentials_carro.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CadastrarCarroViewmodel extends ChangeNotifier{

  final AuthRepository _authRepository;

  CadastrarCarroViewmodel(this._authRepository);

  late final cadastrarLocalizacaoCommand = Command1(_registarCarro);

  AsyncResult<Usuario> _registarCarro(
      CredentialsCarro credentials,
      ) {
    return _authRepository.registarCarro(credentials);
  }


}