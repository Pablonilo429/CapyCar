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

  Future<void> _showBecomeDriverModal(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Permite fechar clicando fora do modal
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Deseja se tornar um motorista?',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 20.0),
          actions: <Widget>[
            // Botão X no canto superior direito (opcional, pois barrierDismissible já existe)
            // Positioned( // Para posicionar o X, precisaríamos de um Stack no builder do AlertDialog ou um Dialog customizado
            //   right: 0.0,
            //   top: 0.0,
            //   child: IconButton(
            //     icon: Icon(Icons.close),
            //     onPressed: () {
            //       Navigator.of(dialogContext).pop();
            //     },
            //   ),
            // ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fecha o modal
              },
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5BB0F8),
                // Azul similar ao header
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
              ),
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fecha o modal
                Routefly.navigate(routePaths.usuario.cadastro.cadastrarCarro);
              },
            ),
          ],
        );
      },
    );
  }

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
                  viewModel.usuario!.fotoPerfilUrl.isNotEmpty
                      ? CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                          viewModel.usuario!.fotoPerfilUrl,
                        ),
                      )
                      : CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            viewModel.usuario!.isMotorista
                                ? const AssetImage('assets/logo/motorista.png')
                                : const AssetImage(
                                  'assets/logo/passageiro.png',
                                ),
                      ),
                  const SizedBox(height: 8),
                  Text(
                    '${viewModel.usuario!.nomeSocial?.isEmpty ?? true ? viewModel.usuario!.nome : viewModel.usuario!.nomeSocial} - Campus ${viewModel.usuario!.campus}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildItem(
                    context,
                    icon: Icons.hail,
                    text: 'Caronas',
                    onTap: () {
                      Routefly.navigate(routePaths.carona.caronaHome);
                    },
                  ),
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
                    icon: Icons.list_alt,
                    text: 'Listar suas viagens',
                    onTap: () {
                      Routefly.navigate(
                        routePaths.carona.visualizar.caronaAnterior,
                      );
                    },
                  ),
                  if (viewModel.usuario!.isMotorista)
                    _buildItem(
                      context,
                      icon: Icons.directions_car,
                      text: 'Editar Carro',
                      onTap: () {
                        Routefly.navigate(
                          routePaths.usuario.editar.editarCarro,
                        );
                      },
                    ),
                  if (viewModel.usuario!.isMotorista)
                    _buildItem(
                      context,
                      icon: Icons.location_on,
                      text: 'Cadastrar/Editar Rotas',
                      onTap: () {
                        Routefly.navigate(routePaths.rota);
                      },
                    ),
                  if (!viewModel.usuario!.isMotorista)
                    _buildItem(
                      context,
                      icon: Icons.drive_eta,
                      text: 'Tornar-se motorista',
                      onTap: () {
                        _showBecomeDriverModal(context);
                      },
                    ),
                ],
              ),
            ),
            const Divider(),
            LogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
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
