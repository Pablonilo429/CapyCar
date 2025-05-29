import 'package:flutter/material.dart';

class FinalRegistrarPage extends StatefulWidget {
  const FinalRegistrarPage({super.key});

  @override
  State<FinalRegistrarPage> createState() => _FinalRegistrarPageState();
}

class _FinalRegistrarPageState extends State<FinalRegistrarPage> {
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
                  radius: 80,
                  backgroundImage: AssetImage('assets/logo/motorista.png'),
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
                  onPressed: () => {},
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                  style: _botaoEstilo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final _botaoEstilo = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  );
}
