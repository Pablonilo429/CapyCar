import 'package:flutter/material.dart';


class AppColors {
  static const Color primary = Color(0xFF5DB6F0); // azul médio
  static const Color onPrimary = Color(0xFFFFFFFF); // texto em cima do primary
  static const Color primaryContainer = Color(
    0xFFD6ECFA,
  ); // azul claro (container/nav bar)
  static const Color onPrimaryContainer = Color(
    0xFF0D47A1,
  ); // texto sobre primaryContainer

  static const Color secondary = Color(0xFFE3F2FD); // azul muito claro (cards)
  static const Color onSecondary = Color(0xFF212121); // texto sobre secondary

  static const Color background = Color(0xFFFFFFFF); // fundo da tela
  static const Color onBackground = Color(0xFF212121); // texto principal

  static const Color surface = Color(0xFFFFFFFF); // superfície de componentes
  static const Color onSurface = Color(0xFF212121); // texto em cards/botões/etc

  static const Color outline = Color(0xFFE0E0E0); // bordas (chips, campos)
  static const Color shadow = Color(0x40000000); // sombra leve
}

final ColorScheme colorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primaryContainer,
  onPrimaryContainer: AppColors.onPrimaryContainer,
  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  background: AppColors.background,
  onBackground: AppColors.onBackground,
  surface: AppColors.surface,
  onSurface: AppColors.onSurface,
  error: Colors.red,
  onError: Colors.white,
);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  scaffoldBackgroundColor: colorScheme.background,
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.primary,
    elevation: 0,
    iconTheme: IconThemeData(color: colorScheme.onPrimary),
    titleTextStyle: TextStyle(
      color: colorScheme.onPrimary,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: colorScheme.onBackground),
    bodyMedium: TextStyle(color: AppColors.onSecondary),
  ),
  iconTheme: IconThemeData(color: colorScheme.onBackground),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: colorScheme.primaryContainer,
    selectedItemColor: colorScheme.primary,
    unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: colorScheme.surface,
    labelStyle: TextStyle(color: colorScheme.onSurface),
    shape: StadiumBorder(side: BorderSide(color: AppColors.outline)),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      return states.contains(MaterialState.selected)
          ? colorScheme.primary
          : AppColors.outline;
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      return states.contains(MaterialState.selected)
          ? colorScheme.primary.withOpacity(0.5)
          : AppColors.outline.withOpacity(0.4);
    }),
  ),
  cardColor: colorScheme.secondary,
);
