enum TitulosType { titulo1, title2, title3, title4 }

final Map<List<String>, TitulosType> stringtitulosType = {
  ['Paciente', 'Motivo', 'Cita']: TitulosType.titulo1,
  ['Paciente', 'Padece', 'Edad', 'Peso', 'Cedula', 'Seguro médico']:
      TitulosType.title2,
  ['Paciente', 'Correo', 'Edad', 'telefono', 'Cedula', 'direcion']:
      TitulosType.title3,
  ['Documento', 'Correo', 'Télefono', 'Tipo de usuario']: TitulosType.title4,
};

final Map<TitulosType, List<String>> titulosTypeToString = {
  TitulosType.titulo1: [
    'Paciente',
    'Motivo',
    'Cita',
  ],
  TitulosType.title2: [
    'Paciente',
    'Padece',
    'Edad',
    'Peso',
    'Cedula',
    'Seguro médico'
  ],
  TitulosType.title3: [
    'Paciente',
    'Correo',
    'Edad',
    'telefono',
    'Cedula',
    'direcion'
  ],
  TitulosType.title4: ['       Documento', '', '', '']
};
