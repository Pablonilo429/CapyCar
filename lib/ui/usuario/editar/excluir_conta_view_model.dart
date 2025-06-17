import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class ExcluirContaViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ExcluirContaViewModel(this._authRepository);

  late final excluirContaCommand = Command1(excluirConta);

  AsyncResult<Unit> excluirConta(String password) {
    return _authRepository.excluirConta(password);
  }
}
