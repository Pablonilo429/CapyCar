import 'dart:async';

import 'package:capy_car/data/services/firebase/auth_service.dart';
import 'package:capy_car/domain/dtos/credentials_login.dart';
import 'package:capy_car/domain/dtos/credentials_registrar.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/domain/validators/credentials_login_validator.dart';
import 'package:capy_car/domain/validators/credentials_registrar_validator.dart';
import 'package:capy_car/utils/validation/LucidValidatorExtension.dart';
import 'package:result_dart/result_dart.dart';
import 'package:result_dart/src/unit.dart';

class RemoteAuthRepository implements AuthRepository {
  final FirebaseAuthService _authService;
  final _streamController = StreamController<Usuario>.broadcast();

  RemoteAuthRepository(this._authService) {
    _authService.authStateChanges().listen((user) async {
      if (user != null) {
        final usuario = await _authService.getUsuarioData(user.uid);
        if (usuario != null) {
          _streamController.add(usuario);
        }
      }
    });
  }

  @override
  AsyncResult<Usuario> login(CredentialsLogin credentials) async {
    final validated = await CredentialsLoginValidator().validateResult(credentials);
    return await validated.fold(
          (creds) async {
        try {
          final user = await _authService.signInWithEmailAndPassword(
            creds.email,
            creds.password,
          );

          if (user == null) return Failure(Exception('Erro ao autenticar usuário'));

          final usuario = await _authService.getUsuarioData(user.uid);
          if (usuario is! Usuario) return Failure(Exception('Usuário inválido'));

          return Success(usuario);
        } catch (e) {
          return Failure(Exception(e.toString()));
        }
      },
          (err) => Failure(err),
    );
  }


  @override
  AsyncResult<Usuario> registar(CredentialsRegistrar credentials) async {
    final validated = await CredentialsRegistrarValidator().validateResult(credentials);
    return await validated.fold(
          (creds) async {
        try {
          final user = await _authService.registerWithEmailAndPassword(
            creds.emailInstitucional,
            creds.senha,
            {
              'nomeCompleto': creds.nomeCompleto,
              'nomeSocial': creds.nomeSocial,
              'dataNascimento': creds.dataNascimento?.toIso8601String(),
              'numeroCelular': creds.numeroCelular,
              'isPassageiro': creds.isPassageiro,
              'isMotorista': creds.isMotorista,

            },
          );

          if (user == null) return Failure(Exception('Erro ao registrar usuário'));

          final usuario = await _authService.getUsuarioData(user.uid);
          if (usuario == null) return Failure(Exception('Erro ao recuperar dados do usuário'));

          return Success(usuario);
        } catch (e) {
          return Failure(Exception(e.toString()));
        }
      },
          (err) => Failure(err),
    );
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
  Stream<Usuario> userObserver() => _streamController.stream;


  void dispose() => _streamController.close();
}
