import 'package:excel/excel.dart';
import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/massive_upload/domain/repository/user_excel_repo.dart';

/*Excel Columns:
Este comentario es simplemente para poner la plantilla de excel en el código
y quien sea que venga, pueda verla y entenderla.

column[0]: Va a guardar el nombre del paciente
column[1]: Va a guardar el apellido del paciente
column[2]: Va a guardar el número de teléfono del paciente
column[3]: Va a guardar el email del paciente
column[4]: Va a guardar la cédula o pasaporte del paciente
column[5]: Va a guardar el sexo del paciente
column[6]: Va a guardar el tipo de suscripción del paciente
column[7]: Va a guardar el número del contrato afiliado del paciente
column[8]: Va a guardar el nombre de la empresa del paciente
*/

class UserExcelRepoImpl implements UserExcelRepo {
  UserExcelRepoImpl();

  @override
  Future<DataState<List<Patient>>> getExcelPatients(
      Uint8List bytes, String arsUID) async {
    Excel excel;
    try {
      excel = Excel.decodeBytes(bytes);
    } catch (e) {
      return const Left('The file is not a valid xlsx');
    }

    Sheet sheet;
    try {
      sheet = excel.sheets.values.first;
      if (sheet.maxRows < 2) {
        return const Left('The file is empty');
      }
    } catch (e) {
      return const Left('The file is empty');
    }

    var users = <Patient>[];
    for (var i = 1; i < sheet.rows.length; i++) {
      var row = sheet.rows[i];

      if (row.length < 9) {
        continue;
      }

      String? firstName = row[0]?.value.toString();
      String? lastName = row[1]?.value.toString();
      String? phoneNumberValue = row[2]?.value.toString();
      String? email = row[3]?.value.toString();
      String? documentValue = row[4]?.value.toString();
      Sex? sex;
      SubscriptionType? subscriptionType;
      String? contractNumber = row[7]?.value.toString();
      String? company = row[8]?.value.toString();

      var sexIndex = tryParseInt(row[5]?.value.toString());
      if (sexIndex != null && sexIndex < Sex.values.length && sexIndex > -1) {
        sex = Sex.values[sexIndex];
      }

      var subscriptionIndex = tryParseInt(row[6]?.value.toString());
      if (subscriptionIndex != null &&
          subscriptionIndex < SubscriptionType.values.length &&
          subscriptionIndex > -1) {
        subscriptionType = SubscriptionType.values[subscriptionIndex];
      }

      if (firstName == null || firstName.isEmpty) {
        continue;
      } else if (lastName == null || lastName.isEmpty) {
        continue;
      } else if (phoneNumberValue == null || phoneNumberValue.isEmpty) {
        continue;
      } else if (email == null || email.isEmpty) {
        continue;
      } else if (sex == null) {
        continue;
      } else if (documentValue == null) {
        continue;
      } else if (subscriptionType == null) {
        continue;
      } else if (company == null || company.isEmpty) {
        continue;
      } else if (contractNumber == null || contractNumber.isEmpty) {
        continue;
      }

      var patient = PatientModel.fromExcel(
        firstName: firstName,
        lastName: lastName,
        token_facebook: '',
        token_google: '',
        email: email,
        birthDate: DateTime.now(),
        documentValue: documentValue,
        phoneNumberValue: phoneNumberValue,
        subscriptionType: subscriptionType,
        sex: sex,
        arsuid: arsUID,
        company: company,
        contractNumber: contractNumber,
      );
      users.add(patient);
    }

    return Right(users);
  }
}

int? tryParseInt(String? source) {
  if (source == null) {
    return null;
  }
  return int.tryParse(source);
}
