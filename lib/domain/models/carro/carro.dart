import 'package:freezed_annotation/freezed_annotation.dart';

part 'carro.freezed.dart';
part 'carro.g.dart';

@freezed
sealed class Carro with _$Carro {
  const factory Carro({
    required String marca,
    required String modelo,
    required String cor,
    required String placa,
  }) = _Carro;

  factory Carro.fromJson(Map<String, dynamic> json) => _$CarroFromJson(json);
}