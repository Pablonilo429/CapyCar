import 'dart:typed_data';

import 'package:capy_car/config/dependencies.dart';
import 'package:capy_car/domain/validators/credentials_editar_usuario_validator.dart';
import 'package:capy_car/ui/components/appBar.dart';
import 'package:capy_car/ui/usuario/cadastro/components/photo_picker.dart';
import 'package:capy_car/ui/usuario/editar/editar_perfil_view_model.dart';
import 'package:capy_car/utils/GetLocais.dart';
import 'package:flutter/material.dart';

// import 'package:intl/intl.dart'; // Not used in the provided snippet, can be removed if not needed elsewhere
import 'package:result_command/result_command.dart'; // Ensure this import is present for FailureCommand

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final viewModel = injector.get<EditarPerfilViewModel>();

  final _nomeSocialController = TextEditingController();
  final _numeroCelularController = TextEditingController();

  // final _urlFotoPerfilController = TextEditingController(); // Removed as it's not used by a TextFormField
  final _bairroController = TextEditingController();

  // Removed _campusController and _cidadeController as Dropdowns will use direct values

  final validator = CredentialsEditarUsuarioValidator();

  final ValueNotifier<Uint8List?> _preRenderImage = ValueNotifier(null);

  Future<void> _showPhotoPicker() async {
    final selectedImage = await showDialog<Uint8List>(
      context: context,
      builder:
          (context) => PhotosPicker(greeting: "Selecione a sua foto de perfil"),
    );

    if (selectedImage != null) {
      _preRenderImage.value = selectedImage;
      // Note: viewModel.credentials.urlFotoPerfil is not updated here,
      // the new image is handled separately until save.
    }
  }

  @override
  void initState() {
    super.initState();

    viewModel.addListener(_onViewModelChanged);
    viewModel.editarUsuarioCommand.addListener(_listenableEditar);
    viewModel.excluirFotoCommand.addListener(
      _listenableExcluirFoto,
    ); // Add listener for delete command

    _updateTextFields();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        viewModel.init();
      }
    });
  }

  void _onViewModelChanged() {
    if (mounted) {
      _updateTextFields();
      // Call setState to rebuild UI parts that depend on viewModel.credentials or viewModel.usuario
      // (e.g., DropdownButtonFormFields, profile image)
      setState(() {});
    }
  }

  void _updateTextFields() {
    final credentials = viewModel.credentials;

    if (_nomeSocialController.text != (credentials.nomeSocial ?? '')) {
      _nomeSocialController.text = credentials.nomeSocial ?? '';
    }
    if (_numeroCelularController.text != (credentials.numeroCelular ?? '')) {
      _numeroCelularController.text = credentials.numeroCelular ?? '';
    }
    if (_bairroController.text != (credentials.bairro ?? '')) {
      _bairroController.text = credentials.bairro ?? '';
    }
    // Dropdown values (campus, cidade) are set directly in the DropdownButtonFormField's 'value' property
    // and will update when setState is called in _onViewModelChanged.
    // The profile image is handled by ValueListenableBuilder + viewModel.usuario.fotoPerfilUrl.
  }

  void _listenableEditar() {
    if (!mounted) return; // Avoid operations if widget is disposed

    if (viewModel.editarUsuarioCommand.isSuccess) {
      final snackBar = SnackBar(
        content: Text("Perfil atualizado com sucesso!"),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Optionally, refresh data or navigate
      // viewModel.init(); // To reload the user data with any server-side changes
    }
    if (viewModel.editarUsuarioCommand.isFailure) {
      final error =
          viewModel.editarUsuarioCommand.value; // Expecting FailureCommand here
      String errorMessage = "Erro ao atualizar perfil.";
      if (error is FailureCommand) {
        errorMessage = "Erro ao atualizar perfil: ${error.toString()}";
      } else if (error != null) {
        errorMessage = "Erro ao atualizar perfil: ${error.toString()}";
      }
      final snackBar = SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _listenableExcluirFoto() {
    if (!mounted) return;

    if (viewModel.excluirFotoCommand.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Foto de perfil removida com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
      _preRenderImage.value = null; // Clear any local preview as well
      viewModel
          .init(); // Refresh user data to reflect the photo's removal from backend
    }
    if (viewModel.excluirFotoCommand.isFailure) {
      final error = viewModel.excluirFotoCommand.value;
      String errorMessage = "Erro ao remover foto de perfil.";
      // It's good practice to check the type of error if possible
      if (error is FailureCommand) {
        errorMessage = "Erro ao remover foto de perfil: ${error.toString()}";
      } else if (error != null) {
        errorMessage = "Erro ao remover foto de perfil: ${error.toString()}";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    viewModel.editarUsuarioCommand.removeListener(_listenableEditar);
    viewModel.excluirFotoCommand.removeListener(
      _listenableExcluirFoto,
    ); // Remove listener

    _nomeSocialController.dispose();
    _numeroCelularController.dispose();
    _bairroController.dispose();
    _preRenderImage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locais =
        GetLocais(); // Consider making this a final field if it doesn't change
    return Scaffold(
      appBar: CustomAppBar(greeting: "Editar Perfil", isPop: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Inside the build method, replace the existing Padding for the profile picture:
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Stack(
                alignment: Alignment.center,
                // Ensures CircleAvatar is centered if Stack is larger
                children: [
                  GestureDetector(
                    // For picking a new photo
                    onTap: _showPhotoPicker,
                    child: ValueListenableBuilder<Uint8List?>(
                      valueListenable: _preRenderImage,
                      builder: (context, newImageBytes, child) {
                        ImageProvider<Object> backgroundImage;
                        bool isActuallyDisplayingPlaceholder;

                        if (newImageBytes != null &&
                            newImageBytes.length > 20) {
                          backgroundImage = MemoryImage(newImageBytes);
                          isActuallyDisplayingPlaceholder = false;
                        } else if (viewModel.usuario?.fotoPerfilUrl != null &&
                            viewModel.usuario!.fotoPerfilUrl.isNotEmpty) {
                          backgroundImage = NetworkImage(
                            viewModel.usuario!.fotoPerfilUrl,
                          );
                          isActuallyDisplayingPlaceholder = false;
                        } else {
                          backgroundImage = AssetImage(
                            'assets/logo/passageiro.png',
                          ); // Default placeholder
                          isActuallyDisplayingPlaceholder = true;
                        }
                        return CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: backgroundImage,
                        );
                      },
                    ),
                  ),
                  // "X" Button to remove photo
                  ValueListenableBuilder<Uint8List?>(
                    valueListenable: _preRenderImage,
                    // Listen to changes in local preview
                    builder: (context, newImageBytes, _) {
                      final bool hasLocalPreview =
                          newImageBytes != null && newImageBytes.length > 20;
                      final bool hasExistingNetworkImage =
                          viewModel.usuario?.fotoPerfilUrl != null &&
                          viewModel.usuario!.fotoPerfilUrl.isNotEmpty;

                      // Show button if there's a local preview OR an existing network image
                      if (hasLocalPreview || hasExistingNetworkImage) {
                        return Positioned(
                          top: 0,
                          // Adjust to position correctly relative to the CircleAvatar
                          right: 0,
                          // Adjust to position correctly relative to the CircleAvatar
                          // You might need to calculate these based on CircleAvatar's radius
                          // For a CircleAvatar(radius: 80), total diameter is 160.
                          // Example: right: (MediaQuery.of(context).size.width / 2) - 80 - 10, // approximate
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                              // Smaller icon
                              padding: EdgeInsets.all(4),
                              // Minimal padding
                              constraints: BoxConstraints(),
                              // To make it compact
                              tooltip: 'Remover foto',
                              onPressed: () {
                                if (hasLocalPreview) {
                                  // If a new image is in preview, just clear the preview
                                  _preRenderImage.value = null;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Seleção de foto cancelada.",
                                      ),
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
                                } else if (hasExistingNetworkImage) {
                                  // If no local preview, but an existing network image, call delete command
                                  viewModel.excluirFotoCommand.execute(
                                    viewModel.usuario!.fotoPerfilUrl,
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink(); // No button if no photo to remove
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text("Nome Social", style: _labelStyle),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nomeSocialController,
              decoration: _buildInputDecoration(hintText: 'Nome Social'),
              onChanged: viewModel.setNomeSocial,
              validator:
                  (value) => validator.byField(
                    viewModel.credentials,
                    'nomeSocial',
                  )(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            Text("Número Celular", style: _labelStyle),
            const SizedBox(height: 6),
            TextFormField(
              controller: _numeroCelularController,
              maxLength: 15,
              // Consider using a MaskTextInputFormatter for phone numbers
              keyboardType: TextInputType.phone,
              decoration: _buildInputDecoration(
                hintText: '(XX) XXXXX-XXXX',
                counterText: "",
              ),
              onChanged: viewModel.setNumeroCelular,
              validator:
                  (value) => validator.byField(
                    viewModel.credentials,
                    'numeroCelular',
                  )(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            Text("Campus", style: _labelStyle),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value:
                  viewModel.credentials.campus.isNotEmpty
                      ? viewModel.credentials.campus
                      : null,
              items:
                  locais.campusOptions.map((campus) {
                    return DropdownMenuItem(value: campus, child: Text(campus));
                  }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  // setState is called by _onViewModelChanged after notifyListeners from setCampus
                  viewModel.setCampus(value);
                }
              },
              decoration: _buildInputDecoration(
                labelText: 'Selecione o Campus',
              ),
              validator: validator.byField(viewModel.credentials, "campus"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            Text("Cidade", style: _labelStyle),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value:
                  viewModel.credentials.cidade.isNotEmpty
                      ? viewModel.credentials.cidade
                      : null,
              items:
                  locais.cidadesRioDeJaneiro.map((cidade) {
                    return DropdownMenuItem(value: cidade, child: Text(cidade));
                  }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  // setState is called by _onViewModelChanged after notifyListeners from setCidade
                  viewModel.setCidade(value);
                }
              },
              decoration: _buildInputDecoration(
                labelText: 'Selecione a Cidade',
              ),
              validator: validator.byField(viewModel.credentials, "cidade"),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),

            // Added SizedBox
            Text("Bairro", style: _labelStyle),
            const SizedBox(height: 6),
            TextFormField(
              controller: _bairroController,
              decoration: _buildInputDecoration(hintText: 'Bairro'),
              onChanged: viewModel.setBairro,
              validator:
                  (value) =>
                      validator.byField(viewModel.credentials, 'bairro')(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                textStyle: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                // Make text bold
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () {
                // Manually validate all fields if needed, or rely on Form widget if you wrap with it
                if (validator.validate(viewModel.credentials).isValid) {
                  viewModel.editarUsuarioCommand.execute(viewModel.credentials);
                  if (_preRenderImage.value != null) {
                    viewModel.editarFotoCommand.execute(
                      viewModel.usuario?.fotoPerfilUrl,
                      _preRenderImage.value!,
                    );
                  }
                } else {
                  // Optionally, show a generic validation error message or scroll to the first error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Por favor, corrija os erros no formulário.",
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Salvar Alterações'), // More descriptive text
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    String? hintText,
    Widget? prefixIcon,
    String? prefixText,
    String? labelText,
    String? counterText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      counterText: counterText,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[350]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        // Added errorBorder for consistency
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        // Added focusedErrorBorder
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 2.0,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  TextStyle get _labelStyle => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8),
  );
}
