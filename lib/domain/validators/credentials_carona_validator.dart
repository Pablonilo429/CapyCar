import 'package:capy_car/domain/dtos/credentials_carona.dart';
import 'package:lucid_validation/lucid_validation.dart';

class CredentialsCaronaValidator extends LucidValidator<CredentialsCarona> {
  CredentialsCaronaValidator() {
    ruleFor((c) => c.isVolta, key: 'isVolta').isNotNull();

    ruleFor((c) => c.horarioSaida, key: 'horarioSaida').isNotNull();

    ruleFor((c) => c.horarioChegada, key: 'horarioChegada').isNotNull();

    ruleFor((c) => c.idMotorista, key: 'idMotorista').isNotNull();

    ruleFor((c) => c.preco, key: 'preco')
        .greaterThan(0, message: 'O preço deve ser maior que zero');

    ruleFor((c) => c.qtdePassageiros, key: 'qtdePassageiros')
    .max(4, message: 'A quantidade de passegeiros deve ser até 4')
    .min(1, message: 'A quantidade de passageiros deve não pode ser menor que 1');


    ruleFor((c) => c.horarioSaida, key: 'horarioSaida')
        .must((d) => d!.isAfter(DateTime.now()),
        "O horário de saída não pode estar no passado", "horarioPassado"
    );


    // Validação condicional da diferença de horários
    ruleFor((c) => c, key: 'horarios')
        .when((carona) =>
    carona.horarioSaida != null && carona.horarioChegada != null)
        .must((carona) =>
    carona.horarioChegada!.difference(carona.horarioSaida!) >=
    Duration(minutes: 30),
    'O horário de saída deve ser pelo menos 30 minutos antes da chegada', 'diferencaHorarios');
  }
}