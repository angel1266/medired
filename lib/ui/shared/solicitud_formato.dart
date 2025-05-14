class SolicitudCita {
  final String paciente;
  final String motivo;
  final String fecha;
  final String hora;
  final String? sintomas; // Parámetro opcional

  SolicitudCita(this.paciente, this.motivo, this.fecha, this.hora,
      [this.sintomas]);
}
