import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/authentication/data/models/service_provider_model.dart';
import 'package:medired/features/authentication/domain/entities/service_provider.dart';
import 'package:medired/features/authentication/domain/repository/service_provider_repository.dart';

class ServiceProviderRepositoryImpl implements ServiceProviderRepository {
  final firestore.FirebaseFirestore _firestore;

  ServiceProviderRepositoryImpl(this._firestore);

  @override
  Future<DataState<ServiceProvider>> createRemoteServiceProvider(
      ServiceProvider serviceProvider) async {
    try {
      ServiceProviderModel serviceProviderModel =
          ServiceProviderModel.fromEntity(serviceProvider);

      await _firestore
          .collection(Collections.member)
          .doc(serviceProviderModel.authInfoModel.uid)
          .set(serviceProviderModel.toJson());

      return Right(ServiceProvider.toEntity(serviceProviderModel));
    } on firestore.FirebaseException catch (error) {
      return Left(error.message!);
    }
  }

  @override
  Future<DataState<ServiceProvider>> getRemoteServiceProvider(
      String uid) async {
    try {
      firestore.DocumentSnapshot documentSnapshot =
          await _firestore.collection(Collections.member).doc(uid).get();
      Map<String, dynamic> json =
          documentSnapshot.data() as Map<String, dynamic>;
      ServiceProvider serviceProvider = ServiceProviderModel.fromJson(json);
      return Right(serviceProvider);
    } on firestore.FirebaseException catch (error) {
      log(error.message!);
      return Left(error.message!);
    }
  }

  @override
  Future<DataState<List<ServiceProvider>>> getRemoteServiceProviders() async {
    try {
      firestore.QuerySnapshot querySnapshot = await _firestore
          .collection(Collections.member)
          .where('memberInfo.memberType', isEqualTo: UserType.provider.index)
          .get();
      List<ServiceProvider> serviceProviderList = querySnapshot.docs
          .map((doc) =>
              ServiceProviderModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      serviceProviderList.removeWhere((serviceProvider) =>
          serviceProvider.memberInfo.subscriptionType ==
          SubscriptionType.mensual);
      return Right(serviceProviderList);
    } on firestore.FirebaseException catch (error) {
      return Left(error.message!);
    }
  }
}
