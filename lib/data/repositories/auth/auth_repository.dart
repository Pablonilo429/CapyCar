import 'package:capy_car/domain/dtos/credentials_login.dart';
import 'package:capy_car/domain/dtos/credentials_registrar.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:result_dart/result_dart.dart';


abstract interface class AuthRepository{
  AsyncResult<Usuario> login(CredentialsLogin credentials);
  AsyncResult<Unit> logout();
  AsyncResult<Usuario> registar(CredentialsRegistrar credentials);
  AsyncResult<Usuario> getUser();
  Stream<Usuario> userObserver();
  

}