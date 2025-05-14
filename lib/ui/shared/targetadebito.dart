import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/value_objects/subscription_type.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/alert_helper.dart';
import 'package:medired/ui/shared/custom_flat_buttonsize.dart';
import 'package:medired/ui/shared/pagos.dart';

class TargetaDebito extends StatefulWidget {
  const TargetaDebito(
      {super.key,
      required this.tipopago,
      required this.device,
      required this.width,
      required this.numerotargetaController,
      required this.nombretargetaController,
      required this.fechamesController,
      required this.fechayearController,
      required this.cvvController,
      required this.guardarTarjeta,
      required this.context,
      required this.onchances,
      required this.type,
      required this.pago,
      required this.loadpayments,
      required this.actualizar});
  final bool device;
  final double width;
  final TextEditingController numerotargetaController;
  final TextEditingController nombretargetaController;
  final TextEditingController fechamesController;
  final TextEditingController fechayearController;
  final TextEditingController cvvController;
  final String tipopago;
  final bool guardarTarjeta;
  final BuildContext context;
  final Function(bool?) onchances;
  final Function(int) type;
  final String pago;
  final Function() loadpayments;

  final Function() actualizar;
  @override
  State<TargetaDebito> createState() => _TargetaDebitoState();
}

class _TargetaDebitoState extends State<TargetaDebito> {
  @override
  Widget build(BuildContext context) {
    showAlert(String message) {
      var alertHelper = AlertHelper();
      alertHelper.show((message), context);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: widget.device ? widget.width * 0.45 : widget.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              SizedBox(
                width: widget.device
                    ? (widget.width * 0.55) * 0.6
                    : (widget.width) * 0.8,
                child: Row(
                  children: [
                    Text(
                      'Número de la tarjeta',
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: widget.device
                              ? (widget.width) * 0.015
                              : (widget.width) * 0.08,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SizedBox(
                  width: widget.device ? (widget.width * 0.55) : (widget.width),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: widget.numerotargetaController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightBorder.withOpacity(1),
                      labelStyle: const TextStyle(fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none, // No border
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none, // No border
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    cursorColor: Colors.blue, // Cambio de color de cursor
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Rellena este campo';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: widget.device
                    ? (widget.width * 0.55) * 0.6
                    : (widget.width) * 0.8,
                child: Row(
                  children: [
                    Text(
                      'Nombre en la tarjeta',
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: widget.device
                              ? (widget.width) * 0.015
                              : (widget.width) * 0.080,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SizedBox(
                  width: widget.device ? (widget.width * 0.55) : (widget.width),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: widget.nombretargetaController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightBorder.withOpacity(1),
                      labelStyle: const TextStyle(fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none, // No border
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none, // No border
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    cursorColor: Colors.blue, // Cambio de color de cursor
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Rellena este campo';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: widget.device
                          ? (widget.width) * 0.14
                          : (widget.width) * 0.28,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.device
                                    ? 'Fecha de expiracíon'
                                    : 'Expiracíon',
                                style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: widget.device
                                        ? (widget.width) * 0.014
                                        : (widget.width) * 0.040,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: SizedBox(
                              width: widget.device
                                  ? (widget.width * 0.55)
                                  : (widget.width),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: widget.fechamesController,
                                decoration: InputDecoration(
                                  hintText: 'Mes',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(33, 57, 118, 0.4)),
                                  filled: true,
                                  fillColor:
                                      AppColors.lightBorder.withOpacity(1),
                                  labelStyle: const TextStyle(fontSize: 12),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none, // No border
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none, // No border
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                cursorColor:
                                    Colors.blue, // Cambio de color de cursor
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Rellena este campo';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    width: widget.device
                        ? (widget.width) * 0.14
                        : (widget.width) * 0.28,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: SizedBox(
                        width: widget.device
                            ? (widget.width * 0.55)
                            : (widget.width),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: widget.fechayearController,
                          decoration: InputDecoration(
                            hintText: 'Año',
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(33, 57, 118, 0.4)),
                            filled: true,
                            fillColor: AppColors.lightBorder.withOpacity(1),
                            labelStyle: const TextStyle(fontSize: 12),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none, // No border
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none, // No border
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          cursorColor: Colors.blue, // Cambio de color de cursor
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Rellena este campo';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: widget.device
                          ? (widget.width) * 0.14
                          : (widget.width) * 0.28,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'cvv',
                                style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: widget.device
                                        ? (widget.width) * 0.014
                                        : (widget.width) * 0.050,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: SizedBox(
                              width: widget.device
                                  ? (widget.width * 0.55)
                                  : (widget.width),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: widget.cvvController,
                                decoration: InputDecoration(
                                  hintText: '718',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(33, 57, 118, 0.4)),
                                  filled: true,
                                  fillColor:
                                      AppColors.lightBorder.withOpacity(1),
                                  labelStyle: const TextStyle(fontSize: 12),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none, // No border
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none, // No border
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                cursorColor:
                                    Colors.blue, // Cambio de color de cursor
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Rellena este campo';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 20),
              tiempos(widget.device, widget.width, widget.type, widget.pago),
              const SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      /*   boxShadow: const [
                   BoxShadow(
                        color: Colors.grey, // Color de la sombra
                        offset: Offset(
                            0, 4), // Desplazamiento horizontal y vertical
                        blurRadius: 6, // Radio del desenfoque de la sombra
                        spreadRadius: 2, // Radio de expansión de la sombra
                      ),
                    ],*/
                    ),
                    child: CustomFlatButtonsize(
                      circularRadius: 10,
                      verticalPadding: 5,
                      width: widget.device
                          ? widget.width * 0.40
                          : widget.width * 0.8,
                      textColor: AppColors.blueBackground,
                      text: 'Confirmar',
                      onPressed: () async {
                        ProfileBloc profileBloc = context.read<ProfileBloc>();
                        AuthBloc authBloc = context.read<AuthBloc>();
                        profileBloc.add(UpdateMemberSubscription(
                          subscriptionType: SubscriptionType.none,
                          uid: (authBloc.state as AuthenticatedState)
                              .user
                              .authInfo
                              .uid!,
                        ));
                        // final tarjeta = Targetapagos(
                        //     cantidadpago: widget.tipopago,
                        //     numeropago: 'FY9H&3v2',
                        //     fechapago: '10/09/2023',
                        //     nombrepago: 'Suscripción Mensual',
                        //     locationpago: 'Mastercard',
                        //     tipopago: 'Debito');
                        showAlert('Pago Completado');
                        widget.cvvController.text = '';
                        widget.fechamesController.text = '';
                        widget.fechayearController.text = '';
                        widget.nombretargetaController.text = '';
                        widget.numerotargetaController.text = '';
                        widget.actualizar();

                        //print(gettarjetasdepago());
                        /*
                      String numero = numerotargetaController.text;
                      String anio = fechayearController.text;
                      String mes = fechamesController.text;
                      String cvv = cvvController.text;
                      ProfileBloc bloc =
                          context.read<ProfileBloc>();
                      if (bloc.state is AuthenticatedState &&
                          (bloc.state as AuthenticatedState).user is User) {
                        User user = (bloc.state as AuthenticatedState).user as User;
                        final String email = user.email;
                        final customerID =
                            await getStripeCustomerByEmail(email);
                        final cardtoken = await createCardToken(
                            cardNumber: numero,
                            cardExpMonth: mes,
                            cardExpYear: anio,
                            cardCvc: cvv);
                        final paymentMethod =
                            await createPaymentMethod(cardToken: cardtoken);
                        await attachPaymentMethodToCustomer(
                            customerId: customerID,
                            paymentMethodId: paymentMethod);
                        await createStripeSubscription(
                            customerId: customerID,
                            priceId: priceID,
                            paymentmethod: paymentMethod);
                        await loadpayments();
                      }*/
                      },
                      buttonColor: AppColors.lightBackground,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
