import 'package:capy_car/main.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definindo o estilo de texto padrão para os parágrafos para reutilização
    const paragraphStyle = TextStyle(
      fontSize: 16.0,
      height: 1.5, // Espaçamento entre linhas para melhor legibilidade
      color: Colors.white,
    );

    // Definindo o estilo de texto para os títulos das seções
    final titleStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      height: 2.0,
    );

    return Scaffold(
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
                "Sobre",
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
      body: Container(
        // Gradiente de fundo para manter a consistência visual
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1974BF), Color(0xFF2B7422)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // SingleChildScrollView garante que o conteúdo seja rolável em telas menores
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -- Cabeçalho da Página --
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 60,
                        color: Colors.green[700],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Projeto Capycar',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // -- Seção sobre o projeto --
                Text('O Projeto', style: titleStyle),
                const Text(
                  'O Capycar nasceu com a proposta de tornar o agendamento de caronas na UFRRJ uma tarefa mais simples, eficiente e organizada. O objetivo é fornecer uma plataforma centralizada com mais informações e segurança para os usuários.',
                  style: paragraphStyle,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),

                // -- Seção sobre o MVP e o autor --
                Text('Versão Inicial (MVP)', style: titleStyle),
                Text.rich(
                  TextSpan(
                    style: paragraphStyle,
                    children: [
                      const TextSpan(
                        text: 'Esta primeira versão do aplicativo é um ',
                      ),
                      TextSpan(
                        text: 'MVP (Mínimo Produto Viável)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white38,
                        ),
                      ),
                      const TextSpan(
                        text: ', resultado do projeto final de curso do aluno ',
                      ),
                      TextSpan(
                        text: 'Pablo de Oliveira Araujo Xavier',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white38,
                        ),
                      ),
                      const TextSpan(
                        text: ', do curso de Sistemas de Informação da UFRRJ.',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),

                // -- Seção sobre colaboração --
                Text('Código Aberto e Colaboração', style: titleStyle),
                const Text(
                  'Este é um projeto de código aberto! Sinta-se à vontade para colaborar com novas funcionalidades, reportar bugs ou dar sugestões. Toda ajuda é bem-vinda para tornar o Capycar ainda melhor.',
                  style: paragraphStyle,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),

                // -- Seção sobre uso e licença --
                Text('Uso e Licença', style: titleStyle),
                const Text(
                  'Você tem a liberdade de utilizar o código para desenvolver uma solução de caronas para a sua própria instituição. O uso para fins educacionais e não comerciais é totalmente livre. Caso haja interesse em monetizar qualquer aplicação derivada deste repositório, por favor, entre em contato para discutirmos os termos.',
                  style: paragraphStyle,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 30),

                // -- Rodapé --
                Center(
                  child: Text(
                    'Agradecemos por usar o Capycar!',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
