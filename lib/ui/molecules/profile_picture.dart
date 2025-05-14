import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medired/features/authentication/domain/entities/auth_info.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:download/download.dart';

class ProfilePicture extends StatelessWidget {
  final String? photoUrl;
  final String membresia;
  final Patient? paciente;
  final bool isLoading;
  final List<SuscripcionModel> suscripcion;
  final void Function(Uint8List imageBytes)? onPhotoChanged;

  ProfilePicture({
    this.isLoading = false,
    required this.photoUrl,
    required this.membresia,
    this.paciente,
    this.onPhotoChanged,
    required this.suscripcion,
    super.key,
  });

  GlobalKey _globalKey = GlobalKey();
  Future<void> _captureAndDownload(BuildContext context) async {
    try {
      final RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("captures/${DateTime.now().millisecondsSinceEpoch}.png");
      final uploadTask = storageRef.putData(pngBytes);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      //await WebImageDownloader.downloadImageFromWeb(downloadUrl,
      //    name: "carnet_${DateTime.now().millisecondsSinceEpoch}");

      final response = await http.get(Uri.parse(downloadUrl));
      final bytes = response.bodyBytes;
      final stream = Stream.fromIterable(bytes);

      await download(stream, 'carnet.png'); 
      await snapshot.ref.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carnet descargado exitosamente')),
      );
      print("Imagen eliminada del storage");
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _captureAndPrint() async {
    try {
      final RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      final String base64Image =
          html.window.btoa(String.fromCharCodes(pngBytes));
      final String dataUrl = 'data:image/png;base64,$base64Image';
      final String htmlContent =
          ''' <!DOCTYPE html> <html> <head> <title>carnet</title> </head> <body onload="print()"> <img src="$dataUrl"> </body> </html> ''';
      final String blobUrl = html.Url.createObjectUrlFromBlob(
          html.Blob([htmlContent], 'text/html'));
      html.window.open(blobUrl, '_blank');
      html.Url.revokeObjectUrl(blobUrl);
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildAnimatedCardRow(String title, String value, bool isDesktop) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blueBackground,
                      fontSize: isDesktop ? 18 : 16,
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: AppColors.blueBackground,
                      fontSize: isDesktop ? 18 : 16,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCarnetCard(
      bool isDesktop, bool isSmallDevice, BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: Container(
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(20),
                width: isDesktop
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 0.95,
                constraints: BoxConstraints(
                  minHeight: 250,
                  maxWidth: isSmallDevice ? 400 : 500,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  gradient: const LinearGradient(
                    colors: [Colors.white, AppColors.lightBlueBackground],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png',
                            height: isSmallDevice ? 40 : 50),
                        const SizedBox(width: 10),
                        Text(
                          'MediRed',
                          style: TextStyle(
                            fontSize: isSmallDevice ? 22 : 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blueBackground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildAnimatedCardRow(
                      'Nombre:',
                      paciente!.fullName ?? "",
                      isDesktop,
                    ),
                    const SizedBox(height: 12),
                    _buildAnimatedCardRow(
                        'Número de Membresía:', membresia, isDesktop),
                    const SizedBox(height: 12),
                    _buildAnimatedCardRow(
                        'Cédula:',
                        paciente!.personalInfo.documents[0].value ?? "",
                        isDesktop),
                    const SizedBox(height: 12),
                    _buildAnimatedCardRow(
                        'Tipo de Membresía:',
                        suscripcion
                                .where((element) =>
                                    element.uid.toString() ==
                                    paciente!.authInfo.uid.toString())
                                .isNotEmpty
                            ? 'Membresía Premium'
                            : paciente!.points < 1
                                ? 'Sin membresía'
                                : suscripcion
                                        .where((element) =>
                                            element.uid.toString() ==
                                            paciente!.authInfo.uid.toString())
                                        .isEmpty
                                    ? 'Membresía Vencida'
                                    : 'Membresía Premium',
                        isDesktop),
                  ],
                ),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _captureAndDownload(context);
          },
          child: Text('Descargar Carnet'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    bool isSmallDevice = MediaQuery.of(context).size.width <= 600;

    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 5)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return LayoutBuilder(builder: (context, constraints) {
            if (context.screenType() == ScreenType.desktop) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  paciente != null
                      ? _buildCarnetCard(isDesktop, isSmallDevice, context)
                      : _buildProfilePicture(context, 0.1)
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  paciente != null
                      ? _buildCarnetCard(isDesktop, isSmallDevice, context)
                      : _buildProfilePicture(context, 0.1)
                ],
              );
            }
          });
        }
      },
    );
  }

  Widget _buildProfilePicture(BuildContext context, double sizeFactor) {
    return Container(
      width: MediaQuery.of(context).size.width * sizeFactor,
      height: MediaQuery.of(context).size.width * sizeFactor,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: photoUrl != null
              ? CachedNetworkImageProvider(photoUrl!)
              : const AssetImage('assets/images/userbg.png') as ImageProvider,
          fit: photoUrl != null ? BoxFit.cover : BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Positioned(
      bottom: 10,
      right: 10,
      child: FloatingActionButton(
        onPressed: onPhotoChanged != null ? _selectPhoto : null,
        backgroundColor: AppColors.greenBackground,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildChangePhotoButton(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(
          AppColors.greenBackground,
        ),
        overlayColor: WidgetStateProperty.all(
          AppColors.greenBackground
              .withOpacity(0.1), // Adjust opacity as needed
        ),
      ),
      onPressed: _selectPhoto,
      child: const Text('Cambiar foto de perfil'),
    );
  }

  void _selectPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List? fileBytes;
      if (kIsWeb) {
        fileBytes = result.files.first.bytes!;
      } else {
        File file = File(result.files.first.path!);
        fileBytes = await file.readAsBytes();
      }
      onPhotoChanged!(fileBytes);
    }
  }
}

class SuscripcionModel {
  dynamic setDate;
  final String uid;
  final String id;
  SuscripcionModel(
      {required this.setDate, required this.uid, required this.id});
}
