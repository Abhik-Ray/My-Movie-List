// import 'dart:io';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
//
// class PictureHandler{
//   static pictureToBlob(File image) async{
//     final Uint8List bytes = await image.readAsBytes();
//     String img64 = base64Encode(bytes);
//     return img64;
//   }
//
//   static blobToImage(String image) async {
//     final decodedBytes = base64Decode(image);
//     File? file;
//     file!.writeAsBytesSync(decodedBytes);
//     return file;
//   }
//   static Image imageFromBase64String(String base64String) {
//     return Image.memory(base64Decode(base64String));
//   }
//
//   static Uint8List dataFromBase64String(String base64String) {
//     return base64Decode(base64String);
//   }
//
//   static String base64String(Uint8List data) {
//     return base64Encode(data);
//   }
// }
// }