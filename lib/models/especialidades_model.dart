import 'package:flutter/material.dart';

class EspecialidadesModel {
  final String id;
  final String id_servicio;
  final String id_prestador;
  final List<ItemEspecialidadesModel> especialidades;
  EspecialidadesModel({required this.id, required this.especialidades, required this.id_servicio, this.id_prestador = "0"});
}

class ItemEspecialidadesModel {
  final String name;
  final String key;
  TextEditingController descuento;
 FocusNode focusNode;
  bool status;
  ItemEspecialidadesModel(
      {
      required this.name,
      required this.key,
      required this.status,
      required this.descuento,
      required this.focusNode
      });
}
