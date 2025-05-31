import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';
import 'package:capy_car/ui/components/whatsapp_button.dart';
// import 'package:capy_car/ui/usuario/usuario_viewmodel.dart'; // Não utilizado no snippet fornecido
import 'package:flutter/material.dart';
// import 'package:result_command/result_command.dart'; // Não utilizado no snippet fornecido
// import 'package:result_dart/result_dart.dart'; // Não utilizado no snippet fornecido

class UsuarioModal extends StatefulWidget {
  final Usuario user;

  const UsuarioModal({super.key, required this.user});

  @override
  State<UsuarioModal> createState() => _UsuarioModalState();
}

class _UsuarioModalState extends State<UsuarioModal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Cor de fundo do Dialog (branco como na imagem)
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Bordas levemente arredondadas
      child: _buildProfileContent(widget.user),
    );
  }

  Widget _buildProfileContent(Usuario user) {
    // Definindo as cores da imagem para fácil referência
    const Color textColor = Color(0xFF333333); // Cor de texto escura (preto/cinza escuro)
    const Color fieldBackgroundColor = Color(0xFFF0F4F8); // Azul bem claro para o fundo dos campos
    const Color iconCloseColor = Color(0xFF555555); // Cor para o ícone de fechar

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350), // Largura máxima um pouco menor
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.8, // Pode ser removido ou ajustado
          padding: const EdgeInsets.all(24.0), // Aumentar o padding geral
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: iconCloseColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  tooltip: 'Fechar',
                ),
              ),
              const SizedBox(height: 8), // Espaço após o botão de fechar
              CircleAvatar(
                radius: 50, // Avatar um pouco maior
                backgroundImage:
                (user.fotoPerfilUrl != null && user.fotoPerfilUrl!.isNotEmpty)
                    ? NetworkImage(user.fotoPerfilUrl!)
                    : const AssetImage('assets/logo/passageiro_placeholder.png') as ImageProvider, // Placeholder
                backgroundColor: Colors.grey[300], // Cor de fundo se a imagem falhar
                onBackgroundImageError: (_, __) {
                  if (mounted) setState(() {});
                },
                child: (user.fotoPerfilUrl == null || user.fotoPerfilUrl!.isEmpty)
                    ? Icon(Icons.person, size: 50, color: Colors.grey[600]) // Ícone de fallback
                    : null,
              ),
              const SizedBox(height: 20), // Espaço maior após o avatar
              Text(
                // Lógica para nome: usar nomeSocial se disponível e não vazio, senão nome completo
                user.nomeSocial?.isNotEmpty ?? false ? user.nomeSocial! : user.nome,
                style: const TextStyle(
                  fontSize: 20, // Tamanho da fonte do nome
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24), // Espaço maior antes dos campos de informação
              _buildInfoField(
                label: 'Email:',
                value: user.emailInstitucional ?? 'N/A',
                backgroundColor: fieldBackgroundColor,
                textColor: textColor,
              ),
              const SizedBox(height: 12), // Espaço entre os campos
              _buildInfoField(
                label: 'Telefone:',
                value: user.numeroCelular ?? 'N/A',
                backgroundColor: fieldBackgroundColor,
                textColor: textColor,
              ),
              BotaoWhatsapp(),
              const SizedBox(height: 16), // Espaço no final do modal
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para criar os campos de informação (Email, Telefone)
  Widget _buildInfoField({
    required String label,
    required String value,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8), // Bordas arredondadas para os campos
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 15, color: textColor), // Estilo padrão do texto
          children: <TextSpan>[
            TextSpan(text: '$label '),
            TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.normal)), // Valor sem negrito
          ],
        ),
      ),
    );
  }
}