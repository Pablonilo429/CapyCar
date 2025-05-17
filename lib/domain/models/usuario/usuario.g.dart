// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioDados _$UsuarioDadosFromJson(Map<String, dynamic> json) => UsuarioDados(
  uId: json['uId'] as String,
  nome: json['nome'] as String,
  fotoPerfilUrl: json['fotoPerfilUrl'] as String?,
  nomeSocial: json['nomeSocial'] as String?,
  emailInstitucional: json['emailInstitucional'] as String,
  dataNascimento:
      json['dataNascimento'] == null
          ? null
          : DateTime.parse(json['dataNascimento'] as String),
  numeroCelular: json['numeroCelular'] as String?,
  campus: json['campus'] as String?,
  cidade: json['cidade'] as String?,
  bairro: json['bairro'] as String?,
  isMotorista: json['isMotorista'] as bool,
  isAtivo: json['isAtivo'] as bool,
  isPrimeiroLogin: json['isPrimeiroLogin'] as bool,
  carro:
      json['carro'] == null
          ? null
          : Carro.fromJson(json['carro'] as Map<String, dynamic>),
  rotasCadastradas:
      (json['rotasCadastradas'] as List<dynamic>?)
          ?.map((e) => Rota.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$UsuarioDadosToJson(UsuarioDados instance) =>
    <String, dynamic>{
      'uId': instance.uId,
      'nome': instance.nome,
      'fotoPerfilUrl': instance.fotoPerfilUrl,
      'nomeSocial': instance.nomeSocial,
      'emailInstitucional': instance.emailInstitucional,
      'dataNascimento': instance.dataNascimento?.toIso8601String(),
      'numeroCelular': instance.numeroCelular,
      'campus': instance.campus,
      'cidade': instance.cidade,
      'bairro': instance.bairro,
      'isMotorista': instance.isMotorista,
      'isAtivo': instance.isAtivo,
      'isPrimeiroLogin': instance.isPrimeiroLogin,
      'carro': instance.carro,
      'rotasCadastradas': instance.rotasCadastradas,
    };
