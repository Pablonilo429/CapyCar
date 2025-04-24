import 'package:capy_car/domain/dtos/credentials_localizacao.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsLocalizacaoValidator extends LucidValidator<CredentialsLocalizacao> {
  CredentialsLocalizacaoValidator(){
    ruleFor((c) => c.campus, key: 'campus').notEmpty().maxLength(50).minLength(1);
    ruleFor((c) => c.cidade, key: 'cidade').notEmpty().maxLength(100).minLength(1);
    ruleFor((c) => c.bairro, key: 'bairro').notEmpty().maxLength(100).minLength(1);
  }


}