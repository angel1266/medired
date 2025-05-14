import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_flex.dart';

class InsuranceCard extends StatelessWidget {
  final String membershipNumber;
  final String membershipType;
  final String idnumber;
  final String name;
  final double width;
  final double titlesize;
  final double textsize;

  const InsuranceCard({
    super.key,
    required this.membershipNumber,
    required this.membershipType,
    required this.idnumber,
    required this.name,
    required this.width,
    required this.textsize,
    required this.titlesize,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: titlesize,
    );

    final textStyle = TextStyle(
      color: AppColors.blueBackground,
      fontWeight: FontWeight.bold,
      fontSize: textsize,
      letterSpacing: 2,
    );

    return Container(
      width: width, // Ancho del carnet de seguros

      padding: width > 400 ? const EdgeInsets.all(16) : const EdgeInsets.all(0),

      //padding: EdgeInsets.fromLTRB(16, 16, 16, 0),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2, // No se propaga en ninguna dirección
            blurRadius: 8,
            offset: const Offset(5, 6),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo.png', // Ruta de la imagen del logo de la empresa
              // width: 80,
              //height: 80,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFlex(
                      direction: Axis.horizontal,
                      separation: 20,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nombre',
                              style: titleStyle,
                            ),
                            Text(
                              name,
                              style: textStyle,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Número de Membresía:',
                              style: titleStyle,
                            ),
                            Text(
                              membershipNumber,
                              style: textStyle,
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomFlex(
                      direction: Axis.horizontal,
                      separation: 20,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cédula:',
                              style: titleStyle,
                            ),
                            Text(
                              idnumber,
                              style: textStyle,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipo de Membresía:',
                              style: titleStyle,
                            ),
                            Text(
                              membershipType,
                              style: textStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                /*MediaQuery.of(context).size.width > 560
                    ? ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color.fromARGB(
                            255,
                            215,
                            219,
                            226,
                          ), // Your color
                          BlendMode
                              .srcIn, // This blend mode will replace the SVG's color
                        ),
                        child: SvgPicture.asset(
                          'assets/images/mano.svg',
                          // height: 76, // Adjust the height as needed
                        ),
                      )
                    : const SizedBox(),*/
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
