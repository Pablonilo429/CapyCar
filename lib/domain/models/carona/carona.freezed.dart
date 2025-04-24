// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'carona.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Carona {

 String? get id; String get motoristaId; Rota get rota; bool get isVolta; List<String>? get idsPassageiros; int get qtdePassageiros; String get status; DateTime get horarioSaidaCarona; DateTime get horarioChegada; DateTime get dataCarona; bool get isFinalizada;
/// Create a copy of Carona
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaronaCopyWith<Carona> get copyWith => _$CaronaCopyWithImpl<Carona>(this as Carona, _$identity);

  /// Serializes this Carona to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Carona&&(identical(other.id, id) || other.id == id)&&(identical(other.motoristaId, motoristaId) || other.motoristaId == motoristaId)&&(identical(other.rota, rota) || other.rota == rota)&&(identical(other.isVolta, isVolta) || other.isVolta == isVolta)&&const DeepCollectionEquality().equals(other.idsPassageiros, idsPassageiros)&&(identical(other.qtdePassageiros, qtdePassageiros) || other.qtdePassageiros == qtdePassageiros)&&(identical(other.status, status) || other.status == status)&&(identical(other.horarioSaidaCarona, horarioSaidaCarona) || other.horarioSaidaCarona == horarioSaidaCarona)&&(identical(other.horarioChegada, horarioChegada) || other.horarioChegada == horarioChegada)&&(identical(other.dataCarona, dataCarona) || other.dataCarona == dataCarona)&&(identical(other.isFinalizada, isFinalizada) || other.isFinalizada == isFinalizada));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,motoristaId,rota,isVolta,const DeepCollectionEquality().hash(idsPassageiros),qtdePassageiros,status,horarioSaidaCarona,horarioChegada,dataCarona,isFinalizada);

@override
String toString() {
  return 'Carona(id: $id, motoristaId: $motoristaId, rota: $rota, isVolta: $isVolta, idsPassageiros: $idsPassageiros, qtdePassageiros: $qtdePassageiros, status: $status, horarioSaidaCarona: $horarioSaidaCarona, horarioChegada: $horarioChegada, dataCarona: $dataCarona, isFinalizada: $isFinalizada)';
}


}

/// @nodoc
abstract mixin class $CaronaCopyWith<$Res>  {
  factory $CaronaCopyWith(Carona value, $Res Function(Carona) _then) = _$CaronaCopyWithImpl;
@useResult
$Res call({
 String? id, String motoristaId, Rota rota, bool isVolta, List<String>? idsPassageiros, int qtdePassageiros, String status, DateTime horarioSaidaCarona, DateTime horarioChegada, DateTime dataCarona, bool isFinalizada
});


$RotaCopyWith<$Res> get rota;

}
/// @nodoc
class _$CaronaCopyWithImpl<$Res>
    implements $CaronaCopyWith<$Res> {
  _$CaronaCopyWithImpl(this._self, this._then);

  final Carona _self;
  final $Res Function(Carona) _then;

/// Create a copy of Carona
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? motoristaId = null,Object? rota = null,Object? isVolta = null,Object? idsPassageiros = freezed,Object? qtdePassageiros = null,Object? status = null,Object? horarioSaidaCarona = null,Object? horarioChegada = null,Object? dataCarona = null,Object? isFinalizada = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,motoristaId: null == motoristaId ? _self.motoristaId : motoristaId // ignore: cast_nullable_to_non_nullable
as String,rota: null == rota ? _self.rota : rota // ignore: cast_nullable_to_non_nullable
as Rota,isVolta: null == isVolta ? _self.isVolta : isVolta // ignore: cast_nullable_to_non_nullable
as bool,idsPassageiros: freezed == idsPassageiros ? _self.idsPassageiros : idsPassageiros // ignore: cast_nullable_to_non_nullable
as List<String>?,qtdePassageiros: null == qtdePassageiros ? _self.qtdePassageiros : qtdePassageiros // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,horarioSaidaCarona: null == horarioSaidaCarona ? _self.horarioSaidaCarona : horarioSaidaCarona // ignore: cast_nullable_to_non_nullable
as DateTime,horarioChegada: null == horarioChegada ? _self.horarioChegada : horarioChegada // ignore: cast_nullable_to_non_nullable
as DateTime,dataCarona: null == dataCarona ? _self.dataCarona : dataCarona // ignore: cast_nullable_to_non_nullable
as DateTime,isFinalizada: null == isFinalizada ? _self.isFinalizada : isFinalizada // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Carona
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RotaCopyWith<$Res> get rota {
  
  return $RotaCopyWith<$Res>(_self.rota, (value) {
    return _then(_self.copyWith(rota: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Carona implements Carona {
  const _Carona({this.id, required this.motoristaId, required this.rota, required this.isVolta, final  List<String>? idsPassageiros, required this.qtdePassageiros, required this.status, required this.horarioSaidaCarona, required this.horarioChegada, required this.dataCarona, required this.isFinalizada}): _idsPassageiros = idsPassageiros;
  factory _Carona.fromJson(Map<String, dynamic> json) => _$CaronaFromJson(json);

@override final  String? id;
@override final  String motoristaId;
@override final  Rota rota;
@override final  bool isVolta;
 final  List<String>? _idsPassageiros;
@override List<String>? get idsPassageiros {
  final value = _idsPassageiros;
  if (value == null) return null;
  if (_idsPassageiros is EqualUnmodifiableListView) return _idsPassageiros;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int qtdePassageiros;
@override final  String status;
@override final  DateTime horarioSaidaCarona;
@override final  DateTime horarioChegada;
@override final  DateTime dataCarona;
@override final  bool isFinalizada;

/// Create a copy of Carona
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaronaCopyWith<_Carona> get copyWith => __$CaronaCopyWithImpl<_Carona>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CaronaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Carona&&(identical(other.id, id) || other.id == id)&&(identical(other.motoristaId, motoristaId) || other.motoristaId == motoristaId)&&(identical(other.rota, rota) || other.rota == rota)&&(identical(other.isVolta, isVolta) || other.isVolta == isVolta)&&const DeepCollectionEquality().equals(other._idsPassageiros, _idsPassageiros)&&(identical(other.qtdePassageiros, qtdePassageiros) || other.qtdePassageiros == qtdePassageiros)&&(identical(other.status, status) || other.status == status)&&(identical(other.horarioSaidaCarona, horarioSaidaCarona) || other.horarioSaidaCarona == horarioSaidaCarona)&&(identical(other.horarioChegada, horarioChegada) || other.horarioChegada == horarioChegada)&&(identical(other.dataCarona, dataCarona) || other.dataCarona == dataCarona)&&(identical(other.isFinalizada, isFinalizada) || other.isFinalizada == isFinalizada));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,motoristaId,rota,isVolta,const DeepCollectionEquality().hash(_idsPassageiros),qtdePassageiros,status,horarioSaidaCarona,horarioChegada,dataCarona,isFinalizada);

@override
String toString() {
  return 'Carona(id: $id, motoristaId: $motoristaId, rota: $rota, isVolta: $isVolta, idsPassageiros: $idsPassageiros, qtdePassageiros: $qtdePassageiros, status: $status, horarioSaidaCarona: $horarioSaidaCarona, horarioChegada: $horarioChegada, dataCarona: $dataCarona, isFinalizada: $isFinalizada)';
}


}

/// @nodoc
abstract mixin class _$CaronaCopyWith<$Res> implements $CaronaCopyWith<$Res> {
  factory _$CaronaCopyWith(_Carona value, $Res Function(_Carona) _then) = __$CaronaCopyWithImpl;
@override @useResult
$Res call({
 String? id, String motoristaId, Rota rota, bool isVolta, List<String>? idsPassageiros, int qtdePassageiros, String status, DateTime horarioSaidaCarona, DateTime horarioChegada, DateTime dataCarona, bool isFinalizada
});


@override $RotaCopyWith<$Res> get rota;

}
/// @nodoc
class __$CaronaCopyWithImpl<$Res>
    implements _$CaronaCopyWith<$Res> {
  __$CaronaCopyWithImpl(this._self, this._then);

  final _Carona _self;
  final $Res Function(_Carona) _then;

/// Create a copy of Carona
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? motoristaId = null,Object? rota = null,Object? isVolta = null,Object? idsPassageiros = freezed,Object? qtdePassageiros = null,Object? status = null,Object? horarioSaidaCarona = null,Object? horarioChegada = null,Object? dataCarona = null,Object? isFinalizada = null,}) {
  return _then(_Carona(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,motoristaId: null == motoristaId ? _self.motoristaId : motoristaId // ignore: cast_nullable_to_non_nullable
as String,rota: null == rota ? _self.rota : rota // ignore: cast_nullable_to_non_nullable
as Rota,isVolta: null == isVolta ? _self.isVolta : isVolta // ignore: cast_nullable_to_non_nullable
as bool,idsPassageiros: freezed == idsPassageiros ? _self._idsPassageiros : idsPassageiros // ignore: cast_nullable_to_non_nullable
as List<String>?,qtdePassageiros: null == qtdePassageiros ? _self.qtdePassageiros : qtdePassageiros // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,horarioSaidaCarona: null == horarioSaidaCarona ? _self.horarioSaidaCarona : horarioSaidaCarona // ignore: cast_nullable_to_non_nullable
as DateTime,horarioChegada: null == horarioChegada ? _self.horarioChegada : horarioChegada // ignore: cast_nullable_to_non_nullable
as DateTime,dataCarona: null == dataCarona ? _self.dataCarona : dataCarona // ignore: cast_nullable_to_non_nullable
as DateTime,isFinalizada: null == isFinalizada ? _self.isFinalizada : isFinalizada // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Carona
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RotaCopyWith<$Res> get rota {
  
  return $RotaCopyWith<$Res>(_self.rota, (value) {
    return _then(_self.copyWith(rota: value));
  });
}
}

// dart format on
