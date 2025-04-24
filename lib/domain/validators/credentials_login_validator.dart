import 'package:capy_car/domain/dtos/credentials_login.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsLoginValidator extends LucidValidator<CredentialsLogin> {
  CredentialsLoginValidator() {
    ruleFor((c) => c.email, key: 'email')
        .notEmpty()
        .validEmail();

    ruleFor((c) => c.password, key: 'password')
        .notEmpty();
  }
}
