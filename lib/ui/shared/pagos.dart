import 'package:flutter/material.dart';
import 'package:medired/core/value_objects/subscription_type.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:medired/ui/shared/button_image_top.dart';
import 'package:medired/ui/shared/custom_flat_buttonsize.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/ui/shared/tipo_pago.dart';

import 'targetadebito.dart';

class Historialdepagos extends StatefulWidget {
  const Historialdepagos({super.key});

  @override
  State<Historialdepagos> createState() => _HistorialdepagosState();
}

String priceID = 'price_1Ns7nYIL54f4qZnBqSB2Ox4g';

class _HistorialdepagosState extends State<Historialdepagos> {
  TextEditingController numerotargetaController = TextEditingController();
  TextEditingController nombretargetaController = TextEditingController();
  TextEditingController fechamesController = TextEditingController();
  TextEditingController fechayearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  TextEditingController codigomembresiaController = TextEditingController();

  String menbernumber = 'MNP1308';
  bool guardarTarjeta = false;
  double tipoPago = 500;

  int selectedindex = 0; // El índice del botón seleccionado

  List<Widget> metodo = [];
  change(bool? value) {
    {
      setState(() {
        guardarTarjeta = value!;
      });
    }
  }

  Future<List<Widget>> createPaymentWidgetsList() async {
    AuthBloc bloc = context.read<AuthBloc>();
    List<Widget> targetasdepago = [];
    if (bloc.state is AuthenticatedState) {
      // for (var payment in lista) {
      //   final numeropago = payment['object']['id'];
      //   final fechapago = DateTime.fromMillisecondsSinceEpoch(
      //           payment['object']['created'] * 1000)
      //       .toLocal()
      //       .toString();
      //   final nombrepago = payment['object']['description'];
      //   const locationpago =
      //       ''; // Agrega el campo de ubicación si está disponible
      //   const tipopago =
      //       'Suscripción'; // Agrega el tipo de pago si está disponible
      //   final cantidadpago =
      //       (payment['object']['amount'] / 100).toStringAsFixed(2);

      //   final targetapago = Targetapagos(
      //     numeropago: numeropago,
      //     fechapago: fechapago,
      //     nombrepago: nombrepago,
      //     locationpago: locationpago,
      //     tipopago: tipopago,
      //     cantidadpago: '$cantidadpago USD',
      //   );
      //   targetasdepago.add(targetapago);
      // }
      return targetasdepago;
    }
    return targetasdepago;
  }

  Future<void> loadPaymentWidgetsList() async {
    try {
      // final List<Widget> paymentWidgets = await createPaymentWidgetsList();
      // setState(() {
      //   targetasdepago = paymentWidgets;
      // });
    } catch (error) {
      // Manejo de errores, por ejemplo, mostrar un mensaje de error
    }
  }

  @override
  void initState() {
    super.initState();
    //loadPaymentWidgetsList();
  }

  typePago(int value) {
    {
      setState(() {
        switch (value) {
          case 0:
            tipoPago = 500 * 1;
            priceID = 'price_1Ns7nYIL54f4qZnBqSB2Ox4g';
            break;
          case 1:
            tipoPago = 500 * 3;
            priceID = 'price_1Nthy6IL54f4qZnBn9g7QvrW';
            break;
          case 2:
            tipoPago = 500 * 6;
            priceID = 'price_1NthyNIL54f4qZnBwHrZ86cz';
            break;
          case 3:
            tipoPago = 500 * 12;
            priceID = 'price_1NthyZIL54f4qZnBsQxbm1eu';
            break;
          default:
        }
      });
    }
  }

  void actualizar() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // tasasasas
    double width = MediaQuery.of(context).size.width;

    bool device = context.screenType() == ScreenType.desktop;
    metodo = [
      TargetaDebito(
          tipopago: 'RD\$$tipoPago',
          device: device,
          width: width,
          numerotargetaController: numerotargetaController,
          nombretargetaController: nombretargetaController,
          fechamesController: fechamesController,
          fechayearController: fechayearController,
          cvvController: cvvController,
          guardarTarjeta: guardarTarjeta,
          context: context,
          onchances: change,
          type: typePago,
          pago: tipoPago.toString(),
          loadpayments: loadPaymentWidgetsList,
          actualizar: actualizar),
      trasferencias(
        width,
        device,
        typePago,
        tipoPago.toString(),
      ),
    ];
    // while (gettarjetasdepago().length < 3) {
    //   targetasdepago.add(DottedBorder(
    //     borderType: BorderType.RRect,
    //     radius: const Radius.circular(15),
    //     color: Colors.blueGrey.shade300,
    //     dashPattern: const [15],
    //     strokeWidth: 3.5,
    //     child: Container(
    //       width: width * 0.30,
    //       height: 210,
    //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
    //     ),
    //   )); // Agregar contenedores transparentes
    // }
    return device
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: pagoscontents(width, context),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: pagoscontents(width, context),
          );
  }

  List<Widget> pagoscontents(double width, BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    AuthBloc authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthenticatedState<Patient>) {
      Patient patient = (authBloc.state as AuthenticatedState<Patient>).user;
      String names = patient.personalInfo.firstName
          .split(' ')
          .map((word) => word[0])
          .join();
      String uid =
          patient.authInfo.uid!.substring(patient.authInfo.uid!.length - 4);
      if (patient.memberInfo.subscriptionType != SubscriptionType.mensual) {
        menbernumber = '$names$uid';
      } else {
        menbernumber = 'INACTIVO';
      }
    } else {
      ServiceProvider serviceProvider =
          (authBloc.state as AuthenticatedState<ServiceProvider>).user;
      String names = serviceProvider.personalInfo.firstName
          .split(' ')
          .map((word) => word[0])
          .join();
      String uid = serviceProvider.authInfo.uid!
          .substring(serviceProvider.authInfo.uid!.length - 4);
      if (serviceProvider.memberInfo.subscriptionType !=
          SubscriptionType.mensual) {
        menbernumber = '$names$uid';
      } else {
        menbernumber = 'INACTIVO';
      }
    }
    return [
      Container(
        width: device ? width * 0.56 : width,
        //height: 1100,
        decoration: BoxDecoration(
          //  color: AppColors.lightBorder.withOpacity(0.6),
          borderRadius: BorderRadius.circular(width * 0.040),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Text(
                  'Método de pago',
                  style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: device ? (width * 0.56) * 0.08 : (width) * 0.08,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: device ? (width * 0.56) * 0.4 : (width) * 0.4,
                    child: Center(
                      child: selectorview2(
                          'Debit Card',
                          selectedindex == 0
                              ? AppColors.greenBackground
                              : Colors.transparent,
                          selectedindex == 0
                              ? Colors.white
                              : AppColors.greenBackground,
                          'targeta1.svg', () {
                        // Cambia el estado al hacer clic
                        setState(() {
                          selectedindex = 0;
                        });
                      }, width * 0.2, 28),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    width: device ? (width * 0.56) * 0.4 : (width) * 0.4,
                    child: Center(
                      child: selectorview2(
                          'Tranferencias',
                          selectedindex == 1
                              ? AppColors.greenBackground
                              : Colors.transparent,
                          selectedindex == 1
                              ? Colors.white
                              : AppColors.greenBackground,
                          'mano.svg', () {
                        setState(() {
                          selectedindex = 1;
                        });
                      }, width * 0.2, 28),
                    ),
                  ),
                ],
              ),
              metodo[selectedindex]
            ],
          ),
        ),
      ),
      Container(
        width: device ? width * 0.4 : width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width * 0.040),
        ),
        // height: 1100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Text(
                'Código de membresía',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: device ? (width * 0.56) * 0.06 : (width) * 0.06,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: AppColors.blueBackground),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Text(
                menbernumber,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: device ? (width * 0.56) * 0.07 : (width) * 0.07,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: AppColors.blueBackground),
              ),
            ),
            /* formbloque(context, " ", codigomembresiaController, formKey,
                width * 0.7, false),*/
            /*GestureDetector(
              onTap: () {},
              child: Text(
                "Cambiar membresía aqui",
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0,
                    fontFamily: 'Outfit',
                    fontSize: device ? (width * 0.56) * 0.03 : (width) * 0.05,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: AppColors.greenBackground),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                width: device ? width * 0.35 : width,
                //   height: 810,
                decoration: BoxDecoration(
                  //   color: AppColors.lightBorder.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(width * 0.020),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'Historial de pagos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize:
                                device ? (width * 0.56) * 0.05 : (width) * 0.07,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: AppColors.blueBackground),
                      ),
                    ),
                    SizedBox(
                      width: device ? width * 0.29 : width * 0.85,
                      height: 700,
                      child: ListView.builder(
                        shrinkWrap:
                            true, // Para ajustar la altura del ListView al contenido
                        itemCount: 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(color: Colors.red),
                          );
                        },
                      ),
                    ),
                    /*  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 25),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey, // Color de la sombra
                              offset: Offset(
                                  0, 4), // Desplazamiento horizontal y vertical
                              blurRadius:
                                  6, // Radio del desenfoque de la sombra
                              spreadRadius:
                                  2, // Radio de expansión de la sombra
                            ),
                          ],
                        ),
                        child: CustomFlatButtonsize(
                          width: device ? width * 0.29 : width * 0.9,
                          height: 60,
                          text: "Ver Detalle",
                          fontSize:
                              device ? (width * 0.4) * 0.04 : (width) * 0.05,
                          onPressed: () {},
                          textColor: AppColors.blueBackground,
                          buttonColor: AppColors.lightBackground.withGreen(255),
                        ),
                      ),
                    )*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}

Widget trasferencias(
  double width,
  bool device,
  Function(int) type,
  String pago,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Center(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Image(
            image: const AssetImage('assets/images/logo.png'),
            width: device ? width * 0.29 : width * 0.70,
          ),
        ),
      ),
      SizedBox(
        width: device ? width * 0.45 : width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Banco BHD',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                    fontSize: device ? width * 0.025 : width * 0.09,
                    color: Colors.white),
              ),
            ),
            Text(
              'Nombre de la Empresa',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  fontSize: device ? width * 0.0145 : width * 0.0800,
                  color: const Color.fromRGBO(95, 125, 201, 1)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'General Medical Processing GMP, S.R.L.',
                textAlign: TextAlign.left,
                softWrap: false,
                style: TextStyle(
                    wordSpacing: 0,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.normal,
                    fontSize: device ? width * 0.04 : width * 0.09,
                    color: Colors.white),
              ),
            ),
            Text(
              'Número de cuenta',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  fontSize: device ? width * 0.0145 : width * 0.0800,
                  color: const Color.fromRGBO(95, 125, 201, 1)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                '33536510019',
                textAlign: TextAlign.left,
                softWrap: false,
                style: TextStyle(
                    wordSpacing: 0,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.normal,
                    fontSize: device ? width * 0.04 : width * 0.09,
                    color: Colors.white),
              ),
            ),
            Text(
              'Tipo de cuenta',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  fontSize: device ? width * 0.0145 : width * 0.0800,
                  color: const Color.fromRGBO(95, 125, 201, 1)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                'Corriente',
                textAlign: TextAlign.left,
                softWrap: false,
                style: TextStyle(
                    wordSpacing: 0,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.normal,
                    fontSize: device ? width * 0.035 : width * 0.09,
                    color: Colors.white),
              ),
            ),
            Text(
              'RNC',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  fontSize: device ? width * 0.0145 : width * 0.0800,
                  color: const Color.fromRGBO(95, 125, 201, 1)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                '1-32-75187-6',
                textAlign: TextAlign.left,
                softWrap: false,
                style: TextStyle(
                    wordSpacing: 0,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.normal,
                    fontSize: device ? width * 0.04 : width * 0.09,
                    color: Colors.white),
              ),
            ),
            Text(
              'Dirección',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  fontSize: device ? width * 0.0145 : width * 0.0800,
                  color: const Color.fromRGBO(95, 125, 201, 1)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Av. Tiradentes, Naco, Distrito Nacional, RD',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.normal,
                    fontSize: device ? (width) * 0.03 : (width) * 0.09,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              //// aqui el pago y quitar los tiempo depende del baken hacer el apoiment
              child: tiempos(device, width, type, pago),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey, // Color de la sombra
                        offset: Offset(
                            0, 4), // Desplazamiento horizontal y vertical
                        blurRadius: 6, // Radio del desenfoque de la sombra
                        spreadRadius: 2, // Radio de expansión de la sombra
                      ),
                    ],
                  ),
                  child: CustomFlatButtonsize(
                    circularRadius: 10,
                    verticalPadding: 5,
                    fontSize: device ? 20 : 15,
                    width: device ? width * 0.40 : width * 0.9,
                    text: 'ENVIAR COMPROBANTE',
                    onPressed: () {},
                    textColor: AppColors.blueBackground,
                    buttonColor: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ],
  );
}

Column tiempos(bool device, double width, Function(int) type, String pago) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: device ? (width * 0.55) * 0.6 : (width) * 0.6,
        child: Row(
          children: [
            Text(
              'Tipo de Pago',
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: device ? (width) * 0.015 : (width) * 0.1,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      SizedBox(
        width: device ? width * 0.45 : width * 0.9,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: TypePago(
            device: device,
            width: width,
            callback: type,
          ),
        ),
      ),
      SizedBox(
        width: device ? (width * 0.55) * 0.6 : (width) * 0.8,
        child: Row(
          children: [
            Text(
              'Saldo a Pagar',
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: device ? (width) * 0.015 : (width) * 0.1,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: device ? (width * 0.55) * 0.6 : (width) * 0.9,
          child: Row(
            children: [
              Text(
                '\$RD$pago.0',
                style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: device ? (width) * 0.015 : (width) * 0.1,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greenBackground),
              )
            ],
          ),
        ),
      ),
    ],
  );
}
