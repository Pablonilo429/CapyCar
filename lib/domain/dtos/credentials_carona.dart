import 'package:capy_car/domain/dtos/credentials_rota.dart';


class CredentialsCarona {
  String idMotorista;
  int qtdePassageiros;
  bool? isVolta;
  DateTime? horarioSaida;
  DateTime? horarioChegada;
  double preco;
  CredentialsRota? rota;

  CredentialsCarona({
    this.idMotorista = '',
    this.qtdePassageiros = 4,
    this.isVolta,
    this.horarioSaida,
    this.horarioChegada,
    this.preco = 1.0,
    this.rota,
  });

  // Métodos set
  void setIdMotorista(String idMotorista) {
    this.idMotorista = idMotorista;
  }

  void setQtdePassageiros(int qtdePassageiros) {
    this.qtdePassageiros = qtdePassageiros;
  }

  void setIsVolta(bool isVolta) {
    this.isVolta = isVolta;
  }

  void setHorarioSaida(DateTime horarioSaida) {
    this.horarioSaida = horarioSaida;
  }

  void setHorarioChegada(DateTime horarioChegada) {
    this.horarioChegada = horarioChegada;
  }

  void setPreco(double preco) {
    this.preco = preco;
  }

}
