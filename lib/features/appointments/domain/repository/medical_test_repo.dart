import 'package:medired/core/core_export.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';

abstract class MedicalTestRepo {
  Future<DataState<List<MedicalTest>>> getMedicalTests();
}