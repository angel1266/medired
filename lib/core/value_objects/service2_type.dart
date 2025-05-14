enum ServicesType {
  consulta,
  laboratorio,
  imagenes,
}

final Map<String, ServicesType> stringToServicesType = {
  'Consulta': ServicesType.consulta,
  'Laboratorio': ServicesType.laboratorio,
  'Imágenes': ServicesType.imagenes,
};

final Map<ServicesType, String> servicesTypeToString = {
  ServicesType.consulta: 'Consulta',
  ServicesType.laboratorio: 'Laboratorio',
  ServicesType.imagenes: 'Imágenes',
};

final Map<ServicesType, List<String>> servicesTypeToList = {
  ServicesType.consulta: chlidConsultas,
  ServicesType.laboratorio: chlidLaboratorio,
  ServicesType.imagenes: chlidImagenes,
};

List<String> chlidLaboratorio = [
  'Hemograma',
  'Orina',
  'Perfil lipídico',
  'Glucosa',
];

List<String> chlidImagenes = [
  'Rayos X',
  'Sonografía',
  'Cardiovasculares: Eco',
  'Electrocardiograma',
];

List<String> chlidConsultas = [
  'Ginecología',
  'Medicina interna',
  'Pediatría',
  'Medicina general',
  'Urología',
  'Oftalmología',
  'Odontología',
  'Audiometria',
];
