import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/features/single_appointment/presentation/bloc/single_appointment_bloc.dart';
import 'package:medired/services/locator.dart';
import 'package:medired/ui/shared/footer.dart';
import 'package:medired/ui/views/create_appointment_page.dart';

class Servicios extends StatelessWidget {
  const Servicios({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SingleAppointmentBloc(sl(), sl(), sl())
            ..add(const UpdateServiceType(serviceType: null)),
        ),
        // BlocProvider(
        //   create: (context) =>
        //       SubscriptionBloc(sl(), sl(), sl(), sl(), sl(), sl()),
        // ),
      ],
      child: Center(
        child: TheFooter(
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
            child: const CreateAppointmentPage(),
          ),
        ),
      ),
    );
  }
}
