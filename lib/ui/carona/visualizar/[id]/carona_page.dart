import 'package:capy_car/config/dependencies.dart'; // Para o injector
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/carona/visualizar/%5Bid%5D/carona_view_model.dart';
import 'package:capy_car/ui/components/appBar.dart';
import 'package:capy_car/ui/components/appDrawer.dart';
import 'package:capy_car/ui/usuario/usuario_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routefly/routefly.dart';
import 'package:result_command/result_command.dart'; // Para FailureCommand
import 'package:shared_preferences/shared_preferences.dart';

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
    _idCarona = Routefly.query['id'] as String?;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Sempre verifique se o widget está montado

      if (_idCarona != null) {
        // Você pode mostrar o alerta antes ou depois de iniciar o command
        _mostrarAlertaChatInicial(); // <<< CHAMA O ALERTA AQUI
        viewModel.buscarCaronaCommand.execute(_idCarona!);
      } else {
        debugPrint("ID da carona não encontrado na rota.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro: ID da carona não fornecido."),
            backgroundColor: Colors.red,
          ),
        );
        Routefly.navigate(routePaths.carona.caronaHome);
      }
    });

    // Adicionar listener para o comando de cancelar carona
    viewModel.cancelarCaronaCommand.addListener(_listenableCancelarCarona);
    viewModel.entrarCaronaCommand.addListener(_listenableEntrarCarona);
    viewModel.sairCaronaCommand.addListener(_listenableSairCarona);
    viewModel.removerPassageiroCaronaCommand.addListener(
      _listenableRemoverPassageiroCarona,
    );
  }

  Future<void> _mostrarAlertaChatInicial() async {
    // Torna async
    if (!mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool alertaJaMostrado = prefs.getBool('alertaChatCaronaMostrado') ?? false;

    if (!alertaJaMostrado) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text("Lembrete Importante!"),
            content: const SingleChildScrollView(
              child: Text(
                "Não se esqueça de verificar o chat da carona regularmente!\n\nÉ por lá que você pode combinar detalhes, tirar dúvidas e receber atualizações importantes do motorista ou de outros passageiros.",
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Entendi"),
                onPressed: () {
                  prefs.setBool(
                    'alertaChatCaronaMostrado',
                    true,
                  ); // Marca como mostrado
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _listenableEntrarCarona() {
    if (!mounted) return;
    if (viewModel.entrarCaronaCommand.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ingressou na carona com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
    }

    if (viewModel.entrarCaronaCommand.isFailure) {
      final error = viewModel.entrarCaronaCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao entrar na carona: ${error.error.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _listenableSairCarona() {
    if (!mounted) return;
    if (viewModel.sairCaronaCommand.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saiu da carona com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
    }

    if (viewModel.sairCaronaCommand.isFailure) {
      final error = viewModel.sairCaronaCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao sair da carona: ${error.error.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _listenableRemoverPassageiroCarona() {
    if (!mounted) return;
    if (viewModel.removerPassageiroCaronaCommand.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passageiro removido com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
    }

    if (viewModel.removerPassageiroCaronaCommand.isFailure) {
      final error = viewModel.sairCaronaCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erro ao remover passageiro da carona: ${error.error.toString()}",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      Routefly.navigate(routePaths.carona.caronaHome);
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
    viewModel.entrarCaronaCommand.removeListener(_listenableEntrarCarona);
    viewModel.sairCaronaCommand.removeListener(_listenableSairCarona);
    viewModel.removerPassageiroCaronaCommand.removeListener(
      _listenableRemoverPassageiroCarona,
    );
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
      body: AnimatedBuilder (
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
          final motorista = viewModel.motorista!;
          final passageiros = viewModel.passageiros;
          final usuarioAtual = viewModel.usuario;

          final bool isMotoristaAtual = usuarioAtual?.uId == motorista.uId;
          final bool isPassageiro = viewModel.passageiros.any(
            (p) => p.uId == usuarioAtual?.uId,
          );
          String caronaStatus = carona.status;

          final horaChegadaFormatada = DateFormat.Hm().format(
            carona.horarioChegada,
          );
          final horaSaidaFormatada = DateFormat.Hm().format(
            carona.horarioSaidaCarona,
          );
          if (!carona.isFinalizada &&
              DateTime.now().isAfter(carona.horarioSaidaCarona)) {
            caronaStatus = 'Andamento';
          }
          if (!carona.isFinalizada &&
              DateTime.now().isBefore(carona.horarioSaidaCarona)) {
            caronaStatus = 'Agendada';
          }
          final caronaFinaliziada;
          if (DateTime.now().isAfter(carona.horarioChegada)) {
            caronaStatus = 'Finalizada';
            caronaFinaliziada = true;
          } else if (carona.isFinalizada) {
            caronaStatus = 'Finalizada';
            caronaFinaliziada = true;
          } else {
            caronaFinaliziada = false;
          }
          final bool mostrarBotaoRemoverGlobalmente;
          mostrarBotaoRemoverGlobalmente =
              isMotoristaAtual &&
              !carona.isFinalizada &&
              DateTime.now().isBefore(carona.horarioSaidaCarona);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção Motorista
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Motorista",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    _buildStatusBadge(context, caronaStatus),
                  ],
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            (motorista.fotoPerfilUrl.isNotEmpty)
                                ? NetworkImage(motorista.fotoPerfilUrl)
                                : const AssetImage('assets/logo/motorista.png')
                                    as ImageProvider,
                        backgroundColor: Colors.grey[300],
                      ),
                      onTap: () {
                        // Ação ao clicar: mostrar o diálogo
                        showDialog(
                          context: context, // Contexto do itemBuilder
                          builder: (BuildContext dialogContext) {
                            // Retorna a instância do seu UsuarioModal
                            return UsuarioModal(user: motorista);
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        motorista.nome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (!caronaFinaliziada)
                      /// Botão de ação com base nas regras
                      if (isMotoristaAtual) // a. Cancelar se for o motorista
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: const Text("Cancelar Carona"),
                                          content: const Text(
                                            "Tem certeza que deseja cancelar esta carona?",
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text("Não"),
                                              onPressed:
                                                  () =>
                                                      Navigator.of(
                                                        dialogContext,
                                                      ).pop(),
                                            ),
                                            TextButton(
                                              child: const Text(
                                                "Sim, cancelar",
                                              ),
                                              onPressed: () {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
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
                        )
                      else if (isPassageiro) // b. Sair se for passageiro
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            "Sair da Carona",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed:
                              viewModel.sairCaronaCommand.isRunning
                                  ? null
                                  : () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: const Text("Sair da Carona"),
                                          content: const Text(
                                            "Tem certeza que deseja sair desta carona?",
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text("Não"),
                                              onPressed:
                                                  () =>
                                                      Navigator.of(
                                                        dialogContext,
                                                      ).pop(),
                                            ),
                                            TextButton(
                                              child: const Text("Sim, sair"),
                                              onPressed: () {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                                viewModel.sairCaronaCommand
                                                    .execute(usuarioAtual!.uId);
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
                        )
                      else // c. Entrar se não for passageiro
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.login,
                            color: Colors.white,
                            size: 18,
                          ),
                          label: const Text(
                            "Entrar na Carona",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed:
                              viewModel.entrarCaronaCommand.isRunning
                                  ? null
                                  : () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return AlertDialog(
                                          title: const Text("Entrar na Carona"),
                                          content: const Text(
                                            "Tem certeza que deseja entrar nesta carona?",
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text("Não"),
                                              onPressed:
                                                  () =>
                                                      Navigator.of(
                                                        dialogContext,
                                                      ).pop(),
                                            ),
                                            TextButton(
                                              child: const Text("Sim, entrar"),
                                              onPressed: () {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                                viewModel.entrarCaronaCommand
                                                    .execute();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
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
                  "Passageiros", // Ou "Passageiros"
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
                              final passageiro =
                                  passageiros[index]; // Seu objeto Usuario (passageiro da lista)

                              // Opcional: Se o motorista estiver na lista de passageiros,
                              // você pode querer evitar que ele se auto-remova.
                              // final bool isEstePassageiroOMotorista = passageiro.uId == motorista.uId;

                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return UsuarioModal(user: passageiro);
                                      },
                                    );
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Tooltip(
                                        message: passageiro.nome,
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              (passageiro.fotoPerfilUrl !=
                                                          null &&
                                                      passageiro
                                                          .fotoPerfilUrl
                                                          .isNotEmpty)
                                                  ? NetworkImage(
                                                    passageiro.fotoPerfilUrl,
                                                  )
                                                  : const AssetImage(
                                                        'assets/logo/passageiro.png',
                                                      )
                                                      as ImageProvider,
                                          backgroundColor: Colors.blueGrey,
                                        ),
                                      ),

                                      if (mostrarBotaoRemoverGlobalmente)
                                        Positioned(
                                          top: -5,
                                          right: -5,
                                          child: GestureDetector(
                                            onTap: () async {
                                              final bool?
                                              confirmarRemocao = await showDialog<
                                                bool
                                              >(
                                                context: context,
                                                builder: (
                                                  BuildContext dialogContext,
                                                ) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Confirmar Remoção',
                                                    ),
                                                    content: Text(
                                                      'Deseja realmente remover o passageiro ${passageiro.nome}?',
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text(
                                                          'Não',
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(
                                                            dialogContext,
                                                          ).pop(false);
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: const Text(
                                                          'Sim',
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(
                                                            dialogContext,
                                                          ).pop(true);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              if (confirmarRemocao == true) {
                                                viewModel.sairCaronaCommand
                                                    .execute(passageiro.uId);
                                                setState(() {
                                                  passageiros.remove(
                                                    passageiro,
                                                  );
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
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
                    if (isPassageiro || isMotoristaAtual && !caronaFinaliziada)
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
                          Routefly.navigate(
                            routePaths.carona.visualizar.$id.chat.changes({
                              'id': '${carona.id}',
                            }),
                            arguments: carona.roomId,
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
                    "R\$ ${carona.preco.toStringAsFixed(2).replaceAll('.', ',')}",
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

  Widget _buildStatusBadge(BuildContext context, String status) {
    // Or RideStatus status
    Color backgroundColor;
    String text;

    switch (status) {
      // Assuming status is a String for this example
      case "Finalizada":
        backgroundColor = Colors.green;
        text = "Finalizada";
        break;
      case "Agendada":
        backgroundColor = Colors.blue;
        text = "Agendada";
        break;
      case "Andamento":
        backgroundColor = Colors.orange;
        text = "Em Andamento";
        break;
      case "Cancelada":
        backgroundColor = Colors.red;
        text = "Cancelada";
        break;
      default:
        return const SizedBox.shrink(); // Don't show anything if status is unknown or not set
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
