class CredentialsLocalizacao {
  String campus;
  String cidade;
  String bairro;

  CredentialsLocalizacao({
    this.campus = '',
    this.cidade = '',
    this.bairro = '',
  });

  void setCampus(String campus) {
    this.campus = campus;
  }

  void setCidade(String cidade) {
    this.cidade = cidade;
  }

  void setBairro(String bairro) {
    this.bairro = bairro;
  }
}