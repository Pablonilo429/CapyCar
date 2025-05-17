import 'package:capy_car/ui/auth/logout/components/logout_button.dart';
import 'package:flutter/material.dart';

class CaronaHomePage extends StatefulWidget {
  const CaronaHomePage({super.key});

  @override
  State<CaronaHomePage> createState() => _CaronaHomePageState();
}

class _CaronaHomePageState extends State<CaronaHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LogoutButton(),
      ),
    );
  }
}
