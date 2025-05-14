import 'dart:async';

import 'package:medired/core/core_export.dart';
import 'package:medired/features/subscription/domain/entities/subscription.dart';
import 'package:medired/features/subscription/domain/repository/subscription_repo.dart';

abstract class SubscriptionService {
  Stream<DataState<Subscription>> listenToSubscription();
  void startListening(String uid);
  void stopListening();
}

class SubscriptionServiceImpl implements SubscriptionService {
  final SubscriptionRepo _repo;
  StreamController<DataState<Subscription>>? _controller;
  StreamSubscription<DataState<Subscription>>? _subscription;

  SubscriptionServiceImpl(this._repo);

  @override
  Stream<DataState<Subscription>> listenToSubscription() {
    _controller ??= StreamController<DataState<Subscription>>.broadcast();
    return _controller!.stream;
  }

  @override
  void startListening(String uid) {
    stopListening();
    _controller = StreamController<DataState<Subscription>>.broadcast();
    _subscription = _repo.listenSubscription(uid).listen((event) {
      _controller!.add(event);
    });
  }

  @override
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _controller?.close();
    _controller = null;
  }
}
