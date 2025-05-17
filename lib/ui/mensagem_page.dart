import 'package:capy_car/main.dart';
import 'package:capy_car/ui/usuario/cadastro/components/mensagem.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class MensagemPage extends StatelessWidget {
  const MensagemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MensagemComponent(
        onFinished: () => Routefly.navigate(routePaths.carona.caronaHome)
      ),
    );
  }
}
