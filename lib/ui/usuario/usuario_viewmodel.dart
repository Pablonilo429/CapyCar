import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';


class UsuarioViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  UsuarioViewModel(this._authRepository);

  late final getUsuarioDataCommand = Command1(_getData);

  AsyncResult<Usuario> _getData(String userId){
    return _authRepository.getUserById(userId);
  }


}
