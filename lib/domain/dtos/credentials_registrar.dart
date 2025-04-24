class CredentialsRegistrar{
  String nomeCompleto;
  String? nomeSocial;
  DateTime? dataNascimento;
  String emailInstitucional;
  String? numeroCelular;
  String senha;
  String confirmarSenha;
  bool isPassageiro;
  bool isMotorista;

  CredentialsRegistrar({
    this.nomeCompleto = '',
    this.nomeSocial,
    this.dataNascimento,
    this.emailInstitucional = '',
    this.isPassageiro = true,
    this.isMotorista = false,
    this.numeroCelular = '',
    this.senha = '',
    this.confirmarSenha = '',

  });


}