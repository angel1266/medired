enum AdminType {
  basic,
}

final Map<String, AdminType> stringToAdminType = {
  'Básico': AdminType.basic,
};

final Map<AdminType, String> userTypeToString = {
  AdminType.basic: 'Básico',
};