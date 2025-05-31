import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/dtos/credentials_esqueci_senha.dart';
import 'package:capy_car/domain/validators/credentials_esqueci_senha_validator.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/auth/senha/esqueci_senha_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:routefly/routefly.dart';

class EsqueciSenhaPage extends StatefulWidget {
  const EsqueciSenhaPage({super.key});

  @override
  State<EsqueciSenhaPage> createState() => _EsqueciSenhaPageState();
}

class _EsqueciSenhaPageState extends State<EsqueciSenhaPage> {
  final viewModel = injector.get<EsqueciSenhaViewModel>();
  final credentials = CredentialsEsqueciSenha();
  final validator = CredentialsEsqueciSenhaValidator();

  final emailController = TextEditingController();
  bool _cadastroConcluido = false;

  void _onCadastroFinalizado() {}

  @override
  void initState() {
    super.initState();

    viewModel.esqueciSenhaCommand.addListener(_listenable);
  }

  void _listenable() {
    if (viewModel.esqueciSenhaCommand.isSuccess) {
      setState(() {
        _cadastroConcluido = true;
      });
    } else if (viewModel.esqueciSenhaCommand.isFailure) {
      final error = viewModel.esqueciSenhaCommand.value as FailureCommand;

      final snackBar = SnackBar(
        content: Text(error.error.toString()),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    viewModel.esqueciSenhaCommand.removeListener(_listenable);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          children: [
            IconButton(
              iconSize: 30.0,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Routefly.navigate(routePaths.auth.login);
              },
            ),
          ],
        ),
      ),
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
            child:
                _cadastroConcluido
                    ? _buildSucessoContent()
                    : _buildFormularioContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormularioContent() {
    return Column(
      children: [
        const Text(
          'Esqueceu a senha? Entre com o email da sua conta',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        TextFormField(
          controller: emailController,
          onChanged: credentials.setEmail,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "email"),
          decoration: _buildInputDecoration('Email Institucional @ufrrj'),
        ),
        const SizedBox(height: 12),

        const SizedBox(height: 16),

        ElevatedButton.icon(
          style: _botaoEstilo,
          onPressed:
              viewModel.esqueciSenhaCommand.isRunning
                  ? null
                  : () {
                    viewModel.esqueciSenhaCommand.execute(credentials);
                  },
          icon: const Icon(Icons.person_add),
          label: const Text('Cadastrar'),
        ),
      ],
    );
  }

  Widget _buildSucessoContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage(
            "https://res.cloudinary.com/ddemkhgt4/image/upload/v1746151975/logo_capy_car.png",
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Verifique a sua caixa de e-mail para\nalterar sua senha!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 64),
        ElevatedButton.icon(
          onPressed: () => Routefly.navigate('/auth/login'),
          icon: const Icon(Icons.login),
          label: const Text('Login'),
          style: _botaoEstilo,
        ),
      ],
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

  final _botaoEstilo = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  );
}
