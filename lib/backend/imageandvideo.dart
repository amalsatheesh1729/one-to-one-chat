
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Uint8List> picaimage() async
{
  String url="noimage";

      FirebaseStorage _firebasestorage=FirebaseStorage.instance;
      final ImagePicker _picker = ImagePicker();
      // Pick an image
      final XFile? xfile = await _picker.pickImage(source: ImageSource.gallery);
      Uint8List image= await xfile!.readAsBytes();
      return image;
}