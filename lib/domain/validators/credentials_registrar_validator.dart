import 'package:capy_car/domain/dtos/credentials_registrar.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsRegistrarValidator
    extends LucidValidator<CredentialsRegistrar> {
  CredentialsRegistrarValidator() {
    final now = DateTime.now();

    ruleFor(
      (c) => c.nomeCompleto,
      key: 'nomeCompleto',
    ).notEmpty(message: "O nome completo é obrigatório").minLength(1, message: "O nome completo deve ter pelo menos 1 caractere").maxLength(200, message: "O nome completo deve ter no máximo 200 caracteres");

    ruleFor((c) => c.nomeSocial, key: 'nomeSocial').maxLength(200);

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
    ).validPhoneBR(message: "Insira corretamente o número de celular incluíndo DDD");

    ruleFor((c) => c.senha, key: 'senha')
        .mustHaveSpecialCharacter(message: "A senha deve conter pelo menos um caractere especial")
        .mustHaveNumber(message: "A senha deve conter pelo menos um número")
        .mustHaveUppercase(message: "A senha deve conter pelo menos uma letra maiúscula")
        .mustHaveLowercase(message: "A senha deve conter pelo menos uma letra minúscula")
        .maxLength(32, message: "A senha deve ter no máximo 32 caracteres")
        .minLength(6, message: "A senha deve ter pelo menos 6 caracteres");

    ruleFor(
      (c) => c.confirmarSenha,
      key: 'confirmarSenha',
    ).equalTo((c) => c.senha, message: "As senhas precisam ser iguais");
  }
}
