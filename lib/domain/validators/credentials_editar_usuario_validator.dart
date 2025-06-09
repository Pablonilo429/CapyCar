import 'package:capy_car/domain/dtos/credentials_editar_usuario.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsEditarUsuarioValidator
    extends LucidValidator<CredentialsEditarUsuario> {
  CredentialsEditarUsuarioValidator() {
    final now = DateTime.now();


    ruleFor((c) => c.nomeSocial, key: 'nomeSocial').maxLength(200, message: "O nome social deve ter no máximo 200 caracteres");


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
    ).notEmpty(message: "O bairro é obrigatório").maxLength(100, message: "O bairro deve ter no máximo 100 caracteres").minLength(1, message: "O bairro deve ter pelo menos 1 caractere");
  }
}
