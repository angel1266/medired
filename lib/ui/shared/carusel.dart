import 'package:carousel_slider/carousel_slider.dart' as carrusel;
import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';

class Carusel extends StatefulWidget {
  const Carusel({super.key, required this.size});
  final Size size;

  @override
  State<Carusel> createState() => _CaruselState();
}

class _CaruselState extends State<Carusel> {
  int currentIndex = 0;

  final carrusel.CarouselController controller = carrusel.CarouselController();

  @override
  void initState() {
    super.initState();
    /* for (var element in imageTypeToString.entries) {
      childs.add(slide1(element.value));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> childs = [
      imagen(context, 'carusel1.png'),
      imagen(context, 'carusel5.png'),
      imagen(context, 'carusel6.png'),
      imagen(context, 'carusel7.png'),
      imagen(context, 'carusel8.png'),
    ];

    var caruoselHeight = (MediaQuery.of(context).size.width * 227) / 480;
    var carouselViewport = 1.2;
    if (caruoselHeight > MediaQuery.of(context).size.height / 2) {
      caruoselHeight = MediaQuery.of(context).size.height / 2;
      carouselViewport = 0.6;
    }

    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              carrusel.CarouselSlider(
                carouselController: controller,
                items: childs,
                options: carrusel.CarouselOptions(
                  height: ((MediaQuery.of(context).size.width > 500) ? 500 : caruoselHeight),
                  aspectRatio: 480 / 227,
                  viewportFraction: carouselViewport,
                  initialPage: 0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 900),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index; // Actualiza el índice actual
                    });
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Positioned(
                left: 0,
                child: IconButton(
                  onPressed: () {
                    controller.jumpToPage((currentIndex - 1) % childs.length);
                  },
                  icon: const Icon(
                    Icons.arrow_circle_left_outlined,
                    color: AppColors.blueBackground,
                  ),
                  iconSize: 50,
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {
                    controller.jumpToPage((currentIndex + 1) % childs.length);
                  },
                  icon: const Icon(
                    Icons.arrow_circle_right_outlined,
                    color: AppColors.blueBackground,
                  ),
                  iconSize: 50,
                ),
              ),
            ],
          ),
        ),
        Container(
          //color: AppColors.blueBackground,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List<Widget>.generate(
                  childs.length,
                  (index) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        controller.jumpToPage(index);
                      }),
                      child: Container(
                        width: 15,
                        height: 15,
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentIndex == index
                                ? Colors.blue
                                : Colors.white
                            //const Color.fromARGB(255, 255, 255, 255),
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget slide1(bool device) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          const Image(
            image: AssetImage('assets/images/fondo2.png'),
            fit: BoxFit.cover,
          ),
          Expanded(
            child: device
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: contents(device),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: contents(device),
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> contents(bool device) {
    return device
        ? [
            const Spacer(),
            texts(device),
            const Spacer(),
            device
                ? const Image(
                    image: AssetImage('assets/images/chica1.png'),
                    fit: BoxFit.contain,
                  )
                : const SizedBox(),
            const Spacer(),
          ]
        : [
            const Spacer(),
            texts(device),
            /*
            images(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.6),*/
            const Spacer(),
          ];
  }

  Widget texts(bool device) {
    return Row(
      mainAxisAlignment:
          device ? MainAxisAlignment.end : MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.blueBackground,
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.005)),
                    child: Icon(
                      Icons.check,
                      size: device
                          ? MediaQuery.of(context).size.width * 0.04
                          : MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Atención Médica de Calidad:',
                      style: TextStyle(
                        color: AppColors.blueBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: device
                            ? (MediaQuery.of(context).size.width * 0.05) * 0.5
                            : (MediaQuery.of(context).size.width * 0.04),
                        letterSpacing: 0.03,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    Text(
                      'Acceso a cuidados de salud',
                      style: TextStyle(
                        color: AppColors.blueBackground,
                        fontWeight: FontWeight.normal,
                        fontSize: device
                            ? (MediaQuery.of(context).size.width * 0.037) * 0.5
                            : (MediaQuery.of(context).size.width * 0.03),
                        letterSpacing: 0.03,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    Text(
                      'excepcionales con profesionales',
                      style: TextStyle(
                        color: AppColors.blueBackground,
                        fontWeight: FontWeight.normal,
                        fontSize: device
                            ? (MediaQuery.of(context).size.width * 0.037) * 0.5
                            : (MediaQuery.of(context).size.width * 0.03),
                        letterSpacing: 0.03,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    Text(
                      'altamente calificados.',
                      style: TextStyle(
                        color: AppColors.greenBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: device
                            ? (MediaQuery.of(context).size.width * 0.037) * 0.5
                            : (MediaQuery.of(context).size.width * 0.04),
                        letterSpacing: 0.03,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: device
                  ? MediaQuery.of(context).size.height * 0.05
                  : MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.blueBackground,
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.005)),
                    child: Icon(
                      Icons.check,
                      size: device
                          ? MediaQuery.of(context).size.width * 0.04
                          : MediaQuery.of(context).size.width * 0.06,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ahorro en Gastos Médicos:',
                      style: TextStyle(
                        color: AppColors.blueBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: device
                            ? (MediaQuery.of(context).size.width * 0.05) * 0.5
                            : (MediaQuery.of(context).size.width * 0.04),
                        letterSpacing: 0.03,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    Text(
                      'Acumulación de puntos para futuros',
                      style: TextStyle(
                        color: AppColors.blueBackground,
                        fontWeight: FontWeight.normal,
                        fontSize: device
                            ? (MediaQuery.of(context).size.width * 0.037) * 0.5
                            : (MediaQuery.of(context).size.width * 0.03),
                        letterSpacing: 0.03,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    Text(
                      'servicios médicos, proporcionando',
                      style: TextStyle(
                        color: AppColors.blueBackground,
                        fontWeight: FontWeight.normal,
                        fontSize: device
                            ? (MediaQuery.of(context).size.width * 0.037) * 0.5
                            : (MediaQuery.of(context).size.width * 0.03),
                        letterSpacing: 0.03,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    Text(
                      'seguridad financiera.',
                      style: TextStyle(
                        color: AppColors.greenBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: device
                            ? (MediaQuery.of(context).size.width * 0.037) * 0.5
                            : (MediaQuery.of(context).size.width * 0.04),
                        letterSpacing: 0.03,
                        fontFamily: 'Outfit',
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}

//nuevo
Widget imagen(BuildContext context, String image) {
  return Image(
    image: AssetImage('assets/images/$image'),
    fit: BoxFit.contain,
  );
}

Container extendido(BuildContext context, bool device) {
  return Container(
    color: Colors.white,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Stack(
      children: [
        Image(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          image: const AssetImage(
            'assets/images/carusel4.png',
          ), // Cambiado a carusel4.png
          fit: BoxFit.cover,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
              width: device
                  ? MediaQuery.of(context).size.width * 0.45
                  : MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: device
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Text(
                    'Ahorra en servicios médicos', // Modificado el texto
                    textAlign: device ? TextAlign.left : TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blueBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: device
                          ? (MediaQuery.of(context).size.width * 0.1) * 0.5
                          : (MediaQuery.of(context).size.width * 0.1),
                      letterSpacing: 0.03,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: device
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      Text(
                        'En nuestros ', // Modificado el texto
                        textAlign: device ? TextAlign.left : TextAlign.center,
                        style: TextStyle(
                            color: AppColors.blueBackground,
                            letterSpacing: 0.03,
                            fontFamily: 'Outfit',
                            fontSize: device
                                ? (MediaQuery.of(context).size.width * 0.04) / 2
                                : (MediaQuery.of(context).size.width * 0.07)),
                      ),
                      Text(
                        'comercios afiliados ',
                        textAlign: device ? TextAlign.left : TextAlign.center,
                        style: TextStyle(
                            color: AppColors.greenBackground,
                            letterSpacing: 0.03,
                            fontFamily: 'Outfit',
                            fontSize: device
                                ? (MediaQuery.of(context).size.width * 0.04) / 2
                                : (MediaQuery.of(context).size.width * 0.045)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            device
                ? SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.50, // 40% del ancho de la pantalla
                    height: MediaQuery.of(context).size.height,
                    // 80% de la altura de la pantalla
                    child: const Image(
                      image: AssetImage('assets/images/carusel4.png'),
                      fit: BoxFit.contain,
                    ),
                  )
                : const SizedBox(),
            const Spacer(),
          ],
        ),
      ],
    ),
  );
}
