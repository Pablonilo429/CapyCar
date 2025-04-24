import 'package:freezed_annotation/freezed_annotation.dart';

import '../rota/rota.dart';

part 'carona.freezed.dart';
part 'carona.g.dart';

@freezed
sealed class Carona with _$Carona{
  const factory Carona({
    String? id,
    required String motoristaId,
    required Rota rota,
    required bool isVolta,
    List<String>? idsPassageiros,
    required int qtdePassageiros,
    required String status,
    required DateTime horarioSaidaCarona,
    required DateTime horarioChegada,
    required DateTime dataCarona,
    required bool isFinalizada,
  }) = _Carona;

  factory Carona.fromJson(Map<String, dynamic> json) => _$CaronaFromJson(json);
}