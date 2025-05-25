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
    ).notEmpty().maxLength(100).minLength(1);
    ruleFor(
      (c) => c.nomeRota,
      key: 'nomeRota',
    ).notEmptyOrNull().maxLength(100).minLength(1);
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
