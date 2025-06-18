// --- ui/cadastrar_carona/cadastrar_carona_view_model.dart ---
import 'dart:async';
import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/data/repositories/carona/carona_repository.dart';
import 'package:capy_car/domain/dtos/credentials_carona.dart';
import 'package:capy_car/domain/dtos/credentials_rota.dart';
import 'package:capy_car/domain/models/carona/carona.dart';
import 'package:capy_car/domain/models/rota/rota.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
// import 'package:capy_car/domain/validators/credentials_rota_validator.dart'; // REMOVE - No longer needed here

import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class CadastrarCaronaViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final CaronaRepository _caronaRepository;

  CadastrarCaronaViewModel(this._authRepository, this._caronaRepository);

  Usuario? _currentUser;

  Usuario? get currentUser => _currentUser;

  CredentialsCarona credentials = CredentialsCarona();


  List<Rota> _rotasSalvasDoUsuario = [];

  List<Rota> get rotasSalvasDoUsuario => _rotasSalvasDoUsuario;

  String? _selectedRotaIdForPreFilling;

  String? get selectedRotaIdForPreFilling => _selectedRotaIdForPreFilling;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  TimeOfDay? _selectedTimeSaida;

  TimeOfDay? get selectedTimeSaida => _selectedTimeSaida;

  TimeOfDay? _selectedTimeChegada;

  TimeOfDay? get selectedTimeChegada => _selectedTimeChegada;

  late final disponibilizarCaronaCommand = Command0(
    _disponibilizarCaronaInternamente,
  );

  Future<void> init() async {
    _setLoading(true);
    final result = await _authRepository.getUser();
    result.fold(
      (user) {
        _currentUser = user;
        _rotasSalvasDoUsuario = user.rotasCadastradas ?? [];
        if (_currentUser != null) {
          credentials.setIdMotorista(_currentUser!.uId);
        }
      },
      (error) {
        debugPrint("Error loading user: $error");
      },
    );
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    // The line below seems to create a circular dependency or incorrect assignment.
    // If _isLoading is meant to reflect command running state, it should be set when command starts/ends.
    // value = disponibilizarCaronaCommand.isRunning; // REMOVE or REVISE this line
    notifyListeners();
  }

  void onRotaSalvaSelecionada(String? rotaId) {
    _selectedRotaIdForPreFilling = rotaId;
    if (rotaId != null && rotaId != 'manual_input_for_carona') {
      final rotaSelecionada = _rotasSalvasDoUsuario.firstWhere(
        (r) => r.id == rotaId,
        orElse: () => Rota(id: '', nome: '', saida: '', campus: '', pontos: []),
      );
      credentials.rota = CredentialsRota(
        nomeRota: rotaSelecionada.nome,
        cidadeSaida: rotaSelecionada.saida,
        campus: rotaSelecionada.campus,
        pontos: List<String>.from(rotaSelecionada.pontos),
      );
    } else {
      credentials.rota = CredentialsRota();
    }
    notifyListeners();
  }

  // REMOVE validateCurrentPontoInput - Moved to View
  // String? validateCurrentPontoInput(String? currentTextValue) { ... }

  void setIsVolta(bool isVolta) {
    credentials.setIsVolta(isVolta);
    notifyListeners();
  }

  void setSaida(String saida) {
    credentials.rota ??= CredentialsRota();
    credentials.rota!.setCidadeSaida(saida);
    notifyListeners();
  }

  void setCampus(String campus) {
    credentials.rota ??= CredentialsRota();
    credentials.rota!.setCampus(campus);
    notifyListeners();
  }

  void addPonto(String ponto) {
    credentials.rota ??= CredentialsRota();
    credentials.rota!.addPonto(ponto);
    notifyListeners();
  }

  void removePonto(String ponto) {
    credentials.rota?.removePonto(ponto);
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _updateHorariosDateTime();
    notifyListeners();
  }

  void setHorarioSaida(TimeOfDay time) {
    _selectedTimeSaida = time;
    _updateHorariosDateTime();
    notifyListeners();
  }

  void setHorarioChegada(TimeOfDay time) {
    _selectedTimeChegada = time;
    _updateHorariosDateTime();
    notifyListeners();
  }


  void _updateHorariosDateTime() {
    if (_selectedTimeSaida != null) {
      credentials.setHorarioSaida(
        DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTimeSaida!.hour,
          _selectedTimeSaida!.minute,
        ),
      );
    } else {
      credentials.horarioSaida = null;
    }
    if (_selectedTimeChegada != null) {
      credentials.setHorarioChegada(
        DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTimeChegada!.hour,
          _selectedTimeChegada!.minute,
        ),
      );
    } else {
      credentials.horarioChegada = null;
    }
    // Consider also notifying listeners after updating credentials here if necessary,
    // though individual setters already do.
  }

  void setPreco(double precoDouble) {
    credentials.setPreco(precoDouble);
    notifyListeners();
  }

  void setQtdePassageiros(int qtde) {
    credentials.setQtdePassageiros(qtde);
    notifyListeners();
  }

  AsyncResult<Carona> _disponibilizarCaronaInternamente() async {
    // _setLoading(true); // Command runner usually handles this, or you handle it in the execute wrapper.
    // View now handles validation before calling execute.
    final result = await _caronaRepository.criarCarona(credentials);
    // _setLoading(false); // Similarly, command runner or wrapper.
    return result;
  }


}
