import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/auth/logout/components/logout_button.dart';
import 'package:capy_car/ui/components/appDrawer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}


class _AppDrawerState extends State<AppDrawer> {

  final viewModel = injector.get<AppDrawerViewModel>();

  @override
  void initState() {
    viewModel.usuario;
    super.initState();
  }

  // @override
  // void dispose() {
  //   viewModel.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFF5EDEF), // cor de fundo lilás claro
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF5BB0F8), // azul do cabeçalho
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  viewModel.usuario!.fotoPerfilUrl != null ?
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                        viewModel.usuario!.fotoPerfilUrl!),
                  ) :
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: viewModel.usuario!.isMotorista
                        ? const AssetImage('assets/logo/motorista.png')
                        : const AssetImage('assets/logo/passageiro.png'),
                  )
                  ,
                  const SizedBox(height: 8),
                  Text(
                    '${viewModel.usuario!.nomeSocial ?? viewModel.usuario!.nome} - Campus ${viewModel.usuario!.campus}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildItem(
                    context,
                    icon: Icons.edit,
                    text: 'Editar Perfil',
                    onTap: () {
                      Routefly.navigate(routePaths.usuario.editar.editarPerfil);
                    },
                  ),
                  _buildItem(
                    context,
                    icon: Icons.directions_car,
                    text: 'Cadastrar/Editar Carro',
                    onTap: () {
                      Routefly.navigate(routePaths.usuario.editar.editarCarro);
                    },
                  ),
                  _buildItem(
                    context,
                    icon: Icons.list_alt,
                    text: 'Listar suas viagens',
                    onTap: () {
                      Routefly.navigate(routePaths.carona.visualizar.caronaAnterior);
                    },
                  ),
                  _buildItem(
                    context,
                    icon: Icons.location_on,
                    text: 'Cadastrar/Editar Rotas',
                    onTap: () {
                      Routefly.navigate(routePaths.rota);
                    },
                  ),
                  _buildItem(
                    context,
                    icon: Icons.drive_eta,
                    text: 'Tornar-se motorista',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Divider(),
            LogoutButton()
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(text, style: const TextStyle(color: Colors.black87)),
      onTap: onTap,
    );
  }
}

