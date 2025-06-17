import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';
import 'package:result_command/result_command.dart';

// Importações do seu projeto (ajuste os caminhos se necessário)
import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/main.dart'; // Para routePaths
import 'package:capy_car/ui/usuario/editar/excluir_conta_view_model.dart';

class ExcluirContaModal extends StatefulWidget {
  const ExcluirContaModal({super.key});

  @override
  State<ExcluirContaModal> createState() => _ExcluirContaModalState();
}

class _ExcluirContaModalState extends State<ExcluirContaModal> {
  // Injeção da ViewModel
  final viewModel = injector.get<ExcluirContaViewModel>();

  // Controladores e chaves para o formulário
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  // Estado para controlar a visibilidade da senha
  bool _exibirSenha = false;

  @override
  void initState() {
    super.initState();
    // Adiciona o listener para reagir aos resultados do comando
    viewModel.excluirContaCommand.addListener(_listenable);
  }

  /// Escuta as mudanças no comando para tratar sucesso e falha.
  void _listenable() {
    // Em caso de sucesso, navega para a tela de login
    if (viewModel.excluirContaCommand.isSuccess) {
      // Garante que a navegação ocorra após o build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        const snackBar = SnackBar(
          content: Text("Conta excluída com sucesso!"),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Routefly.navigate(routePaths.auth.login);
      });
    }
    // Em caso de falha, exibe uma SnackBar com o erro
    if (viewModel.excluirContaCommand.isFailure) {
      final error = viewModel.excluirContaCommand.value as FailureCommand;
      final snackBar = SnackBar(
        content: Text(error.error.toString()),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    viewModel.excluirContaCommand.removeListener(_listenable);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5,
      child: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child:
            // ValueListenableBuilder reage às mudanças no comando (como 'isExecuting')
            ValueListenableBuilder<CommandState>(
              valueListenable: viewModel.excluirContaCommand,
              builder: (context, state, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min, // O modal se ajusta ao conteúdo
                  children: [
                    // --- Título do Modal ---
                    const Text(
                      'Excluir sua Conta',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
        
                    // --- Texto de Aviso ---
                    const Text(
                      'Esta é uma ação irreversível. Todos os seus dados serão perdidos. Para confirmar, por favor, digite sua senha atual.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15.0, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
        
                    // --- Campo de Senha ---
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_exibirSenha,
                      decoration: InputDecoration(
                        labelText: 'Senha atual',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _exibirSenha
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() => _exibirSenha = !_exibirSenha);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
        
                    // --- Botões de Ação ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Botão de Cancelar
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 8),
        
                        // Botão de Excluir (com indicador de progresso)
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              viewModel.excluirContaCommand.execute(
                                _passwordController.text,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text('Excluir'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
