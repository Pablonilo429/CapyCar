// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'carro.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Carro {

 String get marca; String get modelo; String get cor; String get placa;
/// Create a copy of Carro
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarroCopyWith<Carro> get copyWith => _$CarroCopyWithImpl<Carro>(this as Carro, _$identity);

  /// Serializes this Carro to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Carro&&(identical(other.marca, marca) || other.marca == marca)&&(identical(other.modelo, modelo) || other.modelo == modelo)&&(identical(other.cor, cor) || other.cor == cor)&&(identical(other.placa, placa) || other.placa == placa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,marca,modelo,cor,placa);

@override
String toString() {
  return 'Carro(marca: $marca, modelo: $modelo, cor: $cor, placa: $placa)';
}


}

/// @nodoc
abstract mixin class $CarroCopyWith<$Res>  {
  factory $CarroCopyWith(Carro value, $Res Function(Carro) _then) = _$CarroCopyWithImpl;
@useResult
$Res call({
 String marca, String modelo, String cor, String placa
});




}
/// @nodoc
class _$CarroCopyWithImpl<$Res>
    implements $CarroCopyWith<$Res> {
  _$CarroCopyWithImpl(this._self, this._then);

  final Carro _self;
  final $Res Function(Carro) _then;

/// Create a copy of Carro
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? marca = null,Object? modelo = null,Object? cor = null,Object? placa = null,}) {
  return _then(_self.copyWith(
marca: null == marca ? _self.marca : marca // ignore: cast_nullable_to_non_nullable
as String,modelo: null == modelo ? _self.modelo : modelo // ignore: cast_nullable_to_non_nullable
as String,cor: null == cor ? _self.cor : cor // ignore: cast_nullable_to_non_nullable
as String,placa: null == placa ? _self.placa : placa // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Carro implements Carro {
  const _Carro({required this.marca, required this.modelo, required this.cor, required this.placa});
  factory _Carro.fromJson(Map<String, dynamic> json) => _$CarroFromJson(json);

@override final  String marca;
@override final  String modelo;
@override final  String cor;
@override final  String placa;

/// Create a copy of Carro
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CarroCopyWith<_Carro> get copyWith => __$CarroCopyWithImpl<_Carro>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CarroToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Carro&&(identical(other.marca, marca) || other.marca == marca)&&(identical(other.modelo, modelo) || other.modelo == modelo)&&(identical(other.cor, cor) || other.cor == cor)&&(identical(other.placa, placa) || other.placa == placa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,marca,modelo,cor,placa);

@override
String toString() {
  return 'Carro(marca: $marca, modelo: $modelo, cor: $cor, placa: $placa)';
}


}

/// @nodoc
abstract mixin class _$CarroCopyWith<$Res> implements $CarroCopyWith<$Res> {
  factory _$CarroCopyWith(_Carro value, $Res Function(_Carro) _then) = __$CarroCopyWithImpl;
@override @useResult
$Res call({
 String marca, String modelo, String cor, String placa
});




}
/// @nodoc
class __$CarroCopyWithImpl<$Res>
    implements _$CarroCopyWith<$Res> {
  __$CarroCopyWithImpl(this._self, this._then);

  final _Carro _self;
  final $Res Function(_Carro) _then;

/// Create a copy of Carro
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? marca = null,Object? modelo = null,Object? cor = null,Object? placa = null,}) {
  return _then(_Carro(
marca: null == marca ? _self.marca : marca // ignore: cast_nullable_to_non_nullable
as String,modelo: null == modelo ? _self.modelo : modelo // ignore: cast_nullable_to_non_nullable
as String,cor: null == cor ? _self.cor : cor // ignore: cast_nullable_to_non_nullable
as String,placa: null == placa ? _self.placa : placa // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
