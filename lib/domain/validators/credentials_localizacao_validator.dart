import 'package:capy_car/domain/dtos/credentials_localizacao.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsLocalizacaoValidator
    extends LucidValidator<CredentialsLocalizacao> {
  CredentialsLocalizacaoValidator() {
    ruleFor(
      (c) => c.campus,
      key: 'campus',
    ).notEmpty().maxLength(50).minLength(1);
    ruleFor((c) => c.cidade, key: 'cidade')
        .notEmpty(message: "A cidade é obrigatória")
        .maxLength(100, message: "A cidade deve ter no máximo 100 caracteres")
        .minLength(1, message: "A cidade deve ter pelo menos 1 caractere");
    ruleFor((c) => c.bairro, key: 'bairro')
        .notEmpty(message: "O bairro é obrigatório")
        .maxLength(100, message: "O bairro deve ter no máximo 100 caracteres")
        .minLength(1, message: "O bairro deve ter pelo menos 1 caractere");
  }
}
