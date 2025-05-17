import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/dtos/credentials_login.dart';
import 'package:capy_car/domain/validators/credentials_login_validator.dart';
import 'package:capy_car/ui/auth/login/login_viewmodel.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

    viewModel.loginCommand.addListener(_listenable);
  }

  void _listenable(){
    if (viewModel.loginCommand.isFailure){
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage("https://res.cloudinary.com/ddemkhgt4/image/upload/v1746151975/logo_capy_car.png"), // substitua pela imagem correta
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                onChanged: credentials.setPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validator.byField(credentials, "password"),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'senha',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Routefly.navigate('/auth/registrar'),
                    child: const Text(
                      'Registre-se',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Routefly.navigate('senha/esqueci_senha'),
                    child: const Text(
                      'Esqueci a minha senha',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              ListenableBuilder(
                listenable: viewModel.loginCommand,
                builder: (context, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: viewModel.loginCommand.isRunning ? null : () {
                        if(validator.validate(credentials).isValid){
                          viewModel.loginCommand.execute(credentials);
                        }
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Entrar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
