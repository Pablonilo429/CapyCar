import 'dart:typed_data';

import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CadastarFotoViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  CadastarFotoViewModel(this._authRepository);

  late final cadastrarFotoCommand = Command1(_cadastrarFoto);


  AsyncResult<Unit> _cadastrarFoto(Uint8List foto) {
    return _authRepository.registrarFoto(foto);
  }


}
