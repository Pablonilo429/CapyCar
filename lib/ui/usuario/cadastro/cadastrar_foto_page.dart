import 'dart:typed_data';

import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/main.dart';
import 'package:capy_car/ui/usuario/cadastro/cadastrar_foto_viewmodel.dart';
import 'package:capy_car/ui/usuario/cadastro/components/photo_picker.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:routefly/routefly.dart';

class CadastrarFotoPage extends StatefulWidget {
  const CadastrarFotoPage({super.key});

  @override
  State<CadastrarFotoPage> createState() => _CadastrarFotoPageState();
}

class _CadastrarFotoPageState extends State<CadastrarFotoPage> {
  final ValueNotifier<Uint8List?> _preRenderImage = ValueNotifier(null);
  final viewModel = injector.get<CadastarFotoViewModel>();

  Future<void> _showPhotoPicker() async {
    final selectedImage = await showDialog<Uint8List>(
      context: context,
      builder:
          (context) => PhotosPicker(greeting: "Selecione a sua foto de perfil"),
    );

    if (selectedImage != null) {
      _preRenderImage.value = selectedImage;
    }
  }

  @override
  void initState() {
    super.initState();

    viewModel.cadastrarFotoCommand.addListener(_listenable);
  }

  void _listenable() {
    if (viewModel.cadastrarFotoCommand.isFailure) {
      final error = viewModel.cadastrarFotoCommand.value as FailureCommand;

      final snackBar = SnackBar(
        content: Text(error.error.toString()),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    viewModel.cadastrarFotoCommand.removeListener(_listenable);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1974BF), Color(0xFF2B7422)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Para tornar as viagens seguras\nprecisamos tirar uma foto do seu rosto ;)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 40),

              // Avatar com ícone de pessoa
              GestureDetector(
                onTap: _showPhotoPicker,
                child: ValueListenableBuilder<Uint8List?>(
                  valueListenable: _preRenderImage,
                  builder: (context, imageBytes, child) {
                    final bool hasImage =
                        imageBytes != null && imageBytes.length > 20;

                    return CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          hasImage ? MemoryImage(imageBytes) : null,
                      child:
                          hasImage
                              ? null
                              : Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.purple.shade800,
                              ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Obs: Você não é obrigado a tirar foto',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(height: 32),

              ListenableBuilder(
                listenable: viewModel.cadastrarFotoCommand,
                builder: (context, _) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (_preRenderImage.value != null) {
                        viewModel.cadastrarFotoCommand.execute(
                          _preRenderImage.value!,
                        );
                        if (viewModel.cadastrarFotoCommand.isSuccess) {
                          Routefly.navigate(
                            routePaths
                                .usuario
                                .cadastro
                                .cadastrarPapel,
                          );
                        }
                      } else {
                        Routefly.navigate(
                          routePaths.usuario.cadastro.cadastrarPapel,
                        );
                      }
                    },
                    child: const Text('Continuar'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
