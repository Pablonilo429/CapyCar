import 'dart:async';

import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/main_viewmodel.dart';
import 'package:capy_car/utils/LoaderWidget.dart';
import 'package:capy_car/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
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

    // Aguarda o primeiro valor do usuário
    await mainViewModel.onUsuarioReady;

    final usuario = mainViewModel.usuario;
    final bool isLoggedIn = usuario != null;

    const String pathLogin = '/auth/login'; // Ex: routePaths.auth.login
    const String pathHome =
        '/carona/carona_home'; // Ex: routePaths.carona.caronaHome
    const String pathCadastrarLocalizacao =
        '/usuario/cadastro/cadastrar_localizacao'; // Ex: routePaths.usuario.cadastro.cadastrarLocalizacao
    const String pathCadastrarPapel =
        '/usuario/cadastro/cadastrar_papel'; // Ex: routePaths.usuario.cadastro.cadastrarPapel

    final List<String> publicAuthPaths = [
      pathLogin,
      '/auth/registrar',
      '/auth/senha/esqueci_senha',
      '/auth/registrar/final_registrar',
    ];

    final List<String> firstLoginSetupPaths = [
      pathCadastrarLocalizacao,
      pathCadastrarPapel,
    ];

    final bool isTargetingPublicAuthPath = publicAuthPaths.contains(
      currentPath,
    );
    final bool isTargetingFirstLoginSetupPath = firstLoginSetupPaths.contains(
      currentPath,
    );

    // Logs para depuração (remova ou use um logger em produção)
    print('[AuthGuard] Current Path: $currentPath, IsLoggedIn: $isLoggedIn');
    if (isLoggedIn) {
      print(
        '[AuthGuard] User: ${mainViewModel.usuario}, IsPrimeiroLogin: ${mainViewModel.usuario?.isPrimeiroLogin}, Campus: ${mainViewModel.usuario?.campus}',
      );
    }

    if (isLoggedIn) {
      // Assumindo que mainViewModel.usuario não é nulo aqui devido a `isLoggedIn`
      final usuario = mainViewModel.usuario!;
      final bool isPrimeiroLogin = usuario.isPrimeiroLogin == true;

      if (isPrimeiroLogin) {
        final bool campusInfoMissing =
            usuario.campus == null || usuario.campus!.isEmpty;

        if (campusInfoMissing) {
          // Usuário precisa preencher a localização
          if (currentPath == pathCadastrarLocalizacao) {
            print(
              '[AuthGuard] LoggedIn/PrimeiroLogin/CampusMissing. Permitindo em $pathCadastrarLocalizacao',
            );
            return routeInfo; // Permite, pois já está na página correta
          } else {
            print(
              '[AuthGuard] LoggedIn/PrimeiroLogin/CampusMissing. Redirecionando para $pathCadastrarLocalizacao de $currentPath',
            );
            return routeInfo.redirect(Uri.parse(pathCadastrarLocalizacao));
          }
        } else {
          // Informações do campus estão presentes
          // Usuário precisa preencher o papel
          if (currentPath == pathCadastrarPapel) {
            print(
              '[AuthGuard] LoggedIn/PrimeiroLogin/CampusOK. Permitindo em $pathCadastrarPapel',
            );
            return routeInfo; // Permite, pois já está na página correta
          } else {
            // Se o usuário está no fluxo de primeiro login, com campus preenchido,
            // mas não está na página de cadastrar papel, redirecione-o para lá.
            // Isso evita que ele acesse outras páginas (como home ou auth) durante este estágio.
            print(
              '[AuthGuard] LoggedIn/PrimeiroLogin/CampusOK. Redirecionando para $pathCadastrarPapel de $currentPath',
            );
            return routeInfo.redirect(Uri.parse(pathCadastrarPapel));
          }
        }
      } else {
        // isPrimeiroLogin é false (Cadastro completo)
        // Se logado e cadastro completo, e tentando acessar páginas de autenticação -> redireciona para home
        if (isTargetingPublicAuthPath) {
          print(
            '[AuthGuard] LoggedIn/SetupComplete. Redirecionando de PublicAuthPath ($currentPath) para $pathHome',
          );
          return routeInfo.redirect(Uri.parse(pathHome));
        }
        // Se logado e cadastro completo, e tentando acessar páginas de configuração de primeiro login -> redireciona para home
        if (isTargetingFirstLoginSetupPath) {
          print(
            '[AuthGuard] LoggedIn/SetupComplete. Redirecionando de FirstLoginSetupPath ($currentPath) para $pathHome',
          );
          return routeInfo.redirect(Uri.parse(pathHome));
        }
      }

      // Se logado, e não caiu em nenhuma das condições de redirecionamento acima
      // (ou seja, isPrimeiroLogin=false e não está acessando auth/setup paths, ou está na página correta do fluxo de primeiro login)
      print('[AuthGuard] LoggedIn. Permitindo navegação para $currentPath');
      return routeInfo;
    } else {
      // Não está logado
      if (isTargetingPublicAuthPath) {
        // Se não logado e tentando acessar uma página pública de autenticação, permite.
        print(
          '[AuthGuard] NotLoggedIn. Permitindo navegação para PublicAuthPath ($currentPath)',
        );
        return routeInfo;
      } else {
        // Se não logado e tentando acessar qualquer outra página (protegida), redireciona para login.
        print(
          '[AuthGuard] NotLoggedIn. Redirecionando de ProtectedPath ($currentPath) para $pathLogin',
        );
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
