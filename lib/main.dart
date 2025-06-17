import 'dart:async';

import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/main_viewmodel.dart';
import 'package:capy_car/utils/LoaderWidget.dart';
import 'package:capy_car/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lucid_validation/lucid_validation.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:routefly/routefly.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

import 'main.route.dart';

part 'main.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupDependecies();
  PWAInstall().setup(
    installCallback: () {
      debugPrint('APP INSTALLED!');
    },
  );
  runApp(const MainApp());
}

@Main('lib/ui/')
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // This widget is the root of your application.

  final mainViewModel = injector.get<MainViewModel>();

  @override
  void initState() {
    super.initState();

    // mainViewModel.addListener(() {
    //   if (mainViewModel.usuario?.campus == null ||
    //       mainViewModel.usuario?.campus == '' &&
    //           mainViewModel.usuario?.isPrimeiroLogin == true) {
    //     Routefly.navigate(routePaths.usuario.cadastro.cadastrarLocalizacao);
    //   } else if (mainViewModel.usuario?.isPrimeiroLogin == true) {
    //     Routefly.navigate(routePaths.usuario.cadastro.cadastrarPapel);
    //   } else {
    //     Routefly.navigate(routePaths.carona.caronaHome);
    //   }
    // });
  }

  FutureOr<RouteInformation> authMiddleware(RouteInformation routeInfo) async {
    final String currentPath = routeInfo.uri.path;
    final mainViewModel = injector.get<MainViewModel>();

    // Aguarda a inicialização do usuário na ViewModel
    await mainViewModel.onUsuarioReady;

    final usuario = mainViewModel.usuario;
    final bool isLoggedIn = usuario != null;

    // --- Rotas da Aplicação ---
    const String pathLogin = '/auth/login';
    const String pathHome = '/carona/carona_home';
    const String pathCadastrarLocalizacao = '/usuario/cadastro/cadastrar_localizacao';
    const String pathCadastrarPapel = '/usuario/cadastro/cadastrar_papel';

    // --- Listas de Rotas para Verificação ---

    // Páginas que podem ser acessadas a qualquer momento, logado ou não.
    const List<String> alwaysAccessiblePaths = [
      '/sobre',
      '/contato',
    ];

    // Páginas públicas que um usuário logado não deve acessar.
    final List<String> publicAuthPaths = [
      pathLogin,
      '/auth/registrar',
      '/auth/senha/esqueci_senha',
      '/auth/registrar/final_registrar',
    ];

    // Páginas do fluxo de primeiro login.
    final List<String> firstLoginSetupPaths = [
      pathCadastrarLocalizacao,
      pathCadastrarPapel,
    ];

    // --- Lógica do Middleware ---

    // 1. Verifica se a rota é sempre acessível
    if (alwaysAccessiblePaths.contains(currentPath)) {
      return routeInfo; // Permite o acesso imediato
    }


    final bool isTargetingPublicAuthPath = publicAuthPaths.contains(currentPath);
    final bool isTargetingFirstLoginSetupPath = firstLoginSetupPaths.contains(currentPath);

    // Logs para depuração

    // 2. Lógica para usuários LOGADOS
    if (isLoggedIn) {
      final bool isPrimeiroLogin = usuario!.isPrimeiroLogin == true;

      // 2a. Fluxo de primeiro login
      if (isPrimeiroLogin) {
        final bool campusInfoMissing = usuario.campus == null || usuario.campus!.isEmpty;

        if (campusInfoMissing) {
          // Precisa preencher a localização
          if (currentPath != pathCadastrarLocalizacao) {
            return routeInfo.redirect(Uri.parse(pathCadastrarLocalizacao));
          }
        } else {
          // Precisa preencher o papel
          if (currentPath != pathCadastrarPapel) {
            return routeInfo.redirect(Uri.parse(pathCadastrarPapel));
          }
        }
      } else {
        // 2b. Usuário com cadastro completo
        // Redireciona se tentar acessar páginas de autenticação ou de setup
        if (isTargetingPublicAuthPath || isTargetingFirstLoginSetupPath) {
          return routeInfo.redirect(Uri.parse(pathHome));
        }
      }

      // Se chegou até aqui, o usuário está logado e pode acessar a rota
      return routeInfo;

    } else {
      // 3. Lógica para usuários DESLOGADOS
      // Permite acesso apenas às rotas públicas de autenticação
      if (isTargetingPublicAuthPath) {
        return routeInfo;
      } else {
        // Redireciona para o login se tentar acessar qualquer outra página
        return routeInfo.redirect(Uri.parse(pathLogin));
      }
    }
  }

  @override
  void dispose() {
    mainViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LucidValidation.global.culture = Culture('pt', 'BR');

    return FutureBuilder(
      future: mainViewModel.onUsuarioReady,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            locale: const Locale('pt', 'BR'), // <- forçando o locale
            supportedLocales: const [Locale('pt', 'BR')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(body: Center(child: LoaderWidget())),
          );
        }

        return MaterialApp.router(
          title: "CapyCar",
          locale: const Locale('pt', 'BR'),
          // <- forçando o locale
          theme: appTheme,
          routerConfig: Routefly.routerConfig(
            middlewares: [authMiddleware],
            routes: routes,
            initialPath: routePaths.auth.login,
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR')],
        );
      },
    );
  }
}
