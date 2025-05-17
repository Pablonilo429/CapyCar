import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompactarImagem{
  Future<Uint8List> comprimirList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1280,
      minWidth: 720,
      quality: 60,
    );
    return result;
  }

}