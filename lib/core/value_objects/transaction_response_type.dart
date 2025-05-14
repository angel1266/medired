// ignore_for_file: constant_identifier_names

enum ResponseCode {
  Aprobada,
  LlamarAlBanco,
  ComercioInvalido,
  Rechazada,
  ErrorEnMensaje,
  TarjetaRechazada,
  RequestInProgress,
  AprobacionParcial,
  ApprovedVIP,
  TransaccionInvalida,
  MontoInvalido,
  CuentaInvalida,
  NoSuchIssuer,
  ApprovedUpdateTrack3,
  CustomerCancellation,
  CustomerDispute,
  ReintentarTransaccion,
  NoTomoAccion,
  TransaccionNoAceptada,
  FileUpdateNotSupported,
  UnableToLocateRecord,
  DuplicateRecord,
  FileUpdateEditError,
  FileUpdateFileLocked,
  BinNoSoportado,
  TxCompletadaParcialmente,
  TarjetaExpirada,
  TransaccionNoAprobada,
  TarjetaInvalida,
  FuncionNoSoportada,
  NoInvestmentAccount,
  FondosInsuficientes,
  TarjetaVencida,
  CuentaInvalidad,
  CuentaInvalidada,
  TransaccionNoPermitida,
  TransaccionNoPermitidaEnTerminal,
  ContactarAdquirente,
  ExcedioLimiteDeRetiro,
  TarjetaRestringida,
  ExcedioCantidadDeIntento,
  ContactarAdquirente2,
  HardCapture,
  ResponseReceivedTooLate,
  PinExcedioLimiteDeIntentos,
  CapturaDeLoteInvalida,
  IntervencionDelBancoRequerida,
  Rechazada2,
  PinInvalido,
  PINRequired,
  LlavesNoDisponibles,
  TerminalInvalida,
  CierreEnProceso,
  HostNoDisponible,
  ErrorDeRuteo,
  DuplicateTransaction,
  ErrorDeReconciliacion,
  ErrorDeSistema,
  EmisorNoDisponible,
  ExcedeLimiteDeEfectivo,
  CVVorCVCErrorResponse,
  SolicitudDeAutenticacionRechazadaONoCompletada,
}

String getResponseDescription(String code) {
  switch (code) {
    case '00':
      return 'Aprobada';
    case '01':
    case '02':
    case '08':
      return 'Llamar al Banco';
    case '03':
      return 'Comercio Inválido';
    case '04':
    case '05':
      return 'Rechazada';
    case '06':
      return 'Error en Mensaje';
    case '07':
      return 'Tarjeta Rechazada';
    case '09':
      return 'Request in progress';
    case '10':
      return 'Aprobación Parcial';
    case '11':
      return 'Approved VIP';
    case '12':
      return 'Transacción Inválida';
    case '13':
      return 'Monto Inválido';
    case '14':
      return 'Cuenta Inválida';
    case '15':
      return 'No such issuer';
    case '16':
      return 'Approved update track 3';
    case '17':
      return 'Customer cancellation';
    case '18':
      return 'Customer dispute';
    case '19':
      return 'Reintentar Transacción';
    case '20':
    case '21':
      return 'No tomo acción';
    case '22':
    case '23':
      return 'Transacción No Aprobada';
    case '24':
      return 'File update not supported';
    case '25':
      return 'Unable to locate record';
    case '26':
      return 'Duplicate record';
    case '27':
      return 'File update edit error';
    case '28':
      return 'File update file locked';
    case '30':
      return 'File update failed';
    case '31':
      return 'Bin no soportado';
    case '32':
      return 'Tx. Completada Parcialmente';
    case '33':
      return 'Tarjeta Expirada';
    case '34':
    case '35':
      return 'Transacción No Aprobada';
    case '36':
    case '37':
    case '38':
    case '41':
    case '43':
      return 'Transacción No Aprobada';
    case '39':
      return 'Tarjeta Inválida';
    case '40':
      return 'Función no Soportada';
    case '42':
      return 'Cuenta Inválida';
    case '44':
      return 'No investment account';
    case '51':
      return 'Fondos Insuficientes';
    case '52':
    case '53':
      return 'Cuenta Inválida';
    case '54':
      return 'Tarjeta Vencida';
    case '56':
      return 'Cuenta Inválida';
    case '57':
      return 'Transacción no permitida';
    case '58':
      return 'Transacción no permitida en terminal';
    case '60':
      return 'Contactar Adquirente';
    case '61':
      return 'Excedió Limite de Retiro';
    case '62':
      return 'Tarjeta Restringida';
    case '65':
      return 'Excedió Cantidad de Intento';
    case '66':
    case '67':
      return 'Contactar Adquirente';
    case '68':
      return 'Hard capture';
    case '75':
      return 'Pin excedió Límite de Intentos';
    case '77':
      return 'Captura de Lote Inválida';
    case '78':
      return 'Intervención del Banco Requerida';
    case '79':
      return 'Rechazada';
    case '81':
      return 'Pin inválido';
    case '82':
      return 'PIN Required';
    case '85':
      return 'Llaves no disponibles';
    case '89':
      return 'Terminal Inválida';
    case '90':
      return 'Cierre en proceso';
    case '91':
      return 'Host No Disponible';
    case '92':
      return 'Error de Ruteo';
    case '94':
      return 'Duplicate Transaction';
    case '95':
      return 'Error de Reconciliación';
    case '96':
      return 'Error de Sistema';
    case '97':
      return 'Emisor no Disponible';
    case '98':
      return 'Excede Límite de Efectivo';
    case '99':
      return 'CVV or CVC Error response';
    case 'TF':
      return 'Solicitud de autenticación rechazada o no completada';
    default:
      return 'Código no reconocido';
  }
}
