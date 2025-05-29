class CredentialsRota {
  String? nomeRota;
  String cidadeSaida;
  String campus;
  List<String> pontos;

  CredentialsRota({
    this.nomeRota = "rota carona",
    this.cidadeSaida = '',
    this.campus = '',
    this.pontos = const [],
  }) {
    pontos = List<String>.from(pontos);
  }

  void setNomeRota(String nomeRota) {
    this.nomeRota = nomeRota;
  }

  void setCidadeSaida(String cidadeSaida) {
    this.cidadeSaida = cidadeSaida;
  }

  void setCampus(String campus) {
    this.campus = campus;
  }

  void setPontos(List<String> pontos) {
    this.pontos = pontos;
  }

  // Método para adicionar um ponto individual à lista
  void addPonto(String ponto) {
    pontos.add(ponto);
  }

  void removePonto(String ponto) {
    pontos.remove(ponto);
  }
}
