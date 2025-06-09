import 'package:capy_car/domain/dtos/credentials_carro.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsCarroValidator extends LucidValidator<CredentialsCarro> {
  CredentialsCarroValidator() {
    ruleFor((c) => c.marca, key: 'marca').notEmpty(message: "A marca é obrigatória").maxLength(50, message: "A marca deve ter no máximo 50 caracteres").minLength(1, message: "A marca deve ter pelo menos 1 caractere");

    ruleFor(
      (c) => c.modelo,
      key: 'modelo',
    ).notEmpty(message: "O modelo é obrigatório").maxLength(50, message: "O modelo deve ter no máximo 50 caracteres").minLength(1, message: "O modelo deve ter pelo menos 1 caractere");

    ruleFor((c) => c.cor, key: 'cor').notEmpty(message: "A cor é obrigatória").maxLength(25, message: "A cor deve ter no máximo 25 caracteres").minLength(1, message: "A cor deve ter pelo menos 1 caractere");

    ruleFor(
      (c) => c.placa,
      key: 'placa',
    ).notEmpty(message: "A placa é obrigatória").maxLength(7, message: "A placa deve ter no máximo 7 caracteres").minLength(7, message: "A placa deve ter 7 caracteres").mustHaveNumber(message: "A placa preicsar conter números");
  }
}
