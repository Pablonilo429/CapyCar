import 'package:capy_car/domain/dtos/credentials_rota.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsRotaValidator extends LucidValidator<CredentialsRota> {
  CredentialsRotaValidator() {
    ruleFor((c) => c.campus, key: 'campus').notEmpty().maxLength(100).minLength(1);
    ruleFor((c) => c.cidadeSaida, key: 'cidadeSaida').notEmpty().maxLength(100).minLength(1);
    ruleFor((c) => c.nomeRota, key: 'nomeRota').notEmpty().maxLength(100).minLength(1);
    ruleFor((c) => c.pontos, key: 'pontos')
        .must((pontos) => pontos.length <= 10,'Uma carona não pode ter mais de 10 pontos.', 'carona_pontos_max');

  }

}