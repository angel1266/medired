import 'package:flutter/material.dart';
import 'package:medired/ui/molecules/profile_picture.dart';

class ServiceProviderCard extends StatelessWidget {
  const ServiceProviderCard({
    required this.medicalSpecialization,
    required this.name,
    this.photoUrl,
    super.key,
  });
  final String? photoUrl;
  final String name;
  final String medicalSpecialization;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePicture(
              membresia: "",
              suscripcion: [],
              photoUrl: photoUrl,
            ),
            Text(
              medicalSpecialization,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 28,
                  fontWeight: FontWeight.normal,
                  color: Color.fromRGBO(
                    142,
                    154,
                    185,
                    1,
                  )),
            ),
            Text(
              name,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Color.fromRGBO(95, 125, 201, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
