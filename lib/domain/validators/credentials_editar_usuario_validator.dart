import 'package:capy_car/domain/dtos/credentials_editar_usuario.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsEditarUsuarioValidator
    extends LucidValidator<CredentialsEditarUsuario> {
  CredentialsEditarUsuarioValidator() {
    final now = DateTime.now();


    ruleFor((c) => c.nomeSocial, key: 'nomeSocial').maxLength(200);


    ruleFor(
      (c) => c.numeroCelular,
      key: 'numeroCelular',
    ).validPhoneBR(message: "Insira corretamente o número de celular incluíndo DDD");

    ruleFor(
      (c) => c.campus,
      key: 'campus',
    ).notEmpty().maxLength(50).minLength(1);
    ruleFor(
      (c) => c.cidade,
      key: 'cidade',
    ).notEmpty().maxLength(100).minLength(1);
    ruleFor(
      (c) => c.bairro,
      key: 'bairro',
    ).notEmpty().maxLength(100).minLength(1);
  }
}
