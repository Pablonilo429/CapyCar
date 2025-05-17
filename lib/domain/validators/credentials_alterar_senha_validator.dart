import 'package:capy_car/domain/dtos/credentials_alterar_senha.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsAlterarSenhaValidator
    extends LucidValidator<CredentialsAlterarSenha> {
  CredentialsAlterarSenhaValidator() {
    ruleFor((c) => c.novaSenha, key: 'senha')
        .mustHaveSpecialCharacter()
        .mustHaveNumber()
        .mustHaveUppercase()
        .mustHaveLowercase()
        .maxLength(32)
        .minLength(6);

    ruleFor(
      (c) => c.confirmarNovaSenha,
      key: 'confirmarSenha',
    ).equalTo((c) => c.novaSenha);
  }
}
