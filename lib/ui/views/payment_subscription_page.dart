import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/bloc/message/message_bloc.dart';
import 'package:medired/core/utils/responsive.dart';
import 'package:medired/core/value_objects/pay_frequency.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:medired/features/payments/presentation/bloc/payments_bloc.dart';
import 'package:medired/features/points/presentation/bloc/points_bloc.dart';
import 'package:medired/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:medired/services/locator.dart';
import 'package:medired/ui/atoms/base_form_field.dart';
import 'package:medired/ui/atoms/dropdown.dart';
import 'package:medired/ui/organisms/payment_form.dart';

class PaymentSubscriptionPage extends StatefulWidget {
  const PaymentSubscriptionPage({super.key, required this.auth});

  final Patient auth;

  @override
  State<PaymentSubscriptionPage> createState() =>
      _PaymentSubscriptionPageState();
}

class _PaymentSubscriptionPageState extends State<PaymentSubscriptionPage> {
  int amount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona una suscripción'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseFormField(
              const Text(
                'Tipo de pago',
                style: TextStyle(color: Colors.white),
              ),
              formField: Dropdown(
                options: payFrequency2String,
                onChanged: (z) async {
                  setState(() {
                    switch (z) {
                      case PayFrequency.monthly:
                        amount = 500;
                        break;
                      case PayFrequency.quarterly:
                        amount = 1500;
                        break;
                      case PayFrequency.semiAnnual:
                        amount = 3000;
                        break;
                      case PayFrequency.annual:
                        amount = 6000;
                        break;
                      default:
                        amount = 50;
                        break;
                    }
                  });

                  var result = await showAdaptiveSheet(
                      context: context,
                      body: Builder(builder: (context) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<SubscriptionBloc>(
                                create: (context) => SubscriptionBloc(
                                    sl(), sl(), sl(), sl(), sl(), sl(), sl())),
                            BlocProvider(
                              create: (context) => PaymentBloc(sl(), sl(), sl(),
                                  sl(), sl(), sl(), sl(), sl(), sl()),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  PaymentsBloc(sl(), sl(), sl()),
                            ),
                            BlocProvider(
                              create: (context) => PointsBloc(sl(), sl()),
                            ),
                          ],
                          child: PaymentForm(auth: widget.auth, amount: amount),
                        );
                      }),
                      bottomSheetHeight: 0.8);
                  if (!mounted) return;

                  if (result) {
                    context
                        .read<MessageBloc>()
                        .add(const DisplayMessage('Pago exitoso'));
                    Navigator.pop(context, true);
                  }
                },
                currentValue: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
