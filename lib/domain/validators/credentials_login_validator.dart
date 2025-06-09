import 'package:capy_car/domain/dtos/credentials_login.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsLoginValidator extends LucidValidator<CredentialsLogin> {
  CredentialsLoginValidator() {
    ruleFor((c) => c.email, key: 'email')
        .notEmpty(message: "O e-mail é obrigatório")
        .validEmail(message: "Insira um e-mail válido");

    ruleFor(
      (c) => c.password,
      key: 'password',
    ).notEmpty(message: "A senha é obrigatória");
  }
}
