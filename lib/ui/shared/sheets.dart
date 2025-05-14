import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medired/core/value_objects/country.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:medired/ui/atoms/dropdown.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';
import 'package:medired/ui/shared/formbloque.dart';
import 'package:medired/ui/shared/location.dart';

class SheetAddress1 extends StatefulWidget {
  const SheetAddress1({super.key});

  @override
  State<SheetAddress1> createState() => _SheetsState();
}

class _SheetsState extends State<SheetAddress1> {
  //final bool isOpen;
  Address? address;
  Country selectedOption = Country.DO;

  final formKey = GlobalKey<FormState>();

  final TextEditingController provinceController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController streetController = TextEditingController();

  final TextEditingController zipController = TextEditingController();

  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    double sizewidth = device
        ? MediaQuery.of(context).size.width * 1.55
        : MediaQuery.of(context).size.width * 0.9;

    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileLoaded) {
        if (state.user is Patient) {
          var patient = state.user as Patient;
          if (patient.personalInfo.address.isNotEmpty) {
            address = patient.personalInfo.address.first;
          }
        } else if (state.user is ServiceProvider) {
          var serviceProvider = state.user as ServiceProvider;
          if (serviceProvider.personalInfo.address.isNotEmpty) {
            address = serviceProvider.personalInfo.address.first;
          }
        }


          if (address != null) {
            selectedOption = Country.values[address!.country];
            provinceController.text = address!.region;
            cityController.text = address!.city;
            streetController.text = address!.street;
            notesController.text = address!.notes;
          }
          return Padding(
            padding: EdgeInsets.only(top: device ? 70 : 46),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const ListTile(
                      title: Text('Dirección'),
                      leading: Icon(Icons.location_on),
                    ),
                    SizedBox(
                        width: device
                            ? (sizewidth * 0.55) * 0.8
                            : (sizewidth) * 0.8,
                        child: Column(
                          children: [
                            Row(children: [
                              Text(
                                'País',
                                style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: device
                                        ? (sizewidth * 0.45) * 0.029
                                        : (sizewidth) * 0.05,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.blueBackground),
                              ),
                            ]),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Dropdown<Country>(
                                  options: countryToString,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedOption = newValue ?? Country.DO;
                                    });
                                  },
                                  currentValue: selectedOption),

                        
                          ),
                        ],
                      )),
                  formbloque(context, 'Provincia o Región', provinceController,
                      formKey, sizewidth, false),
                  formbloque(context, 'Ciudad', cityController, formKey,
                      sizewidth, false),
                  formbloque(context, 'Calle', streetController, formKey,
                      sizewidth, false),
                  formbloque(context, 'Notas', notesController, formKey,
                      sizewidth, false,
                      hintText: 'Casa amarilla de dos plantas'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: SizedBox(
                      width:
                          device ? (sizewidth * 0.55) * 0.8 : (sizewidth) * 0.8,
                      child: Row(children: [
                        Text(
                          'Location',
                          style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: device
                                  ? (sizewidth * 0.45) * 0.029
                                  : (sizewidth) * 0.05,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blueBackground),
                        ),

                        //tienes que llamar un nuevo estado para getmaps
/*
                          Provider.of<AppStateManager>(contexts).getmaps() !=
                                  LatLng(0, 0)
                              ? Text(
                                  " ( " +
                                      Provider.of<AppStateManager>(contexts)
                                          .mapsglobal
                                          .latitude
                                          .toString() +
                                      " " +
                                      Provider.of<AppStateManager>(contexts)
                                          .mapsglobal
                                          .longitude
                                          .toString() +
                                      " )",
                                  style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: device
                                          ? (sizewidth * 0.45) * 0.009
                                          : (sizewidth) * 0.02,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.blueBackground),
                                )
                              : Text(""),*/
                      ]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await location(context);
                    },
                    child: SizedBox(
                      // 80% de la altura de la pantalla
                      child: Image(
                        width: device
                            ? (sizewidth * 0.55) * 0.8
                            : (sizewidth) * 0.8, // 40% del ancho de la pantalla
                        height: MediaQuery.of(context).size.height * 0.25,

                        image: const AssetImage('assets/images/maps.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: CustomFlatButton(
                      buttonColor: AppColors.blueBackground,
                      text: 'Actualizar',
                      onPressed: () {
                        context.read<ProfileBloc>().add(UpdateAddress(
                              country: selectedOption,
                              region: provinceController.text,
                              city: cityController.text,
                              street: streetController.text,
                              zip: zipController.text,
                              notes: notesController.text,
                            ));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      } else if (state is ProfileLoading) {
        return const CircularProgressIndicator();
      } else {
        return const SizedBox.shrink();
      }

      ////
    });
  }

  Dropdown<Country> dropdown(bool device, double sizewidth) {
    return Dropdown<Country>(
      /*  decoration: InputDecoration(
        //  icon: Icon(icon),
        filled: true,
        fillColor: Colors.white, // Fondo blanco
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
        ),
      ),
    */
      onChanged: (Country? newValue) {
        setState(() {
          selectedOption = newValue!;
        });
      },
      currentValue: selectedOption,
      options: countryToString,
    );
  }
}
/*
  DropdownButtonFormField<Country> dropdown(bool device, double sizewidth) {

    return DropdownButtonFormField<Country>(
      decoration: InputDecoration(
        //  icon: Icon(icon),
        filled: true,
        fillColor: Colors.white, // Fondo blanco
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
        ),
      ),
      value: selectedOption,
      onChanged: (Country? newValue) {
        setState(() {
          selectedOption = newValue!;
        });
      },
      items: stringToCountry.entries.map((entry) {
        return DropdownMenuItem<Country>(
          value: entry.value,
          child: Text(
            entry.key,
            style: entry.value != Country.select
                ? TextStyle(
                    fontSize: device
                        ? (sizewidth * 0.2) * 0.06
                        : (sizewidth * 0.8) * 0.06,
                    color: AppColors.blueBackground,
                    fontWeight: FontWeight.bold,
                  )
                : null,
          ),
        );
      }).toList(),
      icon: selectedOption == Country.select
          ? const Icon(Icons.check,
              color: Colors
                  .blue) // Ícono de check azul cuando se selecciona una opción
          : const Icon(Icons
              .arrow_drop_down), // Ícono de flecha hacia abajo predeterminado cuando no se ha seleccionado ninguna opción
    );
  }
}*/ 