import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/dtos/credentials_localizacao.dart';
import 'package:capy_car/domain/validators/credentials_localizacao_validator.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/usuario/cadastro/cadastrar_localizacao_viewmodel.dart';
import 'package:capy_car/utils/GetLocais.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:routefly/routefly.dart';

class CadastrarLocalizacaoPage extends StatefulWidget {
  const CadastrarLocalizacaoPage({super.key});

  @override
  State<CadastrarLocalizacaoPage> createState() =>
      _CadastrarLocalizacaoPageState();
}

class _CadastrarLocalizacaoPageState extends State<CadastrarLocalizacaoPage> {
  String? campusSelecionado;
  String? cidadeSelecionada;
  final bairroController = TextEditingController();

  final viewModel = injector.get<CadastrarLocalizacaoViewmodel>();
  final credentials = CredentialsLocalizacao();
  final validator = CredentialsLocalizacaoValidator();

  var locais = GetLocais();

  @override
  void initState() {
    super.initState();

    viewModel.cadastrarLocalizacaoCommand.addListener(_listenable);
  }

  void _listenable() {
    if (viewModel.cadastrarLocalizacaoCommand.isSuccess) {
      Routefly.navigate(routePaths.usuario.cadastro.cadastrarFoto);
    }

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
    bairroController.dispose();
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
                ),
                const SizedBox(height: 32),
                const Text(
                  'Agora, selecione o seu campus, cidade e bairro\nnos quais costumam ser as suas viagens',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 32),

                // Dropdown de Campus
                DropdownButtonFormField<String>(
                  value: campusSelecionado,
                  validator: validator.byField(credentials, "campus"),
                  items:
                      locais.campusOptions.map((campus) {
                        return DropdownMenuItem(
                          value: campus,
                          child: Text(campus),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      campusSelecionado = value;
                      credentials.setCampus(campusSelecionado!);
                    });
                  },
                  decoration: _buildInputDecoration('Campus'),
                ),
                const SizedBox(height: 16),

                // Dropdown de Cidade
                DropdownButtonFormField<String>(
                  value: cidadeSelecionada,
                  validator: validator.byField(credentials, "cidade"),
                  items:
                      locais.cidadesRioDeJaneiro.map((cidade) {
                        return DropdownMenuItem(
                          value: cidade,
                          child: Text(cidade),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      cidadeSelecionada = value;
                      credentials.setCidade(cidadeSelecionada!);
                    });
                  },
                  decoration: _buildInputDecoration('Cidade'),
                ),
                const SizedBox(height: 16),

                // TextField de Bairro
                TextFormField(
                  controller: bairroController,
                  validator: validator.byField(credentials, "bairro"),
                  onChanged: credentials.setBairro,
                  decoration: _buildInputDecoration('Bairro'),
                ),
                const SizedBox(height: 32),

                // Botão Continuar
                ListenableBuilder(
                  listenable: viewModel.cadastrarLocalizacaoCommand,
                  builder: (context, _) {
                    return ElevatedButton(
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
                      onPressed:
                          viewModel.cadastrarLocalizacaoCommand.isRunning
                              ? null
                              : () {
                                if (validator.validate(credentials).isValid) {
                                  viewModel.cadastrarLocalizacaoCommand.execute(
                                    credentials,
                                  );
                                }
                              },
                      child: const Text('Continuar'),
                    );
                  },
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
