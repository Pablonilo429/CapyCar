import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Opcional: Se quiser usar um ícone específico do WhatsApp,
// você pode precisar de um pacote de ícones como 'font_awesome_flutter'
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BotaoWhatsapp extends StatelessWidget {
  const BotaoWhatsapp({super.key});

  // Seu link do WhatsApp
  final String numeroWhatsapp =
      "5521990040336"; // Apenas o número com código do país e DDD
  final String mensagemOpcional =
      ""; // Você pode adicionar uma mensagem pré-definida aqui

  Future<void> _abrirWhatsapp(BuildContext context) async {
    // Monta o link do wa.me
    // Se quiser adicionar uma mensagem: "&text=${Uri.encodeComponent(mensagemOpcional)}"
    final Uri urlWhatsapp = Uri.parse("https://wa.me/$numeroWhatsapp");

    // Tenta abrir a URL
    // launchUrl retorna um Future<bool> indicando se foi bem-sucedido.
    // mode: LaunchMode.externalApplication tenta abrir fora do app (no navegador ou app do WhatsApp).
    if (!await launchUrl(urlWhatsapp, mode: LaunchMode.externalApplication)) {
      // Se não conseguir abrir, mostra uma mensagem de erro (opcional)
      if (context.mounted) {
        // Verifica se o widget ainda está na árvore
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível abrir o WhatsApp. Verifique se está instalado ou se há um navegador disponível.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      // Você também pode lançar uma exceção se preferir tratar o erro de outra forma
      // throw 'Não foi possível abrir $urlWhatsapp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // Ícone:
      // Opção 1: Ícone genérico de chat do Material Design
      // icon: const Icon(Icons.chat_bubble_outline),
      // Opção 2: Usar um ícone do FontAwesome (requer o pacote font_awesome_flutter)
        icon: FaIcon(FontAwesomeIcons.whatsapp),
      // Opção 3: Usar um ImageIcon se você tiver um asset do logo do WhatsApp
      // icon: ImageIcon(AssetImage('assets/icons/whatsapp_logo.png')),

      // Estilização do ícone (opcional)
      color: Colors.green,
      // Cor típica do WhatsApp
      iconSize: 30.0,

      // Tamanho do ícone
      tooltip: 'Abrir conversa no WhatsApp',
      // Texto que aparece ao segurar o botão

      // Ação ao pressionar
      onPressed: () => _abrirWhatsapp(context),
    );
  }
}
