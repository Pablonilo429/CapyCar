import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/dtos/credentials_registrar.dart';
import 'package:capy_car/domain/validators/credentials_registrar_validator.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/auth/registrar/registrar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:result_command/result_command.dart';
import 'package:routefly/routefly.dart';

class RegistrarPage extends StatefulWidget {
  const RegistrarPage({super.key});

  @override
  State<RegistrarPage> createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  final viewModel = injector.get<RegistrarViewModel>();
  final credentials = CredentialsRegistrar();
  final validator = CredentialsRegistrarValidator();

  final nomeCompletoController = TextEditingController();
  final nomeSocialController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  bool aceitoTermos = false;
  bool _cadastroConcluido = false;

  Future<void> _selecionarDataNascimento() async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      dataNascimentoController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(dataSelecionada);
      credentials.setDataNascimento(dataSelecionada);
    }
  }

  void _onCadastroFinalizado() {}

  @override
  void initState() {
    super.initState();

    viewModel.registrarCommand.addListener(_listenable);
  }

  void _listenable() {
    if (viewModel.registrarCommand.isSuccess) {
      setState(() {
        _cadastroConcluido = true;
      });
    } else if (viewModel.registrarCommand.isFailure) {
      final error = viewModel.registrarCommand.value as FailureCommand;

      final snackBar = SnackBar(
        content: Text(error.error.toString()),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    nomeCompletoController.dispose();
    nomeSocialController.dispose();
    dataNascimentoController.dispose();
    emailController.dispose();
    celularController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    viewModel.registrarCommand.removeListener(_listenable);
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
          'Registre-se já',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        TextFormField(
          controller: nomeCompletoController,
          onChanged: credentials.setNomeCompleto,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "nomeCompleto"),
          decoration: _buildInputDecoration('Nome Completo'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: nomeSocialController,
          onChanged: credentials.setNomeSocial,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "nomeSocial"),
          decoration: _buildInputDecoration('Nome Social'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: dataNascimentoController,
          readOnly: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "dateOfBirth"),
          onTap: _selecionarDataNascimento,
          decoration: _buildInputDecoration(
            'Data de Nascimento',
          ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: emailController,
          onChanged: credentials.setEmailInstitucional,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "emailInstitucional"),
          decoration: _buildInputDecoration('Email Institucional @ufrrj'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: celularController,
          onChanged: credentials.setNumeroCelular,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "numeroCelular"),
          decoration: _buildInputDecoration('Celular'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: senhaController,
          onChanged: credentials.setSenha,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "senha"),
          obscureText: true,
          decoration: _buildInputDecoration('Senha'),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: confirmarSenhaController,
          onChanged: credentials.setConfirmarSenha,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator.byField(credentials, "confirmarSenha"),
          obscureText: true,
          decoration: _buildInputDecoration('Confirme sua Senha'),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Checkbox(
              value: aceitoTermos,
              onChanged: (value) {
                setState(() {
                  aceitoTermos = value ?? false;
                });
              },
              activeColor: Colors.purple,
            ),
            const Expanded(
              child: Text(
                'Aceito os termos e condições',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        ElevatedButton.icon(
          style: _botaoEstilo,
          onPressed:
              viewModel.registrarCommand.isRunning
                  ? null
                  : () {
                    if (validator.validate(credentials).isValid) {
                      viewModel.registrarCommand.execute(credentials);
                    }
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
          'Verifique a sua caixa de e-mail para\nconfirmar o cadastro!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 64),
        ElevatedButton.icon(
          onPressed: () => Routefly.navigate(routePaths.auth.login),
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
