import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/authentication_export.dart';

abstract class AdminRepo {
  Future<DataState<Admin>> getRemoteAdmin(String uid);
}