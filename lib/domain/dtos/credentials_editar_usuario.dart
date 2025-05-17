class CredentialsEditarUsuario {
  String nomeCompleto;
  String? nomeSocial;
  DateTime? dataNascimento;
  String? numeroCelular;
  String? urlFotoPerfil;
  String campus;
  String cidade;
  String bairro;

  CredentialsEditarUsuario({
    this.nomeCompleto = '',
    this.nomeSocial,
    this.dataNascimento,
    this.numeroCelular = '',
    this.urlFotoPerfil,
    this.bairro = '',
    this.campus = '',
    this.cidade = '',
  });

  // Métodos set individuais
  void setNomeCompleto(String nomeCompleto) {
    this.nomeCompleto = nomeCompleto;
  }

  void setNomeSocial(String? nomeSocial) {
    this.nomeSocial = nomeSocial;
  }

  void setDataNascimento(DateTime? dataNascimento) {
    this.dataNascimento = dataNascimento;
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
