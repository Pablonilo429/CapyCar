import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';

class PhotosPicker extends StatefulWidget {
  const PhotosPicker({super.key, required this.greeting});
  final String greeting;
  @override
  State<PhotosPicker> createState() => _PhotosPickerState();
}

class _PhotosPickerState extends State<PhotosPicker> {
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    // Mostra o indicador de carregamento
    setState(() {
      _isLoading = true;
    });

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: source);

      // Se o utilizador cancelar a seleção de imagem, para o carregamento
      if (image == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      var f = await image.readAsBytes();

      // Esconde o indicador de carregamento antes de navegar para a página de recorte
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      } else {
        return;
      }

      // Verifica o tamanho da imagem
      if (f.lengthInBytes > 5 * 1024 * 1024) {
        messenger.showSnackBar(
          const SnackBar(
            content:
            Text('A imagem é maior que 5MB! Por favor, escolha uma menor.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      final croppedData = await navigator.push<Uint8List>(
        MaterialPageRoute(
          builder: (context) => CropPage(image: f),
        ),
      );

      if (mounted && croppedData != null) {
        navigator.pop(croppedData);
      }
    } catch (e) {
      print('Erro ao selecionar imagem: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.greeting,
        style: TextStyle(color: theme.colorScheme.primary),
      ),
      content: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialButton(
                color: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.photo_library, color: Colors.white),
                    SizedBox(width: 10.0),
                    Text(
                      "Galeria",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              const SizedBox(height: 8.0),
              MaterialButton(
                color: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.camera_alt, color: Colors.white),
                    SizedBox(width: 10.0),
                    Text(
                      "Câmera",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
          // Indicador de carregamento para a seleção da imagem
          if (_isLoading)
            Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16)
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            ),
        ],
      ),
    );
  }
}

// Ecrã aprimorado para recortar a imagem com controlos avançados
class CropPage extends StatefulWidget {
  final Uint8List image;
  const CropPage({super.key, required this.image});

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final _cropController = CropController();
  bool _isCropping = false;
  bool _isCircleUi = true;
  bool _undoEnabled = false;
  bool _redoEnabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recortar Imagem'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _undoEnabled ? () => _cropController.undo() : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _redoEnabled ? () => _cropController.redo() : null,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF0F2F5), // Fundo claro
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Crop(
                  controller: _cropController,
                  image: widget.image,
                  onCropped: (result) {
                    setState(() {
                      _isCropping = false;
                    });
                    switch (result) {
                      case CropSuccess(croppedImage: final croppedImage):
                        Navigator.pop(context, croppedImage);
                        break;
                      case CropFailure(cause: final cause):
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text('Falha ao recortar a imagem: $cause'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        break;
                    }
                  },
                  withCircleUi: _isCircleUi,
                  onHistoryChanged: (history) => setState(() {
                    _undoEnabled = history.undoCount > 0;
                    _redoEnabled = history.redoCount > 0;
                  }),
                  overlayBuilder: (context, rect) {
                    final overlay = CustomPaint(
                      painter: GridPainter(),
                    );
                    return _isCircleUi ? ClipOval(child: overlay) : overlay;
                  },
                  cornerDotBuilder: (size, edgeAlignment) =>
                      DotControl(color: theme.colorScheme.primary),
                  maskColor: Colors.black.withAlpha(180),
                  baseColor: const Color(0xFFF0F2F5),
                  aspectRatio: 1.0,
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                        ),
                        icon: const Icon(Icons.crop),
                        label: const Text(
                          'RECORTAR IMAGEM',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          setState(() {
                            _isCropping = true;
                          });
                          _isCircleUi
                              ? _cropController.cropCircle()
                              : _cropController.crop();
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              )
            ],
          ),
          // Indicador de carregamento para o processo de recorte
          if (_isCropping)
            Container(
              color: const Color(0xFFF0F2F5).withOpacity(0.8),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Pintor personalizado para a grelha de sobreposição
class GridPainter extends CustomPainter {
  final divisions = 2;
  final strokeWidth = 1.0;
  final Color color = Colors.white70;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = color;

    final spacing = size / (divisions + 1);
    for (var i = 1; i < divisions + 1; i++) {
      // desenha linha vertical
      canvas.drawLine(
        Offset(spacing.width * i, 0),
        Offset(spacing.width * i, size.height),
        paint,
      );

      // desenha linha horizontal
      canvas.drawLine(
        Offset(0, spacing.height * i),
        Offset(size.width, spacing.height * i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}
