import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/models/carona/carona.dart'; // Corrigido de "caronas.dart"
import 'package:capy_car/ui/components/appBar.dart';
import 'package:capy_car/ui/carona/carona_home_viewmodel.dart';
import 'package:capy_car/ui/components/appDrawer.dart';
import 'package:capy_car/utils/LoaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CaronaHomePage extends StatefulWidget {
  const CaronaHomePage({super.key});

  @override
  State<CaronaHomePage> createState() => _CaronaHomePageState();
}

class _CaronaHomePageState extends State<CaronaHomePage> {
  final viewModel = injector.get<CaronaHomeViewModel>();

  @override
  void initState() {
    viewModel.buscarCaronasCommand.execute();
    viewModel.usuario;
    super.initState();
  }

  // @override
  // void dispose() {
  //   viewModel.buscarCaronasCommand.dispose();
  //   viewModel.campusSelecionado.dispose();
  //   viewModel.isVolta.dispose();
  //   viewModel.textoBusca.dispose();
  //   viewModel.caronas.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(greeting: "Caronas", isPop: false),
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      body: ValueListenableBuilder<bool>(
        valueListenable: viewModel.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return LoaderWidget();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
            child: Column(
              children: [
                // 🔍 Barra de pesquisa
                ValueListenableBuilder<String>(
                  valueListenable: viewModel.textoBusca,
                  builder: (context, value, _) {
                    return TextField(
                      decoration: InputDecoration(
                        hintText: "Pesquisar Caronas...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: viewModel.setTextoBusca,
                    );
                  },
                ),

                const SizedBox(height: 12),

                // 🎓 Filtro de Campus e Toggle de Volta
                Row(
                  children: [
                    PopupMenuButton<String>(
                      onSelected: (value) => viewModel.setCampus(value),
                      itemBuilder:
                          (context) => const [
                            PopupMenuItem(
                              value: 'Seropédica',
                              child: Text('Campus Seropédica'),
                            ),
                            PopupMenuItem(
                              value: 'Nova Iguaçu',
                              child: Text('Campus Nova Iguaçu'),
                            ),
                            PopupMenuItem(
                              value: 'Três Rios',
                              child: Text('Campus Três Rios'),
                            ),
                          ],
                      child: ValueListenableBuilder<String?>(
                        valueListenable: viewModel.campusSelecionado,
                        builder:
                            (context, campus, _) => Chip(
                              label: Text(campus ?? 'Selecionar campus'),
                              avatar: const Icon(Icons.filter_alt, size: 18),
                            ),
                      ),
                    ),
                    const Spacer(),
                    const Text("Volta"),
                    ValueListenableBuilder<bool?>(
                      valueListenable: viewModel.isVolta,
                      builder:
                          (context, isVolta, _) => Switch(
                            value: isVolta ?? false,
                            onChanged: (val) => viewModel.toggleVolta(val),
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

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
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final carona = lista[index];
                              if (carona == null)
                                return const SizedBox.shrink();
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
          );
        },
      ),

      // 🔽 Barra inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Viagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Oferecer Viagem',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Sua Carona',
          ),
        ],
        onTap: (index) {
          // Navegação
        },
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

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/carona/detalhes', arguments: carona);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE1F1FF),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  fotoUrl != null
                      ? NetworkImage(fotoUrl)
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
                        "${carona.rota.campus} - ${carona.rota.saida} - saída: $horaSaidaFormatada",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                      : Text(
                        "${carona.rota.saida} - ${carona.rota.campus} - chegada: $horaChegadaFormatada",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                  // ✅ Pontos intermediários da rota
                  if (pontos != null && pontos.isNotEmpty)
                    Text(
                      "Passando por: ${pontos.join(', ')}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),

                  Text("Preço: R\$ ${carona.preco.toStringAsFixed(2)}"),
                  Text(
                    "Vagas disponíveis: ${carona.qtdePassageiros - (carona.idsPassageiros?.length ?? 0)}",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
