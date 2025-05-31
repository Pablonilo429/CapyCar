import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/dtos/credentials_carro.dart';
import 'package:capy_car/domain/models/carro/carro.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class EditarCarroViewModel extends ChangeNotifier {
  AuthRepository _authRepository;

  EditarCarroViewModel(this._authRepository);

  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  CredentialsCarro credentials = CredentialsCarro();

  late final editarCarroCommand = Command1(_editarCarro);

  Future<void> init() async {
    await _recarregarRotas();
  }

  Future<void> _recarregarRotas() async {
    final result = await _authRepository.getUser();

    result.fold(
      (user) {
        _usuario = user;
        credentials = CredentialsCarro(
          marca: user.carro!.marca,
          modelo: user.carro!.modelo,
          cor: user.carro!.cor,
          placa: user.carro!.placa,
        );

        notifyListeners();
      },
      (exception) {
        debugPrint('Erro ao recarregar carro: ${exception.toString()}');
      },
    );
  }

  AsyncResult<Usuario> _editarCarro(CredentialsCarro credentials) async {
    return await _authRepository.editarCarro(credentials);
  }

  void setMarca(String marca) {
    credentials.setMarca(marca);
    notifyListeners();
  }
  void setModelo(String modelo) {
    credentials.setModelo(modelo);
    notifyListeners();
  }
  void setCor(String cor) {
    credentials.setCor(cor);
    notifyListeners();
  }
  void setPlaca(String placa) {
    credentials.setPlaca(placa);
    notifyListeners();
  }
}
