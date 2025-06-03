import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CadastrarPapelViewModel extends ChangeNotifier {
  AuthRepository _authRepository;

  CadastrarPapelViewModel(this._authRepository);

  late final setPapelCommand = Command0(_registarPapel);

  AsyncResult<Usuario> _registarPapel() {
    return _authRepository.setPrimeiroLogin();
  }
}
