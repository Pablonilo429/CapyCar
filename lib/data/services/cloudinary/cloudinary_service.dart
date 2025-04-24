import 'dart:typed_data';
import 'package:cloudinary/cloudinary.dart';
import 'package:capy_car/gen/env.g.dart';
import 'package:flutter/cupertino.dart';

class CloudinaryService {
  final Cloudinary cloudinary;

  CloudinaryService()
    : cloudinary = Cloudinary.signedConfig(
        apiKey: Env.cloudinaryApiKey,
        apiSecret: Env.cloudinaryApiSecret,
        cloudName: Env.cloudinaryCloudName,
      );

  Future<String?> uploadImageFromBytes(Uint8List bytes, String userId) async {
    final fileName = '$userId-profile';

    final response = await cloudinary.upload(
      fileBytes: bytes,
      publicId: userId,
      resourceType: CloudinaryResourceType.image,
      folder: "CapyCar",
      fileName: fileName, // Nome do arquivo no Cloudinary
    );

    if (response.isSuccessful) {
      return response.secureUrl;
    } else {
      return null;
    }
  }

  Future<bool> deleteImage(String userId, String urlImage) async {
    final response = await cloudinary.destroy(
      userId,
      url: urlImage,
      resourceType: CloudinaryResourceType.image,
    );

    if (response.isSuccessful) {
      return true;
    } else {
      debugPrint('Erro ao deletar imagem: ${response.error}');
      return false;
    }
  }
}
