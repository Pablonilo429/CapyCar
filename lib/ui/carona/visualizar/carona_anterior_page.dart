import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/models/carona/carona.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/carona/visualizar/carona_anterior_view_model.dart';
import 'package:capy_car/ui/components/appBar.dart';
import 'package:capy_car/ui/components/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routefly/routefly.dart';

class CaronaAnteriorPage extends StatefulWidget {
  const CaronaAnteriorPage({super.key});

  @override
  State<CaronaAnteriorPage> createState() => _CaronaAnteriorPageState();
}

class _CaronaAnteriorPageState extends State<CaronaAnteriorPage> {
  final viewModel = injector.get<CaronaAnteriorViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.buscarCaronasCommand.execute();
    viewModel.usuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(greeting: "Caronas Anteriores", isPop: false),
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
        child: Column(
          children: [
            // 🧾 Lista de Caronas
            Expanded(
              child: ValueListenableBuilder<List<Carona?>>(
                valueListenable: viewModel.caronas,
                builder: (context, lista, _) {
                  if (lista.isEmpty) {
                    return const Center(
                      child: Text("Nenhuma carona encontrada."),
                    );
                  }

                  return ValueListenableBuilder<Map<String, String>>(
                    valueListenable: viewModel.fotosUsuarios,
                    builder: (context, fotosMap, _) {
                      return ListView.separated(
                        itemCount: lista.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final carona = lista[index];
                          if (carona == null) return const SizedBox.shrink();
                          final fotoUrl = fotosMap[carona.motoristaId];
                          return _buildCaronaCard(context, carona, fotoUrl);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaronaCard(
    BuildContext context,
    Carona carona,
    String? fotoUrl,
  ) {
    final horaChegadaFormatada = DateFormat.Hm().format(carona.horarioChegada);
    final horaSaidaFormatada = DateFormat.Hm().format(
      carona.horarioSaidaCarona,
    );

    final pontos = carona.rota.pontos; // <- agora pega direto da rota
    String caronaStatus = carona.status;

    if (!carona.isFinalizada &&
        DateTime.now().isAfter(carona.horarioSaidaCarona)) {
      caronaStatus = 'Andamento';
    }
    if (!carona.isFinalizada &&
        DateTime.now().isBefore(carona.horarioSaidaCarona)) {
      caronaStatus = 'Agendada';
    }

    return InkWell(
      onTap: () {
        Routefly.navigate(
          routePaths.carona.visualizar.$id.carona.changes({
            'id': '${carona.id}',
          }),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE1F1FF),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundImage:
              fotoUrl?.isNotEmpty ?? false
                  ? NetworkImage(fotoUrl!)
                  : const AssetImage('assets/logo/motorista.png')
              as ImageProvider,
              radius: 25,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  carona.isVolta
                      ? Text(
                        "Volta: ${carona.rota.campus} - ${carona.rota.saida} - saída: $horaSaidaFormatada",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                      : Text(
                        "Ida: ${carona.rota.saida} - ${carona.rota.campus} - chegada: $horaChegadaFormatada",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                  if (pontos != null && pontos.isNotEmpty)
                    Text(
                      "Passando por: ${pontos.join(', ')}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
            _buildStatusBadge(context, caronaStatus),
          ],
        ),
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
