import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/dtos/credentials_login.dart';
import 'package:capy_car/domain/validators/credentials_login_validator.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/auth/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:result_command/result_command.dart';
import 'package:routefly/routefly.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final viewModel = injector.get<LoginViewModel>();
  final credentials = CredentialsLogin();
  final validator = CredentialsLoginValidator();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String?
  _errorMessage; // Alterado para uma variável de estado para erro do PWA

  bool _exibirSenha = false;

  @override
  void initState() {
    super.initState();
    viewModel.loginCommand.addListener(_listenable);
  }

  void _listenable() {
    if (viewModel.loginCommand.isSuccess) {
      if (viewModel.usuario?.isPrimeiroLogin == true) {
        Routefly.replace(routePaths.usuario.cadastro.cadastrarLocalizacao);
      } else {
        Routefly.navigate(routePaths.carona.caronaHome);
      }
      Routefly.navigate(routePaths.carona.caronaHome);
    }
    if (viewModel.loginCommand.isFailure) {
      final error = viewModel.loginCommand.value as FailureCommand;

      final snackBar = SnackBar(
        content: Text(error.error.toString()),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    viewModel.loginCommand.removeListener(_listenable);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // Permite que o gradiente de fundo suba atrás da AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Torna a AppBar transparente
        elevation: 0, // Remove a sombra
        actions: [
          // Adiciona os botões "Contato" e "Sobre" aqui
          TextButton(
            onPressed: () =>
              Routefly.navigate(routePaths.contato),

            child: const Text(
              'Contato',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8), // Espaçamento entre os botões
          TextButton(
            onPressed: () =>
                Routefly.navigate(routePaths.sobre),
            child: const Text(
              'Sobre',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(width: 16), // Espaçamento à direita da AppBar
        ],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ... (Seu código existente para a CircleAvatar e textos) ...
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            "https://res.cloudinary.com/ddemkhgt4/image/upload/v1746151975/logo_capy_car.png",
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'CapyCar: O seu app de carona Ruralino',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: validator.byField(credentials, "email"),
                          onChanged: credentials.setEmail,
                          decoration: InputDecoration(
                            hintText: 'exemplo@ufrrj.br',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          onChanged: credentials.setPassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: validator.byField(credentials, "password"),
                          obscureText: !_exibirSenha,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                color: Colors.black,
                                _exibirSenha
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _exibirSenha = !_exibirSenha;
                                });
                              },
                            ),
                            hintText: 'Senha',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed:
                                  () => Routefly.navigate('/auth/registrar'),
                              child: const Text(
                                'Registre-se',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () =>
                                      Routefly.navigate('senha/esqueci_senha'),
                              child: const Text(
                                'Esqueci a minha senha',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AnimatedBuilder(
                          animation: viewModel.loginCommand,
                          builder: (context, _) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed:
                                    viewModel.loginCommand.isRunning
                                        ? null
                                        : () {
                                          if (validator
                                              .validate(credentials)
                                              .isValid) {
                                            viewModel.loginCommand.execute(
                                              credentials,
                                            );
                                          }
                                        },
                                icon: const Icon(Icons.login),
                                label: const Text('Entrar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 26),
                        if (PWAInstall().installPromptEnabled)
                          TextButton(
                            onPressed: () {
                              try {
                                PWAInstall().promptInstall_();
                              } catch (e) {
                                setState(() {
                                  _errorMessage =
                                      e.toString(); // Usa a variável de estado
                                });
                              }
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Instale já seu aplicativo!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.download, color: Colors.white),
                              ],
                            ),
                          ),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        // Exibe o erro
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Este não é um site oficial da UFRRJ. Este aplicativo faz parte de um projeto final de curso independente desenvolvido por aluno.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "© 2025 CapyCar. Todos os direitos reservados.",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.85),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
