import 'package:medired/core/bloc/bloc_export.dart';
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class SendEmailPasswordResetUseCase {
  final AuthRepo _repo;

  SendEmailPasswordResetUseCase(this._repo);

  Future<DataState<Unit>> call({required String email}) async {
    try {
      await _repo.sendEmailPasswordReset(email);
      return const Right(unit);
    } catch (e) {
      return const Left(
          'Ocurrió un error al intentar el restablecimiento de contraseña');
    }
  }
}
