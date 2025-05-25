import 'package:capy_car/config/dependencies.dart'; // Para o injector
import 'package:capy_car/ui/carona/visualizar/%5Bid%5D/carona_view_model.dart';
import 'package:capy_car/ui/components/appBar.dart';
import 'package:capy_car/ui/components/appDrawer.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart'; // Ajuste o caminho
import 'package:capy_car/domain/models/carona/carona.dart'; // Ajuste o caminho
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routefly/routefly.dart';
import 'package:result_command/result_command.dart'; // Para FailureCommand

class CaronaPage extends StatefulWidget {
  const CaronaPage({super.key});

  @override
  State<CaronaPage> createState() => _CaronaPageState();
}

class _CaronaPageState extends State<CaronaPage> {
  final viewModel = injector.get<CaronaViewModel>();
  String? _idCarona;

  @override
  void initState() {
    super.initState();
    // Pegar o ID da carona da rota
    // É importante que Routefly.query esteja disponível síncronamente aqui,
    // ou a lógica de busca precise ser adaptada (ex: usando um FutureBuilder no build).
    // Para este exemplo, assumo que está disponível e é pego antes da primeira build.
    _idCarona = Routefly.query['id'] as String?;

    if (_idCarona != null) {
      // Inicia a busca dos dados da carona
      // O ideal é que o ViewModel tenha um método de inicialização ou
      // que o comando _buscarCaronaCommand seja público para ser executado aqui.
      // Vou assumir que você tornará _buscarCaronaCommand acessível ou terá um método init.
      // Exemplo: viewModel.initCarona(_idCarona!);
      // Ou, se o comando for público: viewModel.buscarCaronaCommand.execute(_idCarona!);
      // Para este exemplo, vou chamar diretamente o método _buscarCarona,
      // mas o ideal é usar o Command.
      // NO SEU CÓDIGO REAL, USE: viewModel.buscarCaronaCommand.execute(_idCarona!);
      // Temporariamente, para o exemplo rodar, vou simular a chamada.
      // No seu ViewModel, o _buscarCaronaCommand já é 'late final', então pode ser acessado.
      // Certifique-se que o comando no seu ViewModel é público (sem o underscore inicial)
      // ou crie um método público que o execute.
      // Ex: no ViewModel: late final buscarCaronaCommand = Command1(_buscarCarona);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_idCarona != null) {
          // Se o comando _buscarCaronaCommand for público (ex: buscarCaronaCommand):
          viewModel.buscarCaronaCommand.execute(_idCarona!);
        }
      });
    } else {
      // Tratar caso o ID não seja encontrado
      debugPrint("ID da carona não encontrado na rota.");
      // Poderia mostrar um SnackBar ou navegar de volta
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Erro: ID da carona não fornecido."),
              backgroundColor: Colors.red,
            ),
          );
          // Navigator.of(context).pop(); // Opcional: voltar se ID não existe
        }
      });
    }

    // Adicionar listener para o comando de cancelar carona
    viewModel.cancelarCaronaCommand.addListener(_listenableCancelarCarona);
    // Adicione listeners para outros comandos se necessário (entrar, sair)
  }

  void _listenableCancelarCarona() {
    if (!mounted) return;

    if (viewModel.cancelarCaronaCommand.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Carona cancelada com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
      // Opcional: navegar para outra tela após cancelamento
      // Routefly.pop(); ou Routefly.navigate(...);
    }

    if (viewModel.cancelarCaronaCommand.isFailure) {
      final error = viewModel.cancelarCaronaCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao cancelar carona: ${error.error.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
    // setState para reconstruir se o estado do botão depender de isRunning,
    // mas o AnimatedBuilder já cuida disso se o comando notificar o ViewModel.
  }

  @override
  void dispose() {
    viewModel.cancelarCaronaCommand.removeListener(_listenableCancelarCarona);
    // Remova outros listeners se adicionados
    // viewModel.dispose(); // Se o ViewModel for gerenciado pelo injector e tiver um ciclo de vida,
    // o injector pode cuidar disso. Se não, e você o criou aqui, chame dispose.
    // No seu exemplo da RotaPage, o dispose do viewModel não é chamado,
    // então vou seguir esse padrão.
    super.dispose();
  }

  // Widget auxiliar para os cards de informação
  Widget _buildInfoCard({
    required String title,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800] // Cor para tema escuro
                : Colors.grey[100], // Cor para tema claro (como na imagem)
        borderRadius: BorderRadius.circular(8.0),
        // Sem sombra na imagem, mas pode ser adicionada se desejar
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.1),
        //     spreadRadius: 1,
        //     blurRadius: 3,
        //     offset: const Offset(0, 1),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17, // Um pouco maior para o título do card
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          // A imagem não mostra um divisor explícito dentro do card, mas sim separação pelo conteúdo
          const SizedBox(height: 8),
          // Espaço entre título e conteúdo
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // O CustomAppBar do seu projeto usa 'greeting' e 'isPop'.
    // A imagem mostra "Sua Carona" como título e um botão de voltar.
    // Assumindo que 'isPop: true' adiciona o botão de voltar.
    // Se 'greeting' for o título, então está correto.
    // Se você tiver um parâmetro 'title' e 'showBackButton', seria mais explícito.
    // Para este exemplo, vou usar 'title' e 'showBackButton' como propriedades hipotéticas
    // do CustomAppBar para maior clareza, mas adapte ao seu CustomAppBar.
    // Se seu CustomAppBar usa 'greeting' para o título e 'isPop' para o botão de voltar:
    // appBar: CustomAppBar(greeting: "Sua Carona", isPop: true),
    return Scaffold(
      appBar: CustomAppBar(
        // title: "Sua Carona", // Se seu AppBar tiver 'title'
        // showBackButton: true, // Se seu AppBar tiver 'showBackButton'
        greeting: "Sua Carona", // Usando os parâmetros que você forneceu
        isPop: true, // Para mostrar o botão de voltar
      ),
      drawer: AppDrawer(),
      body: AnimatedBuilder(
        animation: viewModel, // Escuta o CaronaViewModel
        builder: (context, _) {
          if (viewModel.buscarCaronaCommand.isRunning &&
              viewModel.carona == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.buscarCaronaCommand.isFailure &&
              viewModel.carona == null) {
            final error =
                viewModel.buscarCaronaCommand.value as FailureCommand?;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Erro ao carregar dados da carona: ${error?.error.toString() ?? 'Erro desconhecido.'}\nPor favor, tente novamente.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (viewModel.carona == null) {
            // Pode acontecer se o ID for nulo e a busca não for iniciada,
            // ou se a busca falhou de uma forma não capturada acima.
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Nenhuma informação da carona disponível.\nVerifique o ID fornecido ou tente novamente.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // Se chegou aqui, viewModel.carona não é nulo
          final carona = viewModel.carona!;
          final motorista = viewModel.motorista;
          final passageiros = viewModel.passageiros;
          final usuarioAtual = viewModel.usuario;

          final bool isMotoristaAtual = usuarioAtual?.uId == motorista?.uId;

          final horaChegadaFormatada = DateFormat.Hm().format(
            carona.horarioChegada,
          );
          final horaSaidaFormatada = DateFormat.Hm().format(
            carona.horarioSaidaCarona,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção Motorista
                Text(
                  "Motorista",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          (motorista?.fotoPerfilUrl != null &&
                                  motorista!.fotoPerfilUrl.isNotEmpty)
                              ? NetworkImage(motorista.fotoPerfilUrl)
                              : AssetImage('assets/logo/motorista.png'),
                      child:
                          (motorista!.fotoPerfilUrl.isEmpty)
                              ? const Icon(Icons.person, size: 30)
                              : null,
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        motorista?.nome ?? "Carregando...",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isMotoristaAtual)
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          "Cancelar Carona",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed:
                            viewModel.cancelarCaronaCommand.isRunning
                                ? null
                                : () {
                                  // Adicionar confirmação antes de cancelar
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: const Text("Cancelar Carona"),
                                        content: const Text(
                                          "Tem certeza que deseja cancelar esta carona?",
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("Não"),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Sim, Cancelar"),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                              viewModel.cancelarCaronaCommand
                                                  .execute();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // Seção Caronas (Passageiros)
                Text(
                  "Caronas", // Ou "Passageiros"
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (passageiros.isNotEmpty)
                      Expanded(
                        child: SizedBox(
                          height: 50, // Altura dos avatares
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: passageiros.length,
                            itemBuilder: (context, index) {
                              final passageiro = passageiros[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Tooltip(
                                  message: passageiro.nome,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        (passageiro.fotoPerfilUrl != null &&
                                                passageiro
                                                    .fotoPerfilUrl
                                                    .isNotEmpty)
                                            ? NetworkImage(
                                              passageiro.fotoPerfilUrl,
                                            )
                                            : AssetImage('assets/logo/passageiro.png'),
                                    child:
                                        (passageiro.fotoPerfilUrl == null ||
                                                passageiro
                                                    .fotoPerfilUrl
                                                    .isEmpty)
                                            ? Text(
                                              passageiro.nome.isNotEmpty
                                                  ? passageiro.nome[0]
                                                      .toUpperCase()
                                                  : "?",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            )
                                            : null,
                                    backgroundColor:
                                        Colors
                                            .blueGrey, // Cor de fallback para avatar
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    else
                      const Expanded(
                        child: Text(
                          "Nenhum passageiro nesta carona.",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        "Chat",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        // TODO: Implementar navegação para tela de Chat
                        // Ex: Routefly.navigate('/chat/${carona.id}');
                        debugPrint("Abrir chat da carona ${carona.id}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Funcionalidade de Chat para carona ID: ${carona.id} (não implementado)",
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        // Azul da imagem
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildInfoCard(
                  title:
                      carona.isVolta
                          ? "Volta - ${horaSaidaFormatada}h"
                          : "Ida - ${horaChegadaFormatada}h",
                  child: Text(
                    carona.isVolta
                        ? "Campus ${carona.rota.campus} x ${carona.rota.saida} - Saída ${horaSaidaFormatada}h"
                        : "${carona.rota.saida} x Campus ${carona.rota.campus}  - Saída ${horaSaidaFormatada}h",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  title: "Pontos da Carona",
                  child:
                      carona.rota.pontos.isNotEmpty
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                carona.rota.pontos
                                    .map(
                                      (ponto) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 6.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.fiber_manual_record,
                                              size: 8,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                ponto,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                          )
                          : const Text(
                            "Nenhum ponto de carona definido.",
                            style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  title: "Preço da Carona:", // Removido o ":" do título no card
                  child: Text(
                    "R\$ ${carona.preco.toStringAsFixed(2).replaceAll('.', ',') ?? 'N/A'}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF34A853),
                    ), // Verde
                  ),
                ),
                const SizedBox(height: 16),

                _buildInfoCard(
                  title: "Carro:", // Removido o ":" do título no card
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${motorista.carro!.marca} - ${motorista.carro!.modelo}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Placa: ${motorista.carro!.placa}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
