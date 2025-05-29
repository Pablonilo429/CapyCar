import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/dtos/credentials_carona.dart';
import 'package:capy_car/domain/dtos/credentials_rota.dart';
import 'package:capy_car/domain/validators/credentials_carona_validator.dart'; // Import validator
import 'package:capy_car/domain/validators/credentials_rota_validator.dart'; // Import validator
import 'package:capy_car/ui/carona/cadastro/cadastrar_carona_view_model.dart';
import 'package:capy_car/ui/components/appBar.dart';
import 'package:capy_car/ui/components/appBottomNavigation.dart';
import 'package:capy_car/ui/components/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:result_command/result_command.dart';

class CadastrarCaronaPage extends StatefulWidget {
  const CadastrarCaronaPage({super.key});

  @override
  State<CadastrarCaronaPage> createState() => _CadastrarCaronaPageState();
}

class _CadastrarCaronaPageState extends State<CadastrarCaronaPage> {
  late final CadastrarCaronaViewModel viewModel;

  // Instantiate validators in the State class
  final CredentialsCaronaValidator _caronaValidator =
      CredentialsCaronaValidator();
  final CredentialsRotaValidator _rotaValidator = CredentialsRotaValidator();
  final _formKey = GlobalKey<FormState>(); // For overall form validation

  final _saidaController = TextEditingController();
  final _pontoController = TextEditingController();
  final _precoController = TextEditingController();
  final _pontoFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    viewModel = injector.get<CadastrarCaronaViewModel>();
    viewModel.init();
    viewModel.addListener(_onViewModelChanged);
    viewModel.disponibilizarCaronaCommand.addListener(_handleCommandState);
    _syncControllersWithViewModel(); // Initial sync
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    _syncControllersWithViewModel();
    setState(() {});
  }

  void _syncControllersWithViewModel() {
    if (_saidaController.text !=
        (viewModel.credentials.rota?.cidadeSaida ?? '')) {
      _saidaController.text = viewModel.credentials.rota?.cidadeSaida ?? '';
    }
    final precoVm = viewModel.credentials.preco
        .toStringAsFixed(2)
        .replaceAll('.', ',');
    if (_precoController.text != precoVm) {
      _precoController.text = precoVm;
    }
  }

  void _handleCommandState() {
    if (!mounted) return;
    viewModel.disponibilizarCaronaCommand;
    if (viewModel.disponibilizarCaronaCommand.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Carona disponibilizada com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
      _formKey.currentState?.reset();
      viewModel.onRotaSalvaSelecionada(null); // Reset selection
      viewModel.credentials = CredentialsCarona(
        rota: CredentialsRota(),
        idMotorista: viewModel.currentUser?.uId ?? '',
      ); // Reset credentials
      viewModel.setSelectedDate(DateTime.now()); // Reset date
      setState(() {});
    } else if (viewModel.disponibilizarCaronaCommand.isFailure) {
      final error =
          viewModel.disponibilizarCaronaCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.disponibilizarCaronaCommand.removeListener(_handleCommandState);
    _saidaController.dispose();
    _pontoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  String? _validatePontoItemInput(String? currentTextValue) {
    final tempCredentialsForPontoValidation = CredentialsRota(
      campus: viewModel.credentials.rota?.campus ?? '',
      cidadeSaida: viewModel.credentials.rota?.cidadeSaida ?? '',
      nomeRota:
          viewModel.credentials.rota?.nomeRota?.isEmpty ?? true
              ? 'cadastrado'
              : viewModel.credentials.rota?.nomeRota,
      pontos: viewModel.credentials.rota!.pontos,
    );

    // Use the _rotaValidator instance from your State class
    var specificFieldValidator = _rotaValidator.byField(
      tempCredentialsForPontoValidation,
      'pontos_items', // Assuming 'pontos_items' is the rule for individual point validation
    );

    return specificFieldValidator();
  }

  InputDecoration _buildInputDecoration({
    String? hintText,
    Widget? prefixIcon,
    String? prefixText,
    String? labelText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[350]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  TextStyle get _labelStyle => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
  );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      // Allow today
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != viewModel.selectedDate) {
      viewModel.setSelectedDate(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isSaida) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          (isSaida
              ? viewModel.selectedTimeSaida
              : viewModel.selectedTimeChegada) ??
          TimeOfDay.now(),
    );
    if (picked != null) {
      DateTime selectedDateTime = DateTime(
        viewModel.selectedDate.year,
        viewModel.selectedDate.month,
        viewModel.selectedDate.day,
        picked.hour,
        picked.minute,
      );

      // Check if the selected time is in the past
      if (selectedDateTime.isBefore(DateTime.now())) {
        // If it's in the past, add one day
        selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        // Update the selected date to reflect the added day
        viewModel.setSelectedDate(selectedDateTime);
      }

      if (isSaida) {
        viewModel.setHorarioSaida(picked);
      } else {
        viewModel.setHorarioChegada(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, child) {
        // Sync controllers (moved to _onViewModelChanged and initState for more controlled updates)
        return Scaffold(
          appBar: CustomAppBar(greeting: 'Oferecer Viagem', isPop: false),
          drawer: AppDrawer(),
          bottomNavigationBar: AppBottomNavigation(index: 1),
          body: AbsorbPointer(
            absorbing: viewModel.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Volta Switch and Disponibilizar Carona Button ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Volta", style: _labelStyle),
                            const SizedBox(height: 4),
                            Switch(
                              value: viewModel.credentials.isVolta ?? false,
                              onChanged: viewModel.setIsVolta,
                              activeColor: theme.primaryColor,
                            ),
                          ],
                        ),

                        // In _CadastrarCaronaPageState > build method > ElevatedButton for "Disponibilizar Carona":
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed:
                              viewModel.disponibilizarCaronaCommand.isRunning
                                  ? null
                                  : () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      debugPrint('  Rota:');
                                      debugPrint(
                                        '    nomeRota: ${viewModel.credentials.rota!.nomeRota}',
                                      );
                                      debugPrint(
                                        '    cidadeSaida: ${viewModel.credentials.rota!.cidadeSaida}',
                                      );
                                      debugPrint(
                                        '    campus: ${viewModel.credentials.rota!.campus}',
                                      );
                                      debugPrint(
                                        '    pontos: ${viewModel.credentials.rota!.pontos}',
                                      );
                                      debugPrint(
                                        'horarioSaida: ${viewModel.credentials.horarioSaida?.toIso8601String()}',
                                      );
                                      debugPrint(
                                        'horarioChegada: ${viewModel.credentials.horarioChegada?.toIso8601String()}',
                                      );
                                      debugPrint(
                                        'qtdePassageiros: ${viewModel.credentials.qtdePassageiros}',
                                      );
                                      debugPrint(
                                        'preco: ${viewModel.credentials.preco}',
                                      );
                                      debugPrint(
                                        'isVolta: ${viewModel.credentials.isVolta}',
                                      );
                                      debugPrint(
                                        '---------------------------------------------------',
                                      );
                                      if (_caronaValidator
                                              .validate(viewModel.credentials)
                                              .isValid &&
                                          _rotaValidator
                                              .validate(
                                                viewModel.credentials.rota!,
                                              )
                                              .isValid) {
                                        viewModel.disponibilizarCaronaCommand
                                            .execute();
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Por favor, corrija os erros no formulário.",
                                            ),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Por favor, preencha todos os campos corretamente.",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                          child:
                              viewModel.disponibilizarCaronaCommand.isRunning
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text("Disponibilizar Carona"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- Rotas Salvas ---
                    Text("Rotas Salvas", style: _labelStyle),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: viewModel.selectedRotaIdForPreFilling,
                      decoration: _buildInputDecoration(
                        hintText: 'Usar rota salva ou preencher manualmente',
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: 'manual_input_for_carona',
                          child: Text('Preencher rota manualmente'),
                        ),
                        ...viewModel.rotasSalvasDoUsuario.map((rota) {
                          return DropdownMenuItem<String>(
                            value: rota.id,
                            child: Text(
                              rota.nome ??
                                  'Rota ID: ${rota.id?.substring(0, 5)}...',
                            ),
                          );
                        }),
                      ],
                      onChanged: viewModel.onRotaSalvaSelecionada,
                    ),
                    const SizedBox(height: 20),

                    // --- Saída ---
                    Text("Saída", style: _labelStyle),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _saidaController,
                      decoration: _buildInputDecoration(
                        hintText: 'Bairro ou cidade de saída/chegada',
                      ),
                      onChanged: viewModel.setSaida,
                      validator:
                          (value) => _rotaValidator.byField(
                            viewModel.credentials.rota ?? CredentialsRota(),
                            // Ensure rota is not null
                            'cidadeSaida',
                          )(value),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 20),

                    // --- Campus ---
                    Text("Campus", style: _labelStyle),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value:
                          viewModel.credentials.rota?.campus.isNotEmpty == true
                              ? viewModel.credentials.rota?.campus
                              : null,
                      decoration: _buildInputDecoration(labelText: 'Campus'),
                      // labelText here as it's part of Dropdown
                      items:
                          ['Seropédica', 'Nova Iguaçu', 'Três Rios'].map((
                            campus,
                          ) {
                            return DropdownMenuItem<String>(
                              value: campus,
                              child: Text(campus),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) viewModel.setCampus(value);
                      },
                      validator:
                          (value) => _rotaValidator.byField(
                            viewModel.credentials.rota ?? CredentialsRota(),
                            // Ensure rota is not null
                            'campus',
                          )(value),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 20),

                    // --- Adicionar Pontos da Carona ---
                    Text("Adicionar Pontos da Carona", style: _labelStyle),
                    const SizedBox(height: 6),

                    TextFormField(
                      key: _pontoFieldKey,
                      controller: _pontoController,
                      decoration: _buildInputDecoration(
                        hintText: 'Nome do ponto (Ex: Cabuçu)',
                      ),
                      validator: _validatePontoItemInput,
                      // Use the method from the State class
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),

                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_pontoFieldKey.currentState?.validate() ??
                              false) {
                            if (_pontoController.text.trim().isNotEmpty) {
                              viewModel.addPonto(_pontoController.text.trim());
                              _pontoController.clear();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(14),
                          backgroundColor: theme.primaryColor,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (viewModel.credentials.rota?.pontos.isNotEmpty == true)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children:
                            viewModel.credentials.rota!.pontos.map((ponto) {
                              return Chip(
                                label: Text(ponto),
                                backgroundColor: theme.primaryColor.withOpacity(
                                  0.15,
                                ),
                                labelStyle: TextStyle(
                                  color: theme.primaryColorDark,
                                  fontSize: 13,
                                ),
                                onDeleted: () => viewModel.removePonto(ponto),
                                deleteIconColor: theme.primaryColorDark
                                    .withOpacity(0.7),
                              );
                            }).toList(),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Nenhum ponto de carona adicionado.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // --- Horário de Saída ---
                    Text("Horário de Saída", style: _labelStyle),
                    const SizedBox(height: 6),
                    TextFormField(
                      readOnly: true,
                      decoration: _buildInputDecoration(
                        hintText:
                            viewModel.selectedTimeSaida?.format(context) ??
                            'Selecione...',
                        prefixIcon: const Icon(Icons.access_time),
                      ),
                      onTap: () => _selectTime(context, true),
                      validator:
                          (value) => _caronaValidator.byField(
                            // `value` from TextFormField is ignored here
                            viewModel.credentials,
                            'horarioSaida',
                          )(
                            viewModel.credentials.horarioSaida
                                ?.toIso8601String(),
                          ),
                      // Pass the actual value to validate
                      autovalidateMode:
                          AutovalidateMode
                              .onUserInteraction, // Pass value for byField to work
                    ),
                    const SizedBox(height: 20),

                    // --- Horário de Chegada ---
                    Text("Horário de Chegada", style: _labelStyle),
                    const SizedBox(height: 6),
                    TextFormField(
                      readOnly: true,
                      decoration: _buildInputDecoration(
                        hintText:
                            viewModel.selectedTimeChegada?.format(context) ??
                            'Selecione...',
                        prefixIcon: const Icon(Icons.access_time),
                      ),
                      onTap: () => _selectTime(context, false),
                      validator: (value) {
                        final error = _caronaValidator.byField(
                          viewModel.credentials,
                          'horarioChegada',
                        )(
                          viewModel.credentials.horarioChegada
                              ?.toIso8601String(),
                        );
                        if (error != null) return error;
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 20),

                    // --- Quantidade de Passageiros ---
                    Text("Quantidade de Passageiros", style: _labelStyle),
                    const SizedBox(height: 6),
                    // In _CadastrarCaronaPageState > build method > DropdownButtonFormField for "Quantidade de Passageiros"
                    DropdownButtonFormField<int>(
                      value: viewModel.credentials.qtdePassageiros,
                      decoration: _buildInputDecoration(
                        labelText: 'Número de vagas',
                      ),
                      items:
                          [1, 2, 3, 4]
                              .map(
                                (n) => DropdownMenuItem(
                                  value: n,
                                  child: Text('$n vaga${n > 1 ? 's' : ''}'),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) viewModel.setQtdePassageiros(value);
                      },
                      validator: (int? value) {
                        String? stringValue = value?.toString();

                        final fieldSpecificValidator = _caronaValidator.byField(
                          viewModel.credentials,
                          'qtdePassageiros',
                        );
                        return fieldSpecificValidator(stringValue);
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 20),

                    // --- Preço da Carona ---
                    Text("Preço da Carona", style: _labelStyle),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _precoController,
                      decoration: _buildInputDecoration(
                        hintText: '0,00',
                        prefixText: 'R\$ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*([,.]\d{0,2})?$'),
                        ),
                      ],
                      onChanged: viewModel.setPreco,
                      validator: _caronaValidator.byField(
                        viewModel.credentials,
                        'preco',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
