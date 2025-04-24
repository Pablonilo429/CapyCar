// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rota.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Rota _$RotaFromJson(Map<String, dynamic> json) => _Rota(
  id: json['id'] as String?,
  nome: json['nome'] as String?,
  saida: json['saida'] as String,
  campus: json['campus'] as String,
  pontos: (json['pontos'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$RotaToJson(_Rota instance) => <String, dynamic>{
  'id': instance.id,
  'nome': instance.nome,
  'saida': instance.saida,
  'campus': instance.campus,
  'pontos': instance.pontos,
};
