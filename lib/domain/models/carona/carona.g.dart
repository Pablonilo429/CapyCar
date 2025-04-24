// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carona.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Carona _$CaronaFromJson(Map<String, dynamic> json) => _Carona(
  id: json['id'] as String?,
  motoristaId: json['motoristaId'] as String,
  rota: Rota.fromJson(json['rota'] as Map<String, dynamic>),
  isVolta: json['isVolta'] as bool,
  idsPassageiros:
      (json['idsPassageiros'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  qtdePassageiros: (json['qtdePassageiros'] as num).toInt(),
  status: json['status'] as String,
  horarioSaidaCarona: DateTime.parse(json['horarioSaidaCarona'] as String),
  horarioChegada: DateTime.parse(json['horarioChegada'] as String),
  dataCarona: DateTime.parse(json['dataCarona'] as String),
  isFinalizada: json['isFinalizada'] as bool,
);

Map<String, dynamic> _$CaronaToJson(_Carona instance) => <String, dynamic>{
  'id': instance.id,
  'motoristaId': instance.motoristaId,
  'rota': instance.rota,
  'isVolta': instance.isVolta,
  'idsPassageiros': instance.idsPassageiros,
  'qtdePassageiros': instance.qtdePassageiros,
  'status': instance.status,
  'horarioSaidaCarona': instance.horarioSaidaCarona.toIso8601String(),
  'horarioChegada': instance.horarioChegada.toIso8601String(),
  'dataCarona': instance.dataCarona.toIso8601String(),
  'isFinalizada': instance.isFinalizada,
};
