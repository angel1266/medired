import 'package:flutter/material.dart';
import 'package:medired/ui/shared/table_membresia.dart';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

class TableMen extends StatelessWidget {
  const TableMen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plan>>(
      future: _getPlanesFromFirestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Error al obtener los datos');
        }

        final List<Plan>? planes = snapshot.data;

        if (planes == null || planes.isEmpty) {
          return const Text('No hay planes disponibles');
        }

        return SizedBox(
          height: 400,
          width: MediaQuery.of(context).size.width * 0.8,
          child: PricingTable(
            planes: planes,
            height: 400,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
        );
      },
    );
  }

  Future<List<Plan>> _getPlanesFromFirestore() async {
    try {
      final querySnapshot =
          await firestore.FirebaseFirestore.instance.collection('planes').get();

      return querySnapshot.docs.map((doc) {
        return Plan(
          name: doc['name'] ?? '',
          costo: doc['costo'] ?? 0.0,
          consultas: doc['consultas'] ?? 0,
          laboratorios: doc['laboratorios'] ?? 0,
          imagenes: doc['imagenes'] ?? 0,
          audiometria: doc['audiometria'] ?? 0,
          odontologia: doc['odontologia'] ?? 0,
        );
      }).toList();
    } catch (e) {
      return []; // Devuelve una lista vacía en caso de error
    }
  }
}
