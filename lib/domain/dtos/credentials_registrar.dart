class CredentialsRegistrar {
  String nomeCompleto;
  String? nomeSocial;
  DateTime? dataNascimento;
  String emailInstitucional;
  String? numeroCelular;
  String senha;
  String confirmarSenha;
  bool termosCondicoes;
  bool isPassageiro;
  bool isMotorista;

  CredentialsRegistrar({
    this.nomeCompleto = '',
    this.nomeSocial,
    this.dataNascimento,
    this.emailInstitucional = '',
    this.termosCondicoes = true,
    this.isPassageiro = true,
    this.isMotorista = false,
    this.numeroCelular = '',
    this.senha = '',
    this.confirmarSenha = '',
  });


  void setNomeCompleto(String nomeCompleto) {
    this.nomeCompleto = nomeCompleto;
  }
  void setNomeSocial(String? nomeSocial) {
    this.nomeSocial = nomeSocial;
  }
  void setDataNascimento(DateTime? dataNascimento) {
    this.dataNascimento = dataNascimento;
  }
  void setEmailInstitucional(String emailInstitucional) {
    this.emailInstitucional = emailInstitucional;
  }
  void setTermosCondicoes(bool termosCondicoes) {
    this.termosCondicoes = termosCondicoes;
  }
  void setNumeroCelular(String? numeroCelular) {
    this.numeroCelular = numeroCelular;
  }
  void setSenha(String senha) {
    this.senha = senha;
  }
  void setConfirmarSenha(String confirmarSenha) {
    this.confirmarSenha = confirmarSenha;
  }


}
