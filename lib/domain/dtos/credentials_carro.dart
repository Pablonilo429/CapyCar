class CredentialsCarro {
  String marca;
  String modelo;
  String cor;
  String placa;

  CredentialsCarro({
    this.marca = '',
    this.modelo = '',
    this.cor = '',
    this.placa = '',
  });

  // Métodos set
  void setMarca(String marca) {
    this.marca = marca;
  }

  void setModelo(String modelo) {
    this.modelo = modelo;
  }

  void setCor(String cor) {
    this.cor = cor;
  }

  void setPlaca(String placa) {
    this.placa = placa;
  }
}