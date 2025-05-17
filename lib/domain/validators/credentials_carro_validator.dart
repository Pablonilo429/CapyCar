import 'package:capy_car/domain/dtos/credentials_carro.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsCarroValidator extends LucidValidator<CredentialsCarro> {
  CredentialsCarroValidator() {
    ruleFor((c) => c.marca, key: 'marca').notEmpty().maxLength(50).minLength(1);

    ruleFor(
      (c) => c.modelo,
      key: 'modelo',
    ).notEmpty().maxLength(50).minLength(1);

    ruleFor((c) => c.cor, key: 'cor').notEmpty().maxLength(25).minLength(1);

    ruleFor(
      (c) => c.placa,
      key: 'placa',
    ).notEmpty().maxLength(7).minLength(7).mustHaveNumber();
  }
}
