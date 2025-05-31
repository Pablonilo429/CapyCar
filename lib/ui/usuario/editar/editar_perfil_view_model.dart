import 'dart:typed_data';

import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/dtos/credentials_carro.dart';
import 'package:capy_car/domain/dtos/credentials_editar_usuario.dart';
import 'package:capy_car/domain/models/carro/carro.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class EditarPerfilViewModel extends ChangeNotifier {
  AuthRepository _authRepository;

  EditarPerfilViewModel(this._authRepository);

  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  CredentialsEditarUsuario credentials = CredentialsEditarUsuario();

  late final editarUsuarioCommand = Command1(_editarUsuario);
  late final editarFotoCommand = Command2(_editarFoto);
  late final excluirFotoCommand = Command1(_excluirFoto);

  Future<void> init() async {
    await _recarregarUsuario();
  }

  Future<void> _recarregarUsuario() async {
    final result = await _authRepository.getUser();

    result.fold(
      (user) {
        _usuario = user;
        credentials = CredentialsEditarUsuario(
          nomeSocial: _usuario?.nomeSocial,
          numeroCelular: usuario?.numeroCelular,
          urlFotoPerfil: usuario?.fotoPerfilUrl,
          campus: usuario?.campus ?? "",
          cidade: usuario?.cidade ?? "",
          bairro: usuario?.bairro ?? "",
        );

        notifyListeners();
      },
      (exception) {
        debugPrint('Erro ao recarregar carro: ${exception.toString()}');
      },
    );
  }

  AsyncResult<Usuario> _editarUsuario(
    CredentialsEditarUsuario credentials,
  ) async {
    return await _authRepository.editarUsuario(credentials);
  }

  AsyncResult<Unit> _excluirFoto(String urlFoto) async {
     return await _authRepository.excluirFoto(urlFoto);
  }




  AsyncResult<Unit> _editarFoto(String? urlFoto, Uint8List foto) async {
    if(urlFoto != null){
      await _authRepository.excluirFoto(urlFoto);
    }
    return _authRepository.registrarFoto(foto);
  }

  void setNomeSocial(String nomeSocial) {
    credentials.setNomeSocial(nomeSocial);
    notifyListeners();
  }


  void setNumeroCelular(String numeroCelular) {
    credentials.setNumeroCelular(numeroCelular);
    notifyListeners();
  }

  void setUrlFotoPerfil(String fotoPerfilUrl) {
    credentials.setUrlFotoPerfil(fotoPerfilUrl);
    notifyListeners();
  }

  void setCampus(String campus) {
    credentials.setCampus(campus);
    notifyListeners();
  }

  void setCidade(String cidade) {
    credentials.setCidade(cidade);
    notifyListeners();
  }

  void setBairro(String bairro) {
    credentials.setBairro(bairro);
    notifyListeners();
  }
}
