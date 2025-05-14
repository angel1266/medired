import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';

abstract class UserExcelRepo {
  Future<DataState<List<Patient>>> getExcelPatients(Uint8List bytes, String arsUID);
}