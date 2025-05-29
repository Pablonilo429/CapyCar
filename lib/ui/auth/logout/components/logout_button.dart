import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/auth/logout/logout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';


class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  final viewModel = injector.get<LogoutViewModel>();


  @override
  void initState() {
    super.initState();
    viewModel.logoutCommand.addListener(_listenable);
  }

  void _listenable(){
    if(viewModel.logoutCommand.isSuccess){
      Routefly.navigate(routePaths.auth.login);
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: viewModel.logoutCommand.execute,
      leading: const Icon(Icons.logout, color: Colors.red,),
      title: const Text('Sair', style: TextStyle(color: Colors.red,),),
    );
  }
}
