import 'package:capy_car/config/dependencies.dart';

// Ensure this import path is correct for your validator if it's used directly in ViewModel for validateCurrentPontoInput
// import 'package:capy_car/domain/validators/credentials_rota_validator.dart';
import 'package:capy_car/ui/components/appBar.dart';
import 'package:capy_car/ui/components/appDrawer.dart';
import 'package:capy_car/ui/rota/rota_view_model.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

class RotaPage extends StatefulWidget {
  const RotaPage({super.key});

  @override
  State<RotaPage> createState() => _RotaPageState();
}

class _RotaPageState extends State<RotaPage> {
  final viewModel = injector.get<RotaViewModel>();

  final nomeController = TextEditingController();
  final saidaController = TextEditingController();
  final pontoController = TextEditingController();
  final _pontoFieldKey =
      GlobalKey<FormFieldState<String>>(); // Key for ponto TextFormField

  @override
  void initState() {
    super.initState();
    viewModel.init().then((_) => _sincronizarComViewModel());
    viewModel.addListener(_sincronizarComViewModel);
    viewModel.salvarRotaCommand.addListener(_listenableSalvar);
    // It's good practice to also listen to excluirRotaCommand if it's not covered by a general view model update
    viewModel.excluirRotaCommand.addListener(_listenableExcluir);
  }

  void _listenableSalvar() {
    if (!mounted) return; // Ensure widget is still in the tree

    if (viewModel.salvarRotaCommand.isSuccess) {
      final snackBar = SnackBar(
        content: Text("Rota salva com sucesso!"),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ViewModel should ideally handle clearing/resetting state,
      // and _sincronizarComViewModel will update UI.
      // setState(() {}); // Often not needed if ViewModel + AnimatedBuilder handle UI updates
    }

    if (viewModel.excluirRotaCommand.isSuccess) {
      final snackBar = SnackBar(
        content: Text("Rota excluída com sucesso!"),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ViewModel should reset to "nova rota" or similar state
      // setState(() {}); // Often not needed
    }

    if (viewModel.salvarRotaCommand.isFailure) {
      final error = viewModel.salvarRotaCommand.value as FailureCommand;
      final snackBar = SnackBar(
        content: Text(error.error.toString()),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    // You might want to handle excluirRotaCommand.isFailure as well
  }

  void _listenableExcluir() {
    if (!mounted) return; // Ensure widget is still in the tree

    if (viewModel.excluirRotaCommand.isSuccess) {
      final snackBar = SnackBar(
        content: Text("Rota excluída com sucesso!"),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ViewModel should reset to "nova rota" or similar state
      // setState(() {}); // Often not needed
    }

    // You might want to handle excluirRotaCommand.isFailure as well
  }

  void _sincronizarComViewModel() {
    if (!mounted) return;
    nomeController.text =
        viewModel.credentials.nomeRota ?? ''; // Handle null from new route
    saidaController.text = viewModel.credentials.cidadeSaida;
    // Ponto controller is usually managed by user input, not synced from existing list directly
    // If selecting an existing route clears points, that's viewModel logic.
    setState(
      () {},
    ); // Ensure UI rebuilds if viewModel state changes that aren't covered by AnimatedBuilder children
  }

  @override
  void dispose() {
    viewModel.removeListener(_sincronizarComViewModel);
    viewModel.salvarRotaCommand.removeListener(_listenableSalvar);
    viewModel.excluirRotaCommand.removeListener(_listenableExcluir);
    nomeController.dispose();
    saidaController.dispose();
    pontoController.dispose();
    super.dispose();
  }

  // Helper to build consistent InputDecoration
  InputDecoration _buildInputDecoration({
    String? labelText,
    String? hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      // Modern theme color for filled fields
      // Or a more specific grey: Colors.grey[100] or Colors.grey[200]
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12.0,
        ), // Slightly more rounded like image
        // Clean, filled look without explicit border
      ),
      enabledBorder: OutlineInputBorder(
        // Subtle border when enabled
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        // Border when focused
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }

  TextStyle? get _labelStyle =>
      Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(greeting: "Cadastrar/Editar Rotas", isPop: false),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        primary: true,
        child: AnimatedBuilder(
          // Listen to viewModel for UI updates
          animation: viewModel,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              // Added bottom padding
              child: SingleChildScrollView(
                primary: false,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  children: [
                    // Dropdown de rotas salvas
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: viewModel.selectedRotaIdOrNew,
                      decoration: _buildInputDecoration(
                        labelText: 'Rotas Salvas',
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: 'nova',
                          child: Text('Criar Nova Rota'),
                        ),
                        ...viewModel.rotasSalvas.map(
                          (r) => DropdownMenuItem(
                            value: r.id!,
                            child: Text(
                              r.nome ?? 'Rota Sem Nome',
                            ), // Provide fallback
                          ),
                        ),
                      ],
                      onChanged: (id) {
                        viewModel.onRotaSelecionada(id);
                        // Controllers will be updated by _sincronizarComViewModel
                      },
                    ),
                    const SizedBox(height: 20),

                    // Nome da Rota (with Apagar Rota button next to label)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Nome da Rota", style: _labelStyle),
                        if (viewModel.selectedRotaIdOrNew != 'nova')
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed:
                                viewModel.excluirRotaCommand.isRunning
                                    ? null
                                    : () {
                                      viewModel.excluirRotaCommand.execute();
                                    },
                            icon: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context).colorScheme.error,
                              size: 20,
                            ),
                            label: Text(
                              'Apagar Rota',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: nomeController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _buildInputDecoration(
                        hintText: 'Ex: Rural - Ida',
                      ),
                      onChanged: viewModel.credentials.setNomeRota,
                      validator: viewModel.validator.byField(
                        viewModel.credentials,
                        'nomeRota',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Saída
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Saída", style: _labelStyle),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: saidaController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _buildInputDecoration(
                        hintText: 'Bairro ou cidade de saída',
                      ),
                      onChanged: viewModel.credentials.setCidadeSaida,
                      validator: viewModel.validator.byField(
                        viewModel.credentials,
                        'cidadeSaida',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Campus
                    DropdownButtonFormField<String>(
                      value:
                          viewModel.credentials.campus.isEmpty
                              ? null
                              : viewModel.credentials.campus,
                      decoration: _buildInputDecoration(labelText: 'Campus'),
                      items: const [
                        // Consider making these dynamic if they change
                        DropdownMenuItem(
                          value: 'Seropédica',
                          child: Text('Seropédica'),
                        ),
                        DropdownMenuItem(
                          value: 'Nova Iguaçu',
                          child: Text('Nova Iguaçu'),
                        ),
                        DropdownMenuItem(
                          value: 'Três Rios',
                          child: Text('Três Rios'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          viewModel.credentials.setCampus(value);
                          setState(() {}); // Update UI for dropdown change
                        }
                      },
                      validator: viewModel.validator.byField(
                        viewModel.credentials,
                        'campus',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Adicionar ponto
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Adicionar Pontos da Carona", style: _labelStyle),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align items to the top
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: _pontoFieldKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: pontoController,
                            validator: viewModel.validateCurrentPontoInput,
                            enabled: viewModel.credentials.pontos.length < 10,
                            decoration: _buildInputDecoration(
                              hintText: 'Nome do ponto',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          // Padding to align button better if TextFormField has contentPadding
                          padding: const EdgeInsets.only(top: 0),
                          // Adjust if field height changes
                          child: ElevatedButton(
                            onPressed:
                                (viewModel.credentials.pontos.length < 10)
                                    ? () {
                                      final isPontoValid =
                                          _pontoFieldKey.currentState
                                              ?.validate() ??
                                          false;
                                      if (isPontoValid) {
                                        final pontoText =
                                            pontoController.text.trim();
                                        if (pontoText.isNotEmpty) {
                                          viewModel.addPonto(pontoText);
                                          pontoController.clear();
                                          // Optional: Request focus back after a short delay
                                          // Future.delayed(const Duration(milliseconds: 50), () {
                                          //   FocusScope.of(context).requestFocus(_pontoFieldKey.currentContext != null ? Focus.of(_pontoFieldKey.currentContext!) : null);
                                          // });
                                        }
                                      }
                                    }
                                    : null, // Disable if max points reached
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(14), // Adjust size
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Lista de pontos
                    if (viewModel.credentials.pontos.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            viewModel.credentials.pontos.map((ponto) {
                              return Chip(
                                label: Text(ponto),
                                onDeleted: () => viewModel.removePonto(ponto),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer.withOpacity(0.6),
                                deleteIconColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                labelStyle: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                              );
                            }).toList(),
                      )
                    else
                      Container(
                        // Placeholder when no points are added
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Nenhum ponto adicionado.',
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ),
                    const SizedBox(height: 30), // More space before buttons
                    // Botão Salvar (Apagar Rota foi movido para cima)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed:
                            viewModel.salvarRotaCommand.isRunning
                                ? null
                                : () {
                                  // Trigger validation for all fields in the form before saving
                                  // This assumes your TextFormFields are part of a Form widget
                                  // If not, ensure individual validators have run, or validate all manually.
                                  if (viewModel.validator
                                      .validate(viewModel.credentials)
                                      .isValid) {
                                    viewModel.salvarRotaCommand.execute();
                                  } else {
                                    // Optional: Show a generic message to check fields
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Por favor, corrija os erros no formulário.',
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          textStyle: Theme.of(context).textTheme.labelLarge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ), // Consistent rounding
                          ),
                        ),
                        child: const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
