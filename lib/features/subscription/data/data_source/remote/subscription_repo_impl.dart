import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/subscription/data/ds/subscription_ds.dart';
import 'package:medired/features/subscription/data/models/subscription_model.dart';
import 'package:medired/features/subscription/domain/entities/subscription.dart';
import 'package:medired/features/subscription/domain/repository/subscription_repo.dart';

class SubscriptionRepoImpl implements SubscriptionRepo {
  final firestore.FirebaseFirestore _firestore;
  final SubscriptionDs _api;

  SubscriptionRepoImpl(this._firestore, this._api);

  @override
  Future<DataState<Subscription>> updateSubscription(
      Subscription subscription, String uid) async {
    try {
      SubscriptionModel model =
          SubscriptionModel.fromEntity(subscription.copyWith(id: uid));

      var docRef =
          _firestore.collection(Collections.subscriptions).doc(model.id);

      await docRef.update(model.toJson());

      return Right(model);
    } catch (e) {
      return const Left('Ha ocurrido un error al actualizar los datos');
    }
  }

  @override
  Future<DataState<bool>> updatePayedSubscription(
    String subscriptionId,
    String uid,
    String amount,
    String subscriptionType,
  ) async {
    try {
      log('🚨🚨🚨 updatePayedSubscription $subscriptionId $uid $amount $subscriptionType');
      var response = await _api.updateSubscriptionandAmounts(
          subscriptionId, uid, amount, subscriptionType);
      log('🚨🚨🚨 response ${response.response.statusCode}');
      if (response.response.statusCode == 200) {
        log('🚨🚨🚨 response ${response.response.data}');
        return const Right(true);
      }
      return const Left('Ha ocurrido un error al actualizar la suscripción');
    } catch (e) {
      log('🚨🚨🚨 updatePayedSubscription $e');
      return const Left('Ha ocurrido un error al actualizar la suscripción');
    }
  }

  @override
  Future<DataState<Subscription>> createSubscription(
      Subscription subscription, String uid) async {
    try {
      SubscriptionModel model =
          SubscriptionModel.fromEntity(subscription.copyWith(id: uid));

      var docRef = _firestore.collection(Collections.subscriptions).doc(uid);

      await docRef.set(model.toJson());

      return Right(model);
    } catch (e) {
      return const Left('Ha ocurrido un error al crear la suscripción');
    }
  }

  @override
  Future<DataState<Subscription>> getSubscription(String uid) async {
    try {
      var querySnapshot = await _firestore
          .collection(Collections.subscriptions)
          .where('id', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return const Left('No tienes una suscripción activa');
      }
      var subscription =
          SubscriptionModel.fromJson(querySnapshot.docs.first.data());
      return Right(subscription);
    } catch (e) {
      return const Left('Ha ocurrido un error al obtener la suscripción');
    }
  }

  @override
  Stream<DataState<Subscription>> listenSubscription(String uid) {
    return _firestore
        .collection(Collections.subscriptions)
        .where('id', isEqualTo: uid)
        .snapshots()
        .map((querySnapshot) {
      try {
        if (querySnapshot.docs.isEmpty) {
          return const Left('No tienes una suscripción activa');
        }
        SubscriptionModel model =
            SubscriptionModel.fromJson(querySnapshot.docs.first.data());
        return Right(model);
      } catch (e) {
        return Left('Ha ocurrido un error al obtener la suscripción $e');
      }
    });
  }

  @override
  Future<DataState<List<Patient>>> getActiveSubscriptions() async {
    try {
      var querySnapshot = await _firestore
          .collection(Collections.member)
          .where('memberInfo.subscriptionType',
              isNotEqualTo: SubscriptionType.none.index)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return const Left('No existen usuarios con una suscripción activa');
      }
      var patients = querySnapshot.docs
          .map((doc) => PatientModel.fromJson(doc.data()))
          .toList();
      log('🚨🚨🚨 patients $patients');
      return Right(patients);
    } catch (e) {
      log('🚨🚨🚨 ErrorGetActiveSubscriptions $e');
      return const Left('Ha ocurrido un error al obtener las suscripciones');
    }
  }
}
