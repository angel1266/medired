import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/features/authentication/data/models/session_model.dart';
import 'package:medired/features/authentication/domain/entities/session.dart';
import 'package:medired/features/authentication/domain/entities/transaction_response.dart';
import 'package:medired/features/payment/data/ds/cardnet_ds.dart';
import 'package:medired/features/payment/data/ds/payment_ds.dart';
import 'package:medired/features/payment/data/models/payment_model.dart';
import 'package:medired/features/payment/domain/entities/cardnet_session.dart';
import 'package:medired/features/payment/domain/entities/payment.dart';

abstract class PaymentRepo {
  Future<DataState<CardnetSession>> postToCardnet(String amount, String pass);
  Future<DataState<TransactionResponse>> getResponseCode(
      String session, String sessionKey);
  Future<DataState<CardnetSession>> postTestToCardnet(
      String amount, String pass, String uid, int transactionType);
  Future<DataState<String>> sendEmail(String to, String subject, String text);
  Future<DataState<String>> getTestResponseCode(
      String session, String sessionKey);
  Future<DataState<Unit>> savePayment(
    String uid,
    DateTime date,
    String responseCode,
    String txToken,
    String referenceNumber,
    String authorizationCode,
  );

  Future<DataState<Session>> saveSession(
    String uid,
    String session,
    String sessionKey,
    String amount,
  );

  Stream<DataState<Payment>> listenLastUnprocessedPayment(String uid);

  Future<DataState<Unit>> validatePayment(String id);
}

class PaymentRepoImpl implements PaymentRepo {
  final PaymentDs _api;
  final CardNetDs _cardNetApi;
  final FirebaseFirestore _firestore;

  PaymentRepoImpl(this._api, this._firestore, this._cardNetApi);

  @override
  Future<DataState<TransactionResponse>> getResponseCode(
      String session, String sessionKey) async {
    try {
      final response =
          await _cardNetApi.getTransactionResponse(session, sessionKey);
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<DataState<String>> getTestResponseCode(
      String session, String sessionKey) async {
    try {
      final response = await _api.getTestResponseCode(session, sessionKey);
      if (response.response.statusCode == HttpStatus.ok) {
        return Right(response.data);
      } else {
        return Left(response.response.statusCode.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<DataState<CardnetSession>> postTestToCardnet(
      String amount, String pass, String uid, int transactionType) async {
    try {
      final response =
          await _api.postTestToCardnet(amount, pass, uid, transactionType);
      if (response.response.statusCode == HttpStatus.ok) {
        return Right(response.data);
      } else {
        return Left(response.response.statusCode.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<DataState<CardnetSession>> postToCardnet(
      String amount, String pass) async {
    try {
      final response = await _api.postToCardnet(amount, pass);
      if (response.response.statusCode == HttpStatus.ok) {
        return Right(response.data);
      } else {
        return Left(response.response.statusCode.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<DataState<String>> sendEmail(
      String to, String subject, String text) async {
    try {
      final response = await _api.sendEmail(to, subject, text);
      if (response.response.statusCode == HttpStatus.ok) {
        return Right(response.data);
      } else {
        return Left(response.response.statusCode.toString());
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<DataState<Unit>> savePayment(
    String uid,
    DateTime date,
    String responseCode,
    String txToken,
    String referenceNumber,
    String authorizationCode,
  ) async {
    try {
      await _firestore.collection(Collections.payments).add({
        'uid': uid,
        'date': date,
        'responseCode': responseCode,
        'txToken': txToken,
        'referenceNumber': referenceNumber,
        'authorizationCode': authorizationCode,
      });
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<DataState<Session>> saveSession(
    String uid,
    String session,
    String sessionKey,
    String amount,
  ) async {
    try {
      var sessionObj = Session(
          uid: uid,
          session: session,
          sessionKey: sessionKey,
          amount: amount,
          status: 0,
          createdAt: DateTime.now());
      await _firestore
          .collection(Collections.sessions)
          .add(SessionModel.fromEntity(sessionObj).toJson());
      return Right(sessionObj);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Stream<DataState<Payment>> listenLastUnprocessedPayment(String uid) {
    return _firestore
        .collection(Collections.payments)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((querySnapshot) {
      try {
        if (querySnapshot.docs.isEmpty) {
          log('No payment found');
          return const Left('No payment found');
        }
        List<PaymentModel> payments = querySnapshot.docs
            .map((e) => PaymentModel.fromJson(e.data()))
            .toList();

        payments.sort((a, b) => b.date.compareTo(a.date));
        var mostRecentPayment = payments.first;
        if (mostRecentPayment.isProcessed) {
          return const Left('No payment found to process');
        } else {
          return Right(mostRecentPayment);
        }
      } on FirebaseException catch (error) {
        return Left(error.message ??
            'An error occurred while getting unprocessed payment');
      }
    });
  }

  @override
  Future<DataState<Unit>> validatePayment(String id) async {
    try {
      await _firestore
          .collection(Collections.payments)
          .doc(id)
          .update({'isProcessed': true});
      return const Right(unit);
    } catch (e) {
      return const Left('An error occurred while validating payment');
    }
  }
}
