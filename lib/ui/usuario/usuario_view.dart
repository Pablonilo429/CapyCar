import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:capy_car/ui/usuario/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class UsuarioModal extends StatefulWidget {
  final String userId;

  const UsuarioModal({super.key, required this.userId});

  @override
  State<UsuarioModal> createState() => _UsuarioModalState();
}

class _UsuarioModalState extends State<UsuarioModal> {
  late final UsuarioViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = injector.get<UsuarioViewModel>();
    _viewModel.getUsuarioDataCommand.execute(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF242830),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ValueListenableBuilder<CommandState<Usuario>>(
        valueListenable: _viewModel.getUsuarioDataCommand,
        builder: (context, state, _) {
          if (state is RunningCommand<Usuario>) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FailureCommand<Usuario>) {
            return Center(
              child: Text(
                'Erro ao carregar usuário: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is SuccessCommand<Usuario>) {
            final user = state.value;
            return _buildProfileContent(user);
          } else {
            return const SizedBox.shrink(); // Estado Idle ou desconhecido
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(Usuario user) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.close, color: Colors.black),
              ),
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.fotoPerfilUrl ?? ''),
                backgroundColor: Colors.transparent,
                onBackgroundImageError: (_, __) {},
                child: user.fotoPerfilUrl == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user.nomeSocial ?? user.nome,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Email: ${user.emailInstitucional ?? 'N/A'}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Telefone: ${user.numeroCelular ?? 'N/A'}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
