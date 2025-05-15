import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;

class UploadImageScreen extends StatefulWidget {
  Function getUrl;
  String image;
  UploadImageScreen({required this.getUrl, required this.image});
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  Uint8List? _imageBytes;
  String? _downloadURL;
  Future getImage() async {
    final imageBytes = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      if (imageBytes != null) {
        _imageBytes = imageBytes;
        uploadImageToFirebase("image_name", _imageBytes!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImageToFirebase(String fileName, Uint8List imageBytes) async {
    if (imageBytes == null) return;
    String fileExtension = path.extension(fileName);
    String newFileName =
        '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('uploads/$newFileName');
    UploadTask uploadTask = storageReference.putData(imageBytes);
    await uploadTask;
    print('File Uploaded');
    String downloadURL = await storageReference.getDownloadURL();
    setState(() {
      _downloadURL = downloadURL;
      widget.getUrl(_downloadURL);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _imageBytes == null
              ? widget.image != ""? Image.network(
                  widget.image,
                  height: 80,
                  width: 200,
                ): Image.asset(
                  "assets/images/user.jpg",
                  height: 80,
                  width: 200,
                )
              : Image.memory(
                  _imageBytes!,
                  height: 80,
                  width: 200,
                ),
          ElevatedButton(
            onPressed: getImage,
            child: Text('Subir Logo'),
          ),
        ],
      ),
    );
  }
}
