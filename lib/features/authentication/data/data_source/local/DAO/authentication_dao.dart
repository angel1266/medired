import 'package:medired/features/authentication/data/models/authentication_model.dart';

abstract class AuthenticationDao {
  Future<void> insertAuthentication(AuthenticationModel authModel);
  Future<void> updateAuthentication(AuthenticationModel authModel);
  Future<void> deleteAuthentication(AuthenticationModel authModel);
  Future<List<AuthenticationModel>> getAllSortedByName();
}
