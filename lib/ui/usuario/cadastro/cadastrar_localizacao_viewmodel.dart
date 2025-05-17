import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/dtos/credentials_localizacao.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CadastrarLocalizacaoViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;

  CadastrarLocalizacaoViewmodel(this._authRepository);

  late final cadastrarLocalizacaoCommand = Command1(_registarLocalizacao);


  AsyncResult<Usuario> _registarLocalizacao(
    CredentialsLocalizacao credentials,
  ) {
    _authRepository.setPrimeiroLogin();
    return _authRepository.registarLocalizacao(credentials);
  }
}
