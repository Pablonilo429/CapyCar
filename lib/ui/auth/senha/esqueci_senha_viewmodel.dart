import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/dtos/credentials_esqueci_senha.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class EsqueciSenhaViewModel extends ChangeNotifier{
  final AuthRepository _authRepository;

  EsqueciSenhaViewModel(this._authRepository);

  late final esqueciSenhaCommand = Command1(_esqueciSenha);

  AsyncResult<Unit> _esqueciSenha(CredentialsEsqueciSenha credentials){
    return _authRepository.esqueciSenha(credentials);
  }
}