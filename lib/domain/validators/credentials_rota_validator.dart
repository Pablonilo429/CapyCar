import 'package:capy_car/domain/dtos/credentials_rota.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsRotaValidator extends LucidValidator<CredentialsRota> {
  CredentialsRotaValidator() {
    ruleFor(
      (c) => c.campus,
      key: 'campus',
    ).notEmpty().maxLength(100).minLength(1);
    ruleFor(
      (c) => c.cidadeSaida,
      key: 'cidadeSaida',
    ).notEmpty(message: "A cidade de saída/chegada é obrigatória").maxLength(100, message: "A cidade de saída/chegada deve ter no máximo 100 caracteres").minLength(1, message: "A cidade de saída/chegada deve ter pelo menos 1 caractere");
    ruleFor(
      (c) => c.nomeRota,
      key: 'nomeRota',
    ).notEmptyOrNull(message: "O nome da rota é obrigatório").maxLength(100, message: "O nome da rota deve ter no máximo 100 caracteres").minLength(1, message: "A rota deve ter pelo menos 1 caractere");
    ruleFor(
      (c) => c.pontos,
      key: 'pontos_items',
    ) // Key for validating items within the list
    .must(
      (listaDePontos) {
        if (listaDePontos == null) {
          return true;
        }

        for (final pontoStr in listaDePontos) {
          if (pontoStr.length > 30) {
            return false;
          }
        }
        return true;
      },
      'Um ponto não pode ter mais de 50 caracteres',
      'pontos',
    );
  }
}
