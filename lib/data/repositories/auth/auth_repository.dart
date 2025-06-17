import 'dart:typed_data';

import 'package:capy_car/domain/dtos/credentials_alterar_senha.dart';
import 'package:capy_car/domain/dtos/credentials_carro.dart';
import 'package:capy_car/domain/dtos/credentials_editar_usuario.dart';
import 'package:capy_car/domain/dtos/credentials_esqueci_senha.dart';
import 'package:capy_car/domain/dtos/credentials_localizacao.dart';
import 'package:capy_car/domain/dtos/credentials_login.dart';
import 'package:capy_car/domain/dtos/credentials_registrar.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:result_dart/result_dart.dart';

abstract interface class AuthRepository {
  AsyncResult<Usuario> login(CredentialsLogin credentials);

  AsyncResult<Unit> logout();

  AsyncResult<Unit> excluirFoto(String urlFoto);

  AsyncResult<Unit> alterarSenha(CredentialsAlterarSenha credentials);

  AsyncResult<Unit> esqueciSenha(CredentialsEsqueciSenha credentials);

  AsyncResult<Unit> registar(CredentialsRegistrar credentials);

  AsyncResult<Usuario> registarLocalizacao(CredentialsLocalizacao credentials);

  AsyncResult<Unit> registrarFoto(Uint8List foto);


  AsyncResult<Usuario> registarCarro(CredentialsCarro credentials);

  AsyncResult<Usuario> editarUsuario(CredentialsEditarUsuario credentials);

  AsyncResult<Usuario> editarCarro(CredentialsCarro credentials);

  AsyncResult<Usuario> getUser();

  AsyncResult<Usuario> getUserById(String userId);

  AsyncResult<Usuario> setPrimeiroLogin();

  AsyncResult<Unit> excluirConta(String password);

  Stream<Usuario?> userObserver();
}
