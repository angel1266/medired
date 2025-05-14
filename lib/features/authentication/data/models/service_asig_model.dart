class ServicioAsig {
  String id_servicio;
  String id_prestador;
  List<Especialidades> lista;

  ServicioAsig(
      {required this.id_prestador,
      required this.id_servicio,
      required this.lista});
}

class Servicio {
  String id;
  String name;

  Servicio({required this.id, required this.name});
}

class Especialidades {
  String id;
  String name;

  Especialidades({required this.id, required this.name});
}
