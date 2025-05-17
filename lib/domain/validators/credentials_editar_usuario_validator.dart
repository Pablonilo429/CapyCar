import 'package:capy_car/domain/dtos/credentials_editar_usuario.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsEditarUsuarioValidator
    extends LucidValidator<CredentialsEditarUsuario> {
  CredentialsEditarUsuarioValidator() {
    final now = DateTime.now();

    ruleFor(
      (c) => c.nomeCompleto,
      key: 'nomeCompleto',
    ).notEmpty().minLength(1).maxLength(200);

    ruleFor((c) => c.nomeSocial, key: 'nomeSocial').minLength(1).maxLength(200);

    ruleFor((c) => c.dataNascimento, key: 'dateOfBirth')
        .lessThan(
          DateTime(now.year - 18, now.month, now.day),
          message: "É necessário ter 18 anos ou mais",
        )
        .isNotNull(message: "Data de nascimento é obrigatória");

    ruleFor(
      (c) => c.numeroCelular,
      key: 'numeroCelular',
    ).minLength(9).maxLength(11);

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
