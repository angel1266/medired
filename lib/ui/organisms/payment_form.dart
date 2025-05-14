import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:medired/core/bloc/message/message_bloc.dart';
import 'package:medired/core/value_objects/transaction_type.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/payment/domain/entities/payment.dart';
import 'package:medired/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:medired/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:medired/features/points/presentation/bloc/points_bloc.dart';
import 'package:medired/features/subscription/presentation/bloc/subscription_bloc.dart';

import 'package:universal_html/html.dart' as uhtml;
import 'dart:ui_web' as ui_web;

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key, required this.auth, required this.amount});
  final Patient auth;
  final int amount;

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  Payment? _currentPayment;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<PaymentsBloc>()
          .add(StartListeningPayments(uid: widget.auth.authInfo.uid!));
      context.read<PaymentBloc>().add(PayTest(
            amount: widget.amount,
            pass: ':5=9%GFa%7DlJ3',
            uid: widget.auth.authInfo.uid!,
            transactionType: TransactionType.subscription,
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PaymentBloc, PaymentState>(
          listener: _paymentListener,
        ),
        BlocListener<PaymentsBloc, PaymentsState>(
          listener: _paymentsListener,
        ),
        BlocListener<SubscriptionBloc, SubscriptionState>(
          listener: _subscriptionListener,
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text('Monto a pagar',
                style: TextStyle(color: Color.fromARGB(255, 134, 124, 124))),
            BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                if (state is SuccessUpdateSession) {
                  return Text(
                    'RD\$${state.session.amount}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 15),
            BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                if (state is UnloadedPayment) {
                  return const SizedBox.shrink();
                } else if (state is SuccessUpdateSession) {
                  ui_web.platformViewRegistry.registerViewFactory(
                      'payment-${DateTime.now().millisecondsSinceEpoch}',
                      (int viewId) => uhtml.IFrameElement()
                        ..width = '640'
                        ..height = '360'
                        ..src = state.url
                        ..style.border = 'none');
                }
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: state is SuccessUpdateSession ? 300 : 35,
                  child: state is SuccessUpdateSession
                      ? HtmlElementView(
                          viewType:
                              'payment-${DateTime.now().millisecondsSinceEpoch}',
                          key: UniqueKey())
                      : const CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _paymentListener(BuildContext context, PaymentState state) {
    if (state is SuccessTestCardnetPayment) {
      context.read<PaymentBloc>().add(SaveSession(
            uid: widget.auth.authInfo.uid!,
            session: state.cardnetSession.session,
            sessionKey: state.cardnetSession.sessionKey,
            amount: state.amount,
          ));
    } else if (state is SuccessSendEmail) {
      // _paymentBloc.add(const SendEmail(
      //     to: 'info@gmp.do', subject: 'Contacto: ', body: 'texto'));
    } else if (state is SuccessSaveSession) {
      context.read<PaymentBloc>().add(UpdateSession(
            patient: widget.auth,
            session: state.session,
          ));
    } else if (state is SuccessValidatePayment) {
      context.read<PointsBloc>().add(SavePoints(
            uid: widget.auth.authInfo.uid!,
            amount: widget.amount ~/ 100,
          ));
      Navigator.pop<bool>(context, true);
      context.read<PaymentBloc>().add(RestartPayment());
    } else if (state is SuccessUpdateSession) {
      context.read<SubscriptionBloc>().add(ListenSubscription(
            uid: state.patient.authInfo.uid!,
          ));
    }
    // else if (state is SuccessUpdateSubscriptionType) {
    //   _currentPayment = state.payment;
    // }
    else if (state is ErrorPayment) {}
  }

  void _paymentsListener(BuildContext context, PaymentsState state) {
    if (state is SuccessStartListeningPayments) {
      context.read<PaymentsBloc>().add(const ListenLastUnprocessedPayment());
    } else if (state is SuccessListenPayments) {
      _currentPayment = state.payment;
      context
          .read<SubscriptionBloc>()
          .add(GetSubscription(uid: widget.auth.authInfo.uid!));
    } else if (state is ErrorPayments) {
      if (state is! ErrorListenPayments) {
        context.read<MessageBloc>().add(DisplayMessage(state.error));
      }
    }
  }

  void _subscriptionListener(BuildContext context, SubscriptionState state) {
    if (state is SuccessUpdatePaymentSubscription) {
      if (_currentPayment != null) {
        context.read<PaymentBloc>().add(ValidatePayment(
              payment: _currentPayment!,
            ));
      }

      // context.read<PaymentBloc>().add(UpdateSubscriptionType(
      //       patient: widget.auth,
      //       subscriptionType: state.subscriptionType,
      //       payment: state.payment,
      //     ));
    } else if (state is SuccessGetSubscription) {
      if (_currentPayment != null) {
        context.read<SubscriptionBloc>().add(UpdatePaymentSubscription(
              payFrequency: _currentPayment!.payFrequency,
              uid: state.subscription.uid,
              subscriptionId: state.subscription.id,
              payment: _currentPayment!,
            ));
      }
    } else if (state is ErrorUpdatePaymentSubscription) {
      context.read<MessageBloc>().add(DisplayMessage(state.message));
    }
  }
}
