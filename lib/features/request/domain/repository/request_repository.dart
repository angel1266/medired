import 'package:medired/features/request/domain/entities/request.dart';

abstract class RequestRepository {
  Future<void> createRequest(Request request);
}