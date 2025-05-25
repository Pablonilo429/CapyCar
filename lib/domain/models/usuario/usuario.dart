import 'package:capy_car/domain/models/rota/rota.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../carro/carro.dart';

part 'usuario.freezed.dart';

part 'usuario.g.dart';

@freezed
sealed class Usuario with _$Usuario {
  // const Usuario._(); // Construtor privado para suportar funcionalidades adicionais
  const factory Usuario({
    required String uId,
    required String nome,
    required String fotoPerfilUrl,
    String? nomeSocial,
    required String emailInstitucional,
    DateTime? dataNascimento,
    String? numeroCelular,
    String? campus,
    String? cidade,
    String? bairro,
    required bool isMotorista,
    required bool isAtivo,
    required bool isPrimeiroLogin,
    Carro? carro,
    List<Rota>? rotasCadastradas,
  }) = UsuarioDados;



  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
}
