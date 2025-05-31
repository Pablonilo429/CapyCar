import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:capy_car/data/services/cloudinary/cloudinary_service.dart';
import 'package:capy_car/data/services/firebase/auth_service.dart';
import 'package:capy_car/domain/dtos/credentials_alterar_senha.dart';
import 'package:capy_car/domain/dtos/credentials_carro.dart';
import 'package:capy_car/domain/dtos/credentials_editar_usuario.dart';
import 'package:capy_car/domain/dtos/credentials_esqueci_senha.dart';
import 'package:capy_car/domain/dtos/credentials_localizacao.dart';
import 'package:capy_car/domain/dtos/credentials_login.dart';
import 'package:capy_car/domain/dtos/credentials_registrar.dart';
import 'package:capy_car/domain/models/carro/carro.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/validators/credentials_alterar_senha_validator.dart';
import 'package:capy_car/domain/validators/credentials_editar_usuario_validator.dart';
import 'package:capy_car/domain/validators/credentials_login_validator.dart';
import 'package:capy_car/domain/validators/credentials_registrar_validator.dart';
import 'package:capy_car/utils/CompactarImagem.dart';
import 'package:capy_car/utils/validation/LucidValidatorExtension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';
import 'package:result_dart/src/unit.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class RemoteAuthRepository implements AuthRepository {
  final FirebaseAuthService _authService;
  final CloudinaryService _cloudinaryService;
  final _streamController = StreamController<Usuario?>.broadcast();

  RemoteAuthRepository(this._authService, this._cloudinaryService) {
    _authService.authStateChanges().listen((user) async {
      if (user != null && user.emailVerified) {
        final usuario = await _authService.getUsuarioData(user.uid);
        _streamController.add(usuario);
      } else {
        _streamController.add(null);
      }
    });
  }

  @override
  AsyncResult<Usuario> login(CredentialsLogin credentials) async {
    final validated = await CredentialsLoginValidator().validateResult(
      credentials,
    );
    return await validated.fold((creds) async {
      try {
        final user = await _authService.signInWithEmailAndPassword(
          creds.email,
          creds.password,
        );

        if (!(user?.emailVerified ?? false)) {
          await user?.sendEmailVerification(); // reenviar verificação
          return Failure(
            Exception('Email não verificado. Verifique sua caixa de entrada.'),
          );
        }

        if (user == null)
          return Failure(Exception('Erro ao autenticar usuário'));

        final usuario = await _authService.getUsuarioData(user.uid);
        if (usuario is! Usuario) return Failure(Exception('Usuário inválido'));

        if(usuario.isPrimeiroLogin){
          await FirebaseChatCore.instance.createUserInFirestore(
            types.User(
              firstName: usuario.nomeSocial?.isEmpty ?? true ? usuario.nome : usuario.nomeSocial,
              id: usuario.uId, // UID from Firebase Authentication
              imageUrl: "https://res.cloudinary.com/ddemkhgt4/image/upload/v1746151975/logo_capy_car.png",
            ),
          );
        }

        return Success(usuario);
      } catch (e) {
        return Failure(Exception(e.toString()));
      }
    }, (err) => Failure(err));
  }

  @override
  AsyncResult<Unit> registar(CredentialsRegistrar credentials) async {
    try {
      final user = await _authService.registerWithEmailAndPassword(
        credentials.emailInstitucional,
        credentials.senha,
        {
          'nomeCompleto': credentials.nomeCompleto,
          'nomeSocial': credentials.nomeSocial ?? '',
          'dataNascimento': credentials.dataNascimento?.toIso8601String(),
          'numeroCelular': credentials.numeroCelular ?? '',
          'isPassageiro': true,
          'isMotorista': false,
          'emailInstitucional': credentials.emailInstitucional,
          'isAtivo': true,
          'isPrimeiroLogin': true,
          'fotoPerfilUrl': '',
        },
      );

      if (user == null) return Failure(Exception('Erro ao registrar usuário'));

      return Success.unit();
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  AsyncResult<Usuario> getUser() async {
    try {
      final user = _authService.getCurrentUser();
      if (user == null) return Failure(Exception('Usuário não autenticado'));

      final usuario = await _authService.getUsuarioData(user.uid);
      if (usuario is! Usuario) {
        return Failure(Exception('Usuário inválido'));
      }

      return Success(usuario);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  AsyncResult<Unit> logout() async {
    try {
      await _authService.signOut();
      return Success(unit);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  AsyncResult<Unit> registrarFoto(Uint8List foto) async {
    var _compactarImagem = CompactarImagem();
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        return Failure(Exception('Usuário não autenticado'));
      }


      final userId = currentUser.uid;
      var imagemComprimida = await _compactarImagem.comprimirList(foto);


      if (imagemComprimida.lengthInBytes > 5 * 1024 * 1024) {
        return Failure(Exception('Imagem maior que 5 MB. Envie outra imagem'));
      }

      final imageUrl = await _cloudinaryService.uploadImageFromBytes(
        imagemComprimida,
        userId,
      );

      if (imageUrl == null) {
        return Failure(Exception('Falha ao enviar imagem'));
      }

      await _authService.updateUsuario(userId, {'fotoPerfilUrl': imageUrl});
      return Success(unit);
    } catch (e) {
      return Failure(Exception('Erro ao registrar foto: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<Unit> excluirFoto(String urlFoto) async {
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final userId = currentUser.uid;
      final sucesso = await _cloudinaryService.deleteImage(userId, urlFoto);

      if (!sucesso) {
        return Failure(Exception('Não foi possível excluir a imagem'));
      }

      await _authService.updateUsuario(userId, {'fotoPerfilUrl': ''});
      return Success(unit);
    } catch (e) {
      return Failure(Exception('Erro ao excluir foto: ${e.toString()}'));
    }
  }

  @override
  Stream<Usuario?> userObserver() => _streamController.stream;

  void dispose() => _streamController.close();

  @override
  AsyncResult<Usuario> editarUsuario(
    CredentialsEditarUsuario credentials,
  ) async {
    final validated = await CredentialsEditarUsuarioValidator().validateResult(
      credentials,
    );

    return await validated.fold((creds) async {
      try {
        final currentUser = _authService.getCurrentUser();
        if (currentUser == null) {
          return Failure(Exception('Usuário não autenticado'));
        }

        final userId = currentUser.uid;

        final updateData = {
          'nomeSocial': creds.nomeSocial,
          'numeroCelular': creds.numeroCelular,
          'fotoPerfilUrl': creds.urlFotoPerfil,
          'campus': creds.campus,
          'cidade': creds.cidade,
          'bairro': creds.bairro,
          'isPrimeiroLogin': false,
        };

        // Remove campos nulos
        updateData.removeWhere((key, value) => value == null);

        await _authService.updateUsuario(userId, updateData);

        final usuarioAtualizado = await _authService.getUsuarioData(userId);
        if (usuarioAtualizado == null) {
          return Failure(
            Exception('Erro ao recuperar dados atualizados do usuário'),
          );
        }

        _streamController.add(usuarioAtualizado);

        return Success(usuarioAtualizado);
      } catch (e) {
        return Failure(Exception('Erro ao editar usuário: ${e.toString()}'));
      }
    }, (err) => Failure(err));
  }

  @override
  AsyncResult<Unit> alterarSenha(CredentialsAlterarSenha credentials) async {
    final validated = await CredentialsAlterarSenhaValidator().validateResult(
      credentials,
    );

    return await validated.fold((creds) async {
      try {
        await _authService.changePassword(
          currentPassword: creds.senhaAtual,
          newPassword: creds.novaSenha,
        );

        return Success(unit);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          return Failure(Exception('Senha atual incorreta'));
        }
        return Failure(Exception(e.message ?? 'Erro ao alterar a senha'));
      } catch (e) {
        return Failure(Exception('Erro inesperado: ${e.toString()}'));
      }
    }, (err) => Failure(err));
  }

  @override
  AsyncResult<Usuario> getUserById(String userId) async {
    try {
      final usuario = await _authService.getUsuarioData(userId);

      if (usuario == null) {
        return Failure(Exception('Usuário não encontrado'));
      }

      return Success(usuario);
    } catch (e) {
      return Failure(
        Exception('Erro ao buscar usuário por ID: ${e.toString()}'),
      );
    }
  }

  @override
  AsyncResult<Unit> esqueciSenha(CredentialsEsqueciSenha credentials) async {
    try {
      await _authService.sendPasswordResetEmail(email: credentials.email);
      return Success(unit);
    } on FirebaseAuthException catch (e) {
      return Failure(
        Exception(
          e.message ?? 'Erro ao enviar e-mail de redefinição de senha.',
        ),
      );
    } catch (e) {
      // Fallback para erros não previstos
      return Failure(Exception('Erro inesperado ao tentar redefinir a senha.'));
    }
  }

  @override
  AsyncResult<Usuario> setPrimeiroLogin() async {
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final userId = currentUser.uid;

      final updateData = {'isPrimeiroLogin': false};

      updateData.removeWhere((key, value) => value == null);

      await _authService.updateUsuario(userId, updateData);

      final usuarioAtualizado = await _authService.getUsuarioData(userId);
      if (usuarioAtualizado == null) {
        return Failure(
          Exception('Erro ao recuperar dados atualizados do usuário'),
        );
      }

      _streamController.add(usuarioAtualizado);

      return Success(usuarioAtualizado);
    } catch (e) {
      return Failure(Exception('Erro ao editar usuário: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<Usuario> registarCarro(CredentialsCarro credentials) async {
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final userId = currentUser.uid;

      final carro = Carro(
        marca: credentials.marca,
        modelo: credentials.modelo,
        cor: credentials.cor,
        placa: credentials.placa,
      );

      await _authService.updateUsuario(userId, {
        'carro': carro.toJson(),
        'isMotorista': true,
      });

      final usuarioAtualizado = await _authService.getUsuarioData(userId);
      if (usuarioAtualizado == null) {
        return Failure(
          Exception('Erro ao recuperar dados atualizados do usuário'),
        );
      }

      _streamController.add(usuarioAtualizado);

      return Success(usuarioAtualizado);
    } catch (e) {
      return Failure(Exception('Erro ao registrar carro: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<Usuario> editarCarro(CredentialsCarro credentials) async {
    // Neste cenário, como o carro já está registrado, apenas atualizamos os dados
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final userId = currentUser.uid;

      final carro = Carro(
        marca: credentials.marca,
        modelo: credentials.modelo,
        cor: credentials.cor,
        placa: credentials.placa,
      );

      await _authService.updateUsuario(userId, {'carro': carro.toJson()});

      final usuarioAtualizado = await _authService.getUsuarioData(userId);
      if (usuarioAtualizado == null) {
        return Failure(
          Exception('Erro ao recuperar dados atualizados do usuário'),
        );
      }

      _streamController.add(usuarioAtualizado);

      return Success(usuarioAtualizado);
    } catch (e) {
      return Failure(Exception('Erro ao editar carro: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<Usuario> registarLocalizacao(
    CredentialsLocalizacao credentials,
  ) async {
    try {
      final currentUser = _authService.getCurrentUser();
      if (currentUser == null) {
        return Failure(Exception('Usuário não autenticado'));
      }

      final userId = currentUser.uid;

      await _authService.updateUsuario(userId, {
        'campus': credentials.campus,
        'cidade': credentials.cidade,
        'bairro': credentials.bairro,
      });

      final usuarioAtualizado = await _authService.getUsuarioData(userId);
      if (usuarioAtualizado == null) {
        return Failure(
          Exception('Erro ao recuperar dados atualizados do usuário'),
        );
      }

      _streamController.add(usuarioAtualizado);

      return Success(usuarioAtualizado);
    } catch (e) {
      return Failure(
        Exception('Erro ao registrar localização: ${e.toString()}'),
      );
    }
  }
}
