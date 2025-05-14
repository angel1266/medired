import 'package:json_annotation/json_annotation.dart';

/*
enum ServiceType {
  medicalConsultation,
  imaging,
  laboratory,
  dentistry,
  optometry,
  hospitalization,
  pharmacy,
  test,
}*/
enum ServiceType {
  medicalServicios,
  medicalConsultation,
  test
}


final Map<ServiceType, List<String>> serviceSpecializations = {
  ServiceType.medicalConsultation: [
    'Ginecología',
    'Medicina Interna',
    'Medicina General',
    'Pediatría',
    'Urología',
    'Otorrino',
    'Gastroenterología',
    'Cardiología',
    'Neumología',
    'Ortopedia',
    'Dermatología',
    'Psicología',
  ],
  /*
  ServiceType.imaging: [
    'Rayos X',
    'Sonografía',
    'Electrocardiograma',
    'Eco Cardíaco',
    'Resonancia',
  ],
  ServiceType.laboratory: [
    'Hemograma',
    'Perfil Lipídico',
    'Glucosa',
    'Magnesio',
    'Potasio',
    'Urea',
  ],
  ServiceType.dentistry: [
    'Consultas Generales',
    'Limpieza Dental',
    'Blanqueamiento',
    'Ortodoncia',
  ],
  ServiceType.optometry: [
    'Examen Visual',
    'Arreglo de Lentes',
    'Montura',
  ],
  ServiceType.hospitalization: [
    'Cama',
    'Cuidados Intensivos',
  ],
  ServiceType.pharmacy: [
    'Medicamentos Recetados',
    'Analgésicos',
  ],
  */
};

final Map<ServiceType, String> serviceTypeToString = {
  ServiceType.medicalConsultation: 'Consultass',
};
