import 'package:capy_car/domain/dtos/credentials_rota.dart';


class CredentialsCarona {
  String idMotorista;
  int qtdePassageiros;
  bool? isVolta;
  DateTime? horarioSaida;
  DateTime? horarioChegada;
  double? preco;
  CredentialsRota? rota;

  CredentialsCarona({
    this.idMotorista = '',
    this.qtdePassageiros = 4,
    this.isVolta,
    this.horarioSaida,
    this.horarioChegada,
    this.preco,
    this.rota,
  });
}
