class CredentialsEditarUsuario {
  String? nomeSocial;
  String? numeroCelular;
  String? urlFotoPerfil;
  String campus;
  String cidade;
  String bairro;

  CredentialsEditarUsuario({
    this.nomeSocial,
    this.numeroCelular = '',
    this.urlFotoPerfil = '',
    this.bairro = '',
    this.campus = '',
    this.cidade = '',
  });


  void setNomeSocial(String? nomeSocial) {
    this.nomeSocial = nomeSocial;
  }


  void setNumeroCelular(String? numeroCelular) {
    this.numeroCelular = numeroCelular;
  }

  void setUrlFotoPerfil(String? urlFotoPerfil) {
    this.urlFotoPerfil = urlFotoPerfil;
  }

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
