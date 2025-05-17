class CredentialsAlterarSenha {
  String senhaAtual;
  String novaSenha;
  String confirmarNovaSenha;

  CredentialsAlterarSenha({
    this.senhaAtual = '',
    this.novaSenha = '',
    this.confirmarNovaSenha = '',
  });

  void setSenhaAtual(String senhaAtual) {
    this.senhaAtual = senhaAtual;
  }

  void setNovaSenha(String novaSenha) {
    this.novaSenha = novaSenha;
  }

  void setConfirmarNovaSenha(String confirmarNovaSenha) {
    this.confirmarNovaSenha = confirmarNovaSenha;
  }
}
