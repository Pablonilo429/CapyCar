import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/dtos/credentials_carro.dart';
import 'package:capy_car/domain/validators/credentials_carro_validator.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/usuario/cadastro/cadastrar_carro_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:routefly/routefly.dart';

class CadastrarCarroPage extends StatefulWidget {
  const CadastrarCarroPage({super.key});

  @override
  State<CadastrarCarroPage> createState() => _CadastrarCarroPageState();
}

class _CadastrarCarroPageState extends State<CadastrarCarroPage> {
  final marcaController = TextEditingController();
  final modeloController = TextEditingController();
  final corController = TextEditingController();
  final placaController = TextEditingController();

  final viewModel = injector.get<CadastrarCarroViewmodel>();
  final credentials = CredentialsCarro();
  final validator = CredentialsCarroValidator();

  @override
  void initState() {
    super.initState();

    viewModel.cadastrarLocalizacaoCommand.addListener(_listenable);
  }

  void _listenable() {
    if (viewModel.cadastrarLocalizacaoCommand.isFailure) {
      final error =
          viewModel.cadastrarLocalizacaoCommand.value as FailureCommand;

      final snackBar = SnackBar(
        content: Text(error.error.toString()),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    marcaController.dispose();
    modeloController.dispose();
    corController.dispose();
    placaController.dispose();
    viewModel.cadastrarLocalizacaoCommand.removeListener(_listenable);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1974BF), Color(0xFF2B7422)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                    "https://res.cloudinary.com/ddemkhgt4/image/upload/v1746151975/logo_capy_car.png",
                  ),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Adicione algumas informações sobre o carro no qual as caronas serão feitas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 32),

                // Marca do Carro
                TextFormField(
                  validator: validator.byField(credentials, "marca"),
                  onChanged: credentials.setMarca,
                  controller: marcaController,
                  decoration: _buildInputDecoration('Marca do Carro'),
                ),
                const SizedBox(height: 16),

                // Modelo do Carro
                TextFormField(
                  validator: validator.byField(credentials, "modelo"),
                  onChanged: credentials.setModelo,
                  controller: modeloController,
                  decoration: _buildInputDecoration('Modelo do Carro'),
                ),
                const SizedBox(height: 16),

                // Cor do Carro
                TextFormField(
                  validator: validator.byField(credentials, "cor"),
                  onChanged: credentials.setCor,
                  controller: corController,
                  decoration: _buildInputDecoration('Cor do Carro'),
                ),
                const SizedBox(height: 16),

                // Placa do carro
                TextFormField(
                  validator: validator.byField(credentials, "placa"),
                  onChanged: credentials.setPlaca,
                  controller: placaController,
                  decoration: _buildInputDecoration('Placa do carro'),
                ),
                const SizedBox(height: 32),

                // Botão Continuar
                ListenableBuilder(
                  listenable: viewModel.cadastrarLocalizacaoCommand,
                  builder: (context, _) {
                    return ElevatedButton(
                      onPressed: viewModel.cadastrarLocalizacaoCommand.isRunning ? null : () {
                        if(validator.validate(credentials).isValid){
                          viewModel.cadastrarLocalizacaoCommand.execute(credentials);
                        }
                        if(viewModel.cadastrarLocalizacaoCommand.isSuccess){
                          Routefly.navigate(routePaths.mensagem);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Continuar'),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
