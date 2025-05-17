import 'package:capy_car/domain/dtos/credentials_esqueci_senha.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsEsqueciSenhaValidator
    extends LucidValidator<CredentialsEsqueciSenha> {
  CredentialsEsqueciSenhaValidator() {
    ruleFor((c) => c.email, key: 'email').notEmpty().validEmail().matchesPattern(
      r'^[\w\.-]+@([\w-]+\.)?ufrrj\.br$',
      message: 'O e-mail deve pertencer ao domínio ufrrj.br',
    );
  }
}
