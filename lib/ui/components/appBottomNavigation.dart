import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/components/appBottomNavigation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class AppBottomNavigation extends StatefulWidget {
  final int index;

  const AppBottomNavigation({super.key, required this.index});

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  final viewModel = injector.get<AppBottomNavigationViewModel>();

  @override
  void initState() {
    viewModel.usuario;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.index,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_car),
          label: 'Viagens',
        ),

        if (viewModel.usuario!.isMotorista)
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Oferecer Viagem',
          ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Sua Carona'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Routefly.navigate(routePaths.carona.caronaHome);
          case 1:
            if (viewModel.usuario!.isMotorista) {
              Routefly.navigate(routePaths.carona.cadastro.cadastrarCarona);
            }
          case 2:
            {
              Routefly.navigate(routePaths.carona.visualizar.caronasUsuario);
            }
        }
      },
    );
  }
}
