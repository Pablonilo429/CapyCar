// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usuario.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
Usuario _$UsuarioFromJson(
  Map<String, dynamic> json
) {
    return UsuarioDados.fromJson(
      json
    );
}

/// @nodoc
mixin _$Usuario {

 String get uId; String get nome; String? get fotoPerfilUrl; String? get nomeSocial; String get emailInstitucional; DateTime? get dataNascimento; String? get numeroCelular; String? get campus; String? get cidade; String? get bairro; bool get isMotorista; bool get isAtivo; Carro? get carro; List<Rota>? get rotasCadastradas;
/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsuarioCopyWith<Usuario> get copyWith => _$UsuarioCopyWithImpl<Usuario>(this as Usuario, _$identity);

  /// Serializes this Usuario to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Usuario&&(identical(other.uId, uId) || other.uId == uId)&&(identical(other.nome, nome) || other.nome == nome)&&(identical(other.fotoPerfilUrl, fotoPerfilUrl) || other.fotoPerfilUrl == fotoPerfilUrl)&&(identical(other.nomeSocial, nomeSocial) || other.nomeSocial == nomeSocial)&&(identical(other.emailInstitucional, emailInstitucional) || other.emailInstitucional == emailInstitucional)&&(identical(other.dataNascimento, dataNascimento) || other.dataNascimento == dataNascimento)&&(identical(other.numeroCelular, numeroCelular) || other.numeroCelular == numeroCelular)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.cidade, cidade) || other.cidade == cidade)&&(identical(other.bairro, bairro) || other.bairro == bairro)&&(identical(other.isMotorista, isMotorista) || other.isMotorista == isMotorista)&&(identical(other.isAtivo, isAtivo) || other.isAtivo == isAtivo)&&(identical(other.carro, carro) || other.carro == carro)&&const DeepCollectionEquality().equals(other.rotasCadastradas, rotasCadastradas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uId,nome,fotoPerfilUrl,nomeSocial,emailInstitucional,dataNascimento,numeroCelular,campus,cidade,bairro,isMotorista,isAtivo,carro,const DeepCollectionEquality().hash(rotasCadastradas));

@override
String toString() {
  return 'Usuario(uId: $uId, nome: $nome, fotoPerfilUrl: $fotoPerfilUrl, nomeSocial: $nomeSocial, emailInstitucional: $emailInstitucional, dataNascimento: $dataNascimento, numeroCelular: $numeroCelular, campus: $campus, cidade: $cidade, bairro: $bairro, isMotorista: $isMotorista, isAtivo: $isAtivo, carro: $carro, rotasCadastradas: $rotasCadastradas)';
}


}

/// @nodoc
abstract mixin class $UsuarioCopyWith<$Res>  {
  factory $UsuarioCopyWith(Usuario value, $Res Function(Usuario) _then) = _$UsuarioCopyWithImpl;
@useResult
$Res call({
 String uId, String nome, String? fotoPerfilUrl, String? nomeSocial, String emailInstitucional, DateTime? dataNascimento, String? numeroCelular, String? campus, String? cidade, String? bairro, bool isMotorista, bool isAtivo, Carro? carro, List<Rota>? rotasCadastradas
});


$CarroCopyWith<$Res>? get carro;

}
/// @nodoc
class _$UsuarioCopyWithImpl<$Res>
    implements $UsuarioCopyWith<$Res> {
  _$UsuarioCopyWithImpl(this._self, this._then);

  final Usuario _self;
  final $Res Function(Usuario) _then;

/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uId = null,Object? nome = null,Object? fotoPerfilUrl = freezed,Object? nomeSocial = freezed,Object? emailInstitucional = null,Object? dataNascimento = freezed,Object? numeroCelular = freezed,Object? campus = freezed,Object? cidade = freezed,Object? bairro = freezed,Object? isMotorista = null,Object? isAtivo = null,Object? carro = freezed,Object? rotasCadastradas = freezed,}) {
  return _then(_self.copyWith(
uId: null == uId ? _self.uId : uId // ignore: cast_nullable_to_non_nullable
as String,nome: null == nome ? _self.nome : nome // ignore: cast_nullable_to_non_nullable
as String,fotoPerfilUrl: freezed == fotoPerfilUrl ? _self.fotoPerfilUrl : fotoPerfilUrl // ignore: cast_nullable_to_non_nullable
as String?,nomeSocial: freezed == nomeSocial ? _self.nomeSocial : nomeSocial // ignore: cast_nullable_to_non_nullable
as String?,emailInstitucional: null == emailInstitucional ? _self.emailInstitucional : emailInstitucional // ignore: cast_nullable_to_non_nullable
as String,dataNascimento: freezed == dataNascimento ? _self.dataNascimento : dataNascimento // ignore: cast_nullable_to_non_nullable
as DateTime?,numeroCelular: freezed == numeroCelular ? _self.numeroCelular : numeroCelular // ignore: cast_nullable_to_non_nullable
as String?,campus: freezed == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String?,cidade: freezed == cidade ? _self.cidade : cidade // ignore: cast_nullable_to_non_nullable
as String?,bairro: freezed == bairro ? _self.bairro : bairro // ignore: cast_nullable_to_non_nullable
as String?,isMotorista: null == isMotorista ? _self.isMotorista : isMotorista // ignore: cast_nullable_to_non_nullable
as bool,isAtivo: null == isAtivo ? _self.isAtivo : isAtivo // ignore: cast_nullable_to_non_nullable
as bool,carro: freezed == carro ? _self.carro : carro // ignore: cast_nullable_to_non_nullable
as Carro?,rotasCadastradas: freezed == rotasCadastradas ? _self.rotasCadastradas : rotasCadastradas // ignore: cast_nullable_to_non_nullable
as List<Rota>?,
  ));
}
/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CarroCopyWith<$Res>? get carro {
    if (_self.carro == null) {
    return null;
  }

  return $CarroCopyWith<$Res>(_self.carro!, (value) {
    return _then(_self.copyWith(carro: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class UsuarioDados implements Usuario {
  const UsuarioDados({required this.uId, required this.nome, this.fotoPerfilUrl, this.nomeSocial, required this.emailInstitucional, this.dataNascimento, this.numeroCelular, this.campus, this.cidade, this.bairro, required this.isMotorista, required this.isAtivo, this.carro, final  List<Rota>? rotasCadastradas}): _rotasCadastradas = rotasCadastradas;
  factory UsuarioDados.fromJson(Map<String, dynamic> json) => _$UsuarioDadosFromJson(json);

@override final  String uId;
@override final  String nome;
@override final  String? fotoPerfilUrl;
@override final  String? nomeSocial;
@override final  String emailInstitucional;
@override final  DateTime? dataNascimento;
@override final  String? numeroCelular;
@override final  String? campus;
@override final  String? cidade;
@override final  String? bairro;
@override final  bool isMotorista;
@override final  bool isAtivo;
@override final  Carro? carro;
 final  List<Rota>? _rotasCadastradas;
@override List<Rota>? get rotasCadastradas {
  final value = _rotasCadastradas;
  if (value == null) return null;
  if (_rotasCadastradas is EqualUnmodifiableListView) return _rotasCadastradas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsuarioDadosCopyWith<UsuarioDados> get copyWith => _$UsuarioDadosCopyWithImpl<UsuarioDados>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsuarioDadosToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsuarioDados&&(identical(other.uId, uId) || other.uId == uId)&&(identical(other.nome, nome) || other.nome == nome)&&(identical(other.fotoPerfilUrl, fotoPerfilUrl) || other.fotoPerfilUrl == fotoPerfilUrl)&&(identical(other.nomeSocial, nomeSocial) || other.nomeSocial == nomeSocial)&&(identical(other.emailInstitucional, emailInstitucional) || other.emailInstitucional == emailInstitucional)&&(identical(other.dataNascimento, dataNascimento) || other.dataNascimento == dataNascimento)&&(identical(other.numeroCelular, numeroCelular) || other.numeroCelular == numeroCelular)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.cidade, cidade) || other.cidade == cidade)&&(identical(other.bairro, bairro) || other.bairro == bairro)&&(identical(other.isMotorista, isMotorista) || other.isMotorista == isMotorista)&&(identical(other.isAtivo, isAtivo) || other.isAtivo == isAtivo)&&(identical(other.carro, carro) || other.carro == carro)&&const DeepCollectionEquality().equals(other._rotasCadastradas, _rotasCadastradas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uId,nome,fotoPerfilUrl,nomeSocial,emailInstitucional,dataNascimento,numeroCelular,campus,cidade,bairro,isMotorista,isAtivo,carro,const DeepCollectionEquality().hash(_rotasCadastradas));

@override
String toString() {
  return 'Usuario(uId: $uId, nome: $nome, fotoPerfilUrl: $fotoPerfilUrl, nomeSocial: $nomeSocial, emailInstitucional: $emailInstitucional, dataNascimento: $dataNascimento, numeroCelular: $numeroCelular, campus: $campus, cidade: $cidade, bairro: $bairro, isMotorista: $isMotorista, isAtivo: $isAtivo, carro: $carro, rotasCadastradas: $rotasCadastradas)';
}


}

/// @nodoc
abstract mixin class $UsuarioDadosCopyWith<$Res> implements $UsuarioCopyWith<$Res> {
  factory $UsuarioDadosCopyWith(UsuarioDados value, $Res Function(UsuarioDados) _then) = _$UsuarioDadosCopyWithImpl;
@override @useResult
$Res call({
 String uId, String nome, String? fotoPerfilUrl, String? nomeSocial, String emailInstitucional, DateTime? dataNascimento, String? numeroCelular, String? campus, String? cidade, String? bairro, bool isMotorista, bool isAtivo, Carro? carro, List<Rota>? rotasCadastradas
});


@override $CarroCopyWith<$Res>? get carro;

}
/// @nodoc
class _$UsuarioDadosCopyWithImpl<$Res>
    implements $UsuarioDadosCopyWith<$Res> {
  _$UsuarioDadosCopyWithImpl(this._self, this._then);

  final UsuarioDados _self;
  final $Res Function(UsuarioDados) _then;

/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uId = null,Object? nome = null,Object? fotoPerfilUrl = freezed,Object? nomeSocial = freezed,Object? emailInstitucional = null,Object? dataNascimento = freezed,Object? numeroCelular = freezed,Object? campus = freezed,Object? cidade = freezed,Object? bairro = freezed,Object? isMotorista = null,Object? isAtivo = null,Object? carro = freezed,Object? rotasCadastradas = freezed,}) {
  return _then(UsuarioDados(
uId: null == uId ? _self.uId : uId // ignore: cast_nullable_to_non_nullable
as String,nome: null == nome ? _self.nome : nome // ignore: cast_nullable_to_non_nullable
as String,fotoPerfilUrl: freezed == fotoPerfilUrl ? _self.fotoPerfilUrl : fotoPerfilUrl // ignore: cast_nullable_to_non_nullable
as String?,nomeSocial: freezed == nomeSocial ? _self.nomeSocial : nomeSocial // ignore: cast_nullable_to_non_nullable
as String?,emailInstitucional: null == emailInstitucional ? _self.emailInstitucional : emailInstitucional // ignore: cast_nullable_to_non_nullable
as String,dataNascimento: freezed == dataNascimento ? _self.dataNascimento : dataNascimento // ignore: cast_nullable_to_non_nullable
as DateTime?,numeroCelular: freezed == numeroCelular ? _self.numeroCelular : numeroCelular // ignore: cast_nullable_to_non_nullable
as String?,campus: freezed == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String?,cidade: freezed == cidade ? _self.cidade : cidade // ignore: cast_nullable_to_non_nullable
as String?,bairro: freezed == bairro ? _self.bairro : bairro // ignore: cast_nullable_to_non_nullable
as String?,isMotorista: null == isMotorista ? _self.isMotorista : isMotorista // ignore: cast_nullable_to_non_nullable
as bool,isAtivo: null == isAtivo ? _self.isAtivo : isAtivo // ignore: cast_nullable_to_non_nullable
as bool,carro: freezed == carro ? _self.carro : carro // ignore: cast_nullable_to_non_nullable
as Carro?,rotasCadastradas: freezed == rotasCadastradas ? _self._rotasCadastradas : rotasCadastradas // ignore: cast_nullable_to_non_nullable
as List<Rota>?,
  ));
}

/// Create a copy of Usuario
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CarroCopyWith<$Res>? get carro {
    if (_self.carro == null) {
    return null;
  }

  return $CarroCopyWith<$Res>(_self.carro!, (value) {
    return _then(_self.copyWith(carro: value));
  });
}
}

// dart format on
