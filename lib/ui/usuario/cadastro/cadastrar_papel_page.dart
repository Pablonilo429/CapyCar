import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/usuario/cadastro/cadastrar_papel_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class CadastrarPapelPage extends StatefulWidget {
  const CadastrarPapelPage({super.key});

  @override
  State<CadastrarPapelPage> createState() => _CadastrarPapelPageState();
}

class _CadastrarPapelPageState extends State<CadastrarPapelPage> {
  String? papelSelecionado;

  final viewModel = injector.get<CadastrarPapelViewModel>();

  void _selecionarPapel(String papel) {
    setState(() {
      papelSelecionado = papel;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.setPapelCommand.addListener(_listenable);
  }

  void _listenable() {
    if (viewModel.setPapelCommand.isSuccess) {
      Routefly.navigate(routePaths.mensagem);
    }
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Você será passageiro ou motorista?',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              'Obs: motorista também pode viajar como passageiro',
              style: TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Opções Passageiro e Motorista
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _papelCard(
                  'Passageiro',
                  'https://res.cloudinary.com/ddemkhgt4/image/upload/v1746151994/logo_capy_car_passageiro.webp',
                ),
                const SizedBox(width: 24),
                _papelCard(
                  'Motorista',
                  'https://res.cloudinary.com/ddemkhgt4/image/upload/v1746151975/logo_capy_car.png',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _papelCard(String papel, String imagePath) {
    final isSelecionado = papelSelecionado == papel;

    return GestureDetector(
      onTap:
          () =>
              papel == "Motorista"
                  ? Routefly.navigate(
                    routePaths.usuario.cadastro.cadastrarCarro,
                  )
                  : viewModel.setPapelCommand.execute(),
      // onTap: () => _selecionarPapel(papel),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  isSelecionado
                      ? Border.all(color: Colors.white, width: 4)
                      : null,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(imagePath),
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            papel,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
