import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';

class PrestadorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadMemberData(
      String id, BuildContext context, Function send) async {
    DocumentSnapshot memberDoc =
        await _firestore.collection('member').doc(id).get();

    if (memberDoc.exists) {
      Map<String, dynamic> data = memberDoc.data() as Map<String, dynamic>;
      send(data);
    } else {
      _showErrorSnackbar(context, 'Documento no encontrado');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior
          .floating, // Esto hace que la barra no se adhiera al borde inferior
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


Future<void> actualizarCorreo(User user, String nuevoCorreo) async {
  try {
    await user.updateEmail(nuevoCorreo);
    print('Correo electrónico actualizado a: $nuevoCorreo');
    // Envía un correo de verificación al nuevo correo
    await user.sendEmailVerification();
    print('Correo de verificación enviado.');
  } catch (e) {
    print('Error al actualizar el correo electrónico: $e');
  }
}

Future<void> actualizarContrasena(User user, String nuevaContrasena) async {
  try {
    await user.updatePassword(nuevaContrasena);
    print('Contraseña actualizada.');
  } catch (e) {
    print('Error al actualizar la contraseña: $e');
  }
}

}
