import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/request/domain/repository/request_repository.dart';
import 'package:medired/features/request/data/models/request_model.dart';
import 'package:medired/features/request/domain/entities/request.dart';

class RequestRepositoryImpl extends RequestRepository {
  final firestore.FirebaseFirestore _firestore;

  RequestRepositoryImpl(this._firestore);
  @override
  Future<void> createRequest(Request request) async {
    RequestModel requestModel = RequestModel.fromEntity(request);

    await _firestore.collection(Collections.request).add(requestModel.toJson());
  }
}
