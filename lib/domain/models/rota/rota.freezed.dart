// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rota.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Rota {

 String? get id; String? get nome; String get saida; String get campus; List<String> get pontos;
/// Create a copy of Rota
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RotaCopyWith<Rota> get copyWith => _$RotaCopyWithImpl<Rota>(this as Rota, _$identity);

  /// Serializes this Rota to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Rota&&(identical(other.id, id) || other.id == id)&&(identical(other.nome, nome) || other.nome == nome)&&(identical(other.saida, saida) || other.saida == saida)&&(identical(other.campus, campus) || other.campus == campus)&&const DeepCollectionEquality().equals(other.pontos, pontos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nome,saida,campus,const DeepCollectionEquality().hash(pontos));

@override
String toString() {
  return 'Rota(id: $id, nome: $nome, saida: $saida, campus: $campus, pontos: $pontos)';
}


}

/// @nodoc
abstract mixin class $RotaCopyWith<$Res>  {
  factory $RotaCopyWith(Rota value, $Res Function(Rota) _then) = _$RotaCopyWithImpl;
@useResult
$Res call({
 String? id, String? nome, String saida, String campus, List<String> pontos
});




}
/// @nodoc
class _$RotaCopyWithImpl<$Res>
    implements $RotaCopyWith<$Res> {
  _$RotaCopyWithImpl(this._self, this._then);

  final Rota _self;
  final $Res Function(Rota) _then;

/// Create a copy of Rota
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? nome = freezed,Object? saida = null,Object? campus = null,Object? pontos = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,nome: freezed == nome ? _self.nome : nome // ignore: cast_nullable_to_non_nullable
as String?,saida: null == saida ? _self.saida : saida // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,pontos: null == pontos ? _self.pontos : pontos // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Rota implements Rota {
  const _Rota({this.id, this.nome, required this.saida, required this.campus, required final  List<String> pontos}): _pontos = pontos;
  factory _Rota.fromJson(Map<String, dynamic> json) => _$RotaFromJson(json);

@override final  String? id;
@override final  String? nome;
@override final  String saida;
@override final  String campus;
 final  List<String> _pontos;
@override List<String> get pontos {
  if (_pontos is EqualUnmodifiableListView) return _pontos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pontos);
}


/// Create a copy of Rota
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RotaCopyWith<_Rota> get copyWith => __$RotaCopyWithImpl<_Rota>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RotaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Rota&&(identical(other.id, id) || other.id == id)&&(identical(other.nome, nome) || other.nome == nome)&&(identical(other.saida, saida) || other.saida == saida)&&(identical(other.campus, campus) || other.campus == campus)&&const DeepCollectionEquality().equals(other._pontos, _pontos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nome,saida,campus,const DeepCollectionEquality().hash(_pontos));

@override
String toString() {
  return 'Rota(id: $id, nome: $nome, saida: $saida, campus: $campus, pontos: $pontos)';
}


}

/// @nodoc
abstract mixin class _$RotaCopyWith<$Res> implements $RotaCopyWith<$Res> {
  factory _$RotaCopyWith(_Rota value, $Res Function(_Rota) _then) = __$RotaCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? nome, String saida, String campus, List<String> pontos
});




}
/// @nodoc
class __$RotaCopyWithImpl<$Res>
    implements _$RotaCopyWith<$Res> {
  __$RotaCopyWithImpl(this._self, this._then);

  final _Rota _self;
  final $Res Function(_Rota) _then;

/// Create a copy of Rota
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? nome = freezed,Object? saida = null,Object? campus = null,Object? pontos = null,}) {
  return _then(_Rota(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,nome: freezed == nome ? _self.nome : nome // ignore: cast_nullable_to_non_nullable
as String?,saida: null == saida ? _self.saida : saida // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,pontos: null == pontos ? _self._pontos : pontos // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
