import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final viewModel = injector.get<MainViewModel>();

    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final usuario = viewModel.usuario;

        final currentPath = Routefly.currentOriginalPath; // pega a rota atual

        // Rotas livres (sem login)
        const rotasPublicas = [
          '/auth/login',
          '/auth/registrar',
          '/sobre',
          '/contato',
          'auth/registrar/final_registrar'
        ];

        final isRotaPublica = rotasPublicas.contains(currentPath);

        // Se o usuário não estiver logado E tentar acessar rota protegida:
        if (usuario == null && !isRotaPublica) {
          Future.microtask(() => Routefly.navigate(routePaths.auth.login));
          return const SizedBox.shrink(); // evita piscar a UI
        }

        // Se o usuário estiver logado e tentar acessar login/register:
        if (usuario != null && isRotaPublica) {
          Future.microtask(() => Routefly.navigate(routePaths.carona.caronaHome));
          return const SizedBox.shrink();
        }

        return child;
      },
    );
  }
}
