import 'package:capy_car/domain/dtos/credentials_registrar.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsRegistrarValidator
    extends LucidValidator<CredentialsRegistrar> {
  CredentialsRegistrarValidator() {
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
      (c) => c.emailInstitucional,
      key: 'emailInstitucional',
    ).notEmpty().validEmail().matchesPattern(
      r'^[\w\.-]+@([\w-]+\.)?ufrrj\.br$',
      message: 'O e-mail deve pertencer ao domínio ufrrj.br',
    );

    ruleFor(
      (c) => c.numeroCelular,
      key: 'numeroCelular',
    ).minLength(9).maxLength(11);

    ruleFor((c) => c.senha, key: 'senha')
        .mustHaveSpecialCharacter()
        .mustHaveNumber()
        .mustHaveUppercase()
        .mustHaveLowercase()
        .maxLength(32)
        .minLength(6);

    ruleFor(
      (c) => c.confirmarSenha,
      key: 'confirmarSenha',
    ).equalTo((c) => c.senha);
  }
}
