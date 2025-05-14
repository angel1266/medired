enum PatientFields {
  name,
  lastName,
  email,
  phoneNumber,
  birthDate,
  sex,
  dni,
}

final Map<String, PatientFields> string2PatientFields = {
  'Nombre': PatientFields.name,
  'Apellido': PatientFields.lastName,
  'Correo electrónico': PatientFields.email,
  'Número de teléfono': PatientFields.phoneNumber,
  'Fecha de nacimiento': PatientFields.birthDate,
  'Sexo': PatientFields.sex,
  'Cédula': PatientFields.dni,
};

final Map<PatientFields, String> patientFields2String = {
  PatientFields.name: 'Nombre',
  PatientFields.lastName: 'Apellido',
  PatientFields.email: 'Correo electrónico',
  PatientFields.phoneNumber: 'Número de teléfono',
  PatientFields.birthDate: 'Fecha de nacimiento',
  PatientFields.sex: 'Sexo',
  PatientFields.dni: 'Cédula'
};
