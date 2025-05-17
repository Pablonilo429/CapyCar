import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotosPicker extends StatefulWidget {
  const PhotosPicker({super.key, required this.greeting});
  final String greeting;
  @override
  State<PhotosPicker> createState() => _PhotosPickerState();
}

class _PhotosPickerState extends State<PhotosPicker> {
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      var f = await image.readAsBytes();
      // Verifica o tamanho da imagem
      if (f.lengthInBytes > 5 * 1024 * 1024) {
        // Exibe uma notificação se a imagem for maior que 5MB
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imagem maior que 5MB! Por favor, escolha uma imagem menor.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }
      // Processa a imagem se o tamanho for válido
      setState(() {
        webImage = f;
        _pickedImage = File('a');
      });
    } else {
      print('No image has been picked');
    }
    Navigator.pop(context, webImage);
  }


  // Future<void> _pickImage(ImageSource source) async {
  //   XFile? returnedImage = await ImagePicker().pickImage(source: source);
  //   if (returnedImage != null) return;
  //   setState(() {
  //     var selected = File(returnedImage.path);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Foto carregada!'),
  //         duration: Duration(seconds: 3),
  //       ),
  //     );
  //   });
  //   Navigator.pop(context, _selectedImage);
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF32373e),
      title: Text(
        widget.greeting,
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
            color: Colors.amber,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.photo, color: Colors.white),
                SizedBox(width: 10.0),
                Text(
                  "Galeria",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
          SizedBox(height: 8.0),
          MaterialButton(
            color: Colors.amber,
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
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
        ],
      ),
    );
  }
}
