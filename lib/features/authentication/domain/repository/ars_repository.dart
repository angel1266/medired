import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/ars.dart';

abstract class ARSRepository {
  Future<DataState<ARS>> createRemoteARS(
    ARS ars,
  );

  Future<DataState<ARS>> getRemoteARS(String uid);

  Future<DataState<List<ARS>>> getRemoteListARS();

  Future<DataState<String>> updateARS(String uid, Map<String, Object?> values);
}
