import 'package:freezed_annotation/freezed_annotation.dart';

part 'rota.freezed.dart';
part 'rota.g.dart';

@freezed
sealed class Rota with _$Rota {
  const factory Rota({
    String? id,
    String? nome,
    required String saida,
    required String campus,
    required List<String> pontos,
  }) = _Rota;

  factory Rota.fromJson(Map<String, dynamic> json) => _$RotaFromJson(json);
}