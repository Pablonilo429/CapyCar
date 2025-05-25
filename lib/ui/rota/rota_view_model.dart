import 'dart:async';

import 'package:capy_car/data/repositories/auth/auth_repository.dart';
import 'package:capy_car/data/repositories/rota/rota_repository.dart';
import 'package:capy_car/domain/dtos/credentials_rota.dart';
import 'package:capy_car/domain/models/rota/rota.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:capy_car/domain/validators/credentials_rota_validator.dart';

import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class RotaViewModel extends ChangeNotifier {
  final RotaRepository _rotaRepository;
  final AuthRepository _authRepository;

  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  late final StreamSubscription _userSubscription;

  RotaViewModel(this._rotaRepository, this._authRepository);

  Future<void> _recarregarRotas() async {
    final result = await _authRepository.getUser();

    result.fold(
      (user) {
        _usuario = user;
        rotasSalvas = user.rotasCadastradas ?? [];
        notifyListeners();
      },
      (exception) {
        debugPrint('Erro ao recarregar rotas: ${exception.toString()}');
      },
    );
  }

  CredentialsRota credentials = CredentialsRota();
  CredentialsRotaValidator validator = CredentialsRotaValidator();

  List<Rota> rotasSalvas = [];
  String selectedRotaIdOrNew = 'nova';

  // Comandos
  late final salvarRotaCommand = Command0(_salvarRotaInternamente);
  late final excluirRotaCommand = Command0(_excluirRotaInternamente);

  Future<void> init() async {
    await _recarregarRotas();
  }


  void onRotaSelecionada(String? id) {
    selectedRotaIdOrNew = id ?? 'nova';

    if (id == 'nova') {
      credentials = CredentialsRota();
    } else {
      final rota = rotasSalvas.firstWhere((r) => r.id == id);
      credentials = CredentialsRota(
        nomeRota: rota.nome,
        cidadeSaida: rota.saida,
        campus: rota.campus,
        pontos: [...rota.pontos],
      );
    }

    notifyListeners();
  }

  void addPonto(String ponto) {
    if (ponto.trim().isNotEmpty && !credentials.pontos.contains(ponto)) {
      credentials.pontos.add(ponto);
      notifyListeners();
    }
  }

  void removePonto(String ponto) {
    credentials.pontos.remove(ponto);
    notifyListeners();
  }


  String? validateCurrentPontoInput(String? currentTextValue) {
    // 1. Perform basic, immediate checks on currentTextValue if desired (optional).
    //    This can give faster feedback for simple issues like an empty string,
    //    before involving the more complex entity validation.
    if (currentTextValue == null || currentTextValue.isEmpty) {
      return "O ponto não pode ser vazio."; // Or your preferred message for empty input
    }
    // Example: if you wanted an immediate local check for length too, though
    // the 'pontos_items' rule will cover it.
    // if (currentTextValue.length > 50) {
    //   return "O ponto não deve exceder 50 caracteres (verificação local).";
    // }

    // 2. Create a temporary CredentialsRota instance.
    //    The 'pontos' list in this temporary instance will contain *only* the currentTextValue.
    //    This allows the 'pontos_items' rule (which iterates over the list) to check this single item.
    final tempCredentials = CredentialsRota(
      campus: credentials.campus, // Use current or valid default values
      cidadeSaida: credentials.cidadeSaida, // Use current or valid default values
      nomeRota: credentials.nomeRota, // Use current or valid default values
      pontos: [currentTextValue], // The list of points now contains ONLY the current text
    );

    // 3. Get the validator function from byField.
    //    'byField' returns a function that is bound to 'tempCredentials' and the 'pontos_items' rule.
    var specificFieldValidator = validator.byField(tempCredentials, 'pontos_items');

    // 4. Call the returned validator function.
    //    This function expects the value of the field it's supposed to validate.
    //    Even if the 'pontos_items' rule primarily looks at 'tempCredentials.pontos',
    //    passing 'currentTextValue' here conforms to the FormFieldValidator signature.
    //    The LucidValidation framework will ensure that the 'must' condition inside your
    //    'pontos_items' rule operates on 'tempCredentials.pontos' (which is [currentTextValue]).
    String? errorMessage = specificFieldValidator(currentTextValue);

    return errorMessage;
  }

  /// Método chamado internamente pelo [salvarRotaCommand]
  AsyncResult<Rota> _salvarRotaInternamente() async {
    final userId = usuario!.uId;

    if (selectedRotaIdOrNew == 'nova') {
      final result = await _rotaRepository.criarRota(userId, credentials);
      await _recarregarRotas();
      return result;
    } else {

      final rota = Rota(
        id: selectedRotaIdOrNew,
        nome: credentials.nomeRota,
        saida: credentials.cidadeSaida,
        campus: credentials.campus,
        pontos: credentials.pontos,
      );

      final result = await _rotaRepository.editarRota(userId, rota);
      await _recarregarRotas();
      return result;
    }
  }

  /// Método chamado internamente pelo [excluirRotaCommand]
  AsyncResult<Unit> _excluirRotaInternamente() async {
    final userId = usuario!.uId;
    final resultado = await _rotaRepository.excluirRota(
      userId,
      selectedRotaIdOrNew,
    );
    await _recarregarRotas(); // <- Atualiza a lista após exclusão
    selectedRotaIdOrNew = 'nova';
    credentials = CredentialsRota();
    notifyListeners();
    return resultado;
  }

  void _showError(Exception e) {
    debugPrint("Erro: ${e.toString()}");
    // Aqui você pode usar Snackbar ou outro mecanismo de erro
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
}
