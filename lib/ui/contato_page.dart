import 'package:capy_car/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:routefly/routefly.dart';
import 'package:url_launcher/url_launcher.dart';

// Classe da página de contatos
class ContatoPage extends StatefulWidget {
  const ContatoPage({super.key});

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  /// Função assíncrona para abrir uma URL.
  /// Utiliza o pacote url_launcher para abrir links externos.
  /// Exibe um SnackBar em caso de erro.
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Exibe uma mensagem de erro se não for possível abrir a URL
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi possível abrir o link: $urlString'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define as informações de contato em uma lista para fácil manutenção
    final List<Map<String, dynamic>> contatos = [
      {
        'icon': FontAwesomeIcons.instagram,
        'title': 'Instagram',
        'subtitle': '@capycarrural',
        'url': 'https://www.instagram.com/capycarrural?utm_source=ig_web_button_share_sheet&igsh=MWh0cTRlMHkwcnhscw==',
        'color': Colors.pink,
      },
      {
        'icon': FontAwesomeIcons.github,
        'title': 'GitHub',
        'subtitle': 'Pablonilo429',
        'url': 'https://github.com/Pablonilo429',
        'color': Colors.black87,
      },
      {
        'icon': Icons.email_outlined,
        'title': 'Email',
        'subtitle': 'pabloliv429@ufrrj.br',
        'url': 'mailto:pabloliv429@ufrrj.br',
        'color': Colors.teal,
      },
    ];

    return Scaffold(
      // Barra superior do aplicativo
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              iconSize: 30.0,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Routefly.navigate(routePaths.carona.caronaHome);
              },
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Contato",
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      // Corpo da página
      body: Container(
        // Adiciona um gradiente ao fundo para um visual mais moderno
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1974BF), Color(0xFF2B7422)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // Centraliza o conteúdo e adiciona preenchimento
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Adiciona um ícone de avatar no topo
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.support_agent,
                    size: 60,
                    color: Color(0xFF388E3C),
                  ),
                ),
                const SizedBox(height: 16),
                // Título da seção
                const Text(
                  'Nossas Redes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Descrição
                const Text(
                  'Clique em um dos cards abaixo para nos contatar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 24),
                // Gera a lista de contatos a partir da lista 'contatos'
                ListView.builder(
                  shrinkWrap: true,
                  // Garante que a lista ocupe apenas o espaço necessário
                  physics: const NeverScrollableScrollPhysics(),
                  // Desabilita a rolagem da lista interna
                  itemCount: contatos.length,
                  itemBuilder: (context, index) {
                    final contato = contatos[index];
                    return _buildContactCard(
                      icon: contato['icon'],
                      title: contato['title'],
                      subtitle: contato['subtitle'],
                      url: contato['url'],
                      color: contato['color'],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget auxiliar para construir cada card de contato.
  /// Isso mantém o código do método build mais limpo e organizado.
  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String url,
    required Color color,
  }) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Ícone do contato
              Icon(icon, color: color, size: 30),
              const SizedBox(width: 20),
              // Coluna com o título e subtítulo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              // Ícone de seta para indicar clicabilidade
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
