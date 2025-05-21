import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/router/route_generator.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:medired/ui/organisms/beneficio_info.dart';
import 'package:medired/ui/organisms/detalle_prestadores.dart';
import 'package:medired/ui/shared/carusel.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_horizontal_featured_list/flutter_horizontal_featured_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Membresias extends StatefulWidget {
  const Membresias({super.key});

  @override
  State<Membresias> createState() => _MembresiasState();
}

class _MembresiasState extends State<Membresias> {
  List<Map<String, dynamic>> servicios = [];
  List<Map<String, dynamic>> planes = [];
  int? highlightedIndex;
  final PageController _pageController = PageController();
  late Timer _carouselTimer;

  @override
  void initState() {
    super.initState();
    _fetchServicios();
    _fetchPlan();
    //r_startCarousel();
  }

  @override
  void dispose() {
    _carouselTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startCarousel() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= (servicios.length / 3).ceil()) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _fetchServicios() async {
    try {
      List<dynamic> fetchedData = await getDocs(
          'servicios', 'id_centro', 'Nv044fsBNjhl6HeBGBqUh7awIRy1');
      setState(() {
        servicios = fetchedData.map((entry) {
          return {
            'data': entry[0],
            'id': entry[1],
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> _fetchPlan() async {
    try {
      List<dynamic> fetchedData =
          await getDocs('planes', 'status', "1", tipo: "plan");
      print(fetchedData);
      setState(() {
        planes = fetchedData.map((entry) {
          print(entry[0].toString());
          return {
            'data': entry[0],
            'id': entry[1],
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Error planes fetching data: $e');
    }
  }

  Future<List<dynamic>> getDocs(String table, String field, dynamic filter,
      {String tipo = "servicio"}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(table)
        .where(field, isEqualTo: filter)
        .get();

    List<QueryDocumentSnapshot> documentos = querySnapshot.docs;
    if (tipo == "servicio") {
      documentos.sort((a, b) => a['nombre'].compareTo(b['nombre']));
    }

    List<dynamic> list = [];

    for (var doc in documentos) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      list.add([data, doc.id]);
    }
    return list;
  }

  IconData getIcon(icon) {
    final match = RegExp(r'U\+([0-9a-fA-F]+)').firstMatch(icon);
    if (match != null) {
      final hexValue = match.group(1)!;
      final iconDataInt = int.parse(hexValue, radix: 16);
      return IconData(iconDataInt,
          fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
    }
    return IconData(
      0x0F06D,
      fontFamily: 'FontAwesomeSolid',
      fontPackage: 'font_awesome_flutter',
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    bool isSmallDevice = MediaQuery.of(context).size.width <= 600;

    return GestureDetector(
      onTap: () {
        setState(() {
          highlightedIndex = null;
        });
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Carusel(
              size: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height,
              ),
            ),
            SizedBox(
                height: 500, child: _buildMembresiaSection(context, isDesktop)),
            const SizedBox(height: 20),
            _buildCarnetCard(isDesktop, isSmallDevice),
            const SizedBox(height: 20),
            _buildServiceCarousel(isDesktop, isSmallDevice),
            const SizedBox(height: 20),
            _buildTitle('Adquiere Nuevos Planes'),
            _buildCustomTable(isSmallDevice),
            const SizedBox(height: 20),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMembresiaSection(BuildContext context, bool isDesktop) {
    bool device = context.screenType() == ScreenType.desktop;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFE0F7FA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: isDesktop ? 100 : 20,
        ),
        child: isDesktop
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Adquiere tu membresía',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blueBackground,
                          ),
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Medired',
                                style: TextStyle(
                                  color: AppColors.greenBackground,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text:
                                    ' es un Club de Membresías que le ofrece a los afiliados grandes ventajas fungiendo como un plan de asistencia con acceso a descuentos exclusivos en servicios y procesos médicos.',
                                style: TextStyle(
                                  color: AppColors.blueBackground,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.shopping_cart,
                              color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32,
                            ),
                            backgroundColor: AppColors.greenBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => router.push(RoutePath.signUp),
                          label: const Text(
                            'Únete a Medired',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/member.png',
                      fit: BoxFit.contain,
                      width: 300,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  const Text(
                    'Adquiere tu membresía',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blueBackground,
                    ),
                  ),
                  //const SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Medired',
                          style: TextStyle(
                            color: AppColors.greenBackground,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' es un Club de Membresías que le ofrece a los afiliados grandes ventajas fungiendo como un plan de asistencia con acceso a descuentos exclusivos en servicios y procesos médicos.',
                          style: TextStyle(
                            color: AppColors.blueBackground,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/member.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      backgroundColor: AppColors.greenBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      router.go(RoutePath.signUp);
                      print("prueba");
                    },
                    label: const Text(
                      'Comprar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCarnetCard(bool isDesktop, bool isSmallDevice) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        width: isDesktop
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.95,
        constraints: BoxConstraints(
          minHeight: 250,
          maxWidth: isSmallDevice ? 400 : 500,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          gradient: const LinearGradient(
            colors: [Colors.white, AppColors.lightBlueBackground],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png',
                    height: isSmallDevice ? 40 : 50),
                const SizedBox(width: 10),
                Text(
                  'MediRed',
                  style: TextStyle(
                    fontSize: isSmallDevice ? 22 : 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blueBackground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildAnimatedCardRow('Nombre:', 'Patricia Santana', isDesktop),
            const SizedBox(height: 12),
            _buildAnimatedCardRow(
                'Número de Membresía:', 'FS0000000B', isDesktop),
            const SizedBox(height: 12),
            _buildAnimatedCardRow('Cédula:', 'XXX-XXXXXX-X', isDesktop),
            const SizedBox(height: 12),
            _buildAnimatedCardRow(
                'Tipo de Membresía:', 'Membresía Premium', isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCardRow(String title, String value, bool isDesktop) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, double opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blueBackground,
                      fontSize: isDesktop ? 18 : 16,
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: AppColors.blueBackground,
                      fontSize: isDesktop ? 18 : 16,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceCarousel(bool isDesktop, bool isSmallDevice) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: 100,
        width: constraints.maxWidth * 0.9,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: servicios.length,
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.blueBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(getIcon(servicios[index]['data']['iconName']),
                      color: AppColors.greenBackground,
                      size: isSmallDevice ? 24 : 30
                      /*AppColors.getIconForService(
                          servicios[index]['data']['nombre'] ?? 'Servicio'),
                      color: AppColors.greenBackground,
                      size: isSmallDevice ? 24 : 30*/
                      ),
                  const SizedBox(height: 8),
                  Text(
                    servicios[index]['data']['nombre'] ?? 'Servicio',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallDevice ? 12 : 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.blueBackground,
        ),
      ),
    );
  }

  Widget _buildCustomTable(bool isSmallDevice) {
    return Container(
      height: 600,
      child: CarouselSlider(
          options: CarouselOptions(
            height: 600,
            aspectRatio: 480 / 400,
            initialPage: 0,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 900),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (index, reason) {},
            scrollDirection: Axis.horizontal,
          ),
          items: [
            for (var i = 0; i < planes.length; i++)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width * 0.7
                    : MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/logo.png',
                                  height: MediaQuery.of(context).size.width >
                                          1000
                                      ? MediaQuery.of(context).size.width * 0.03
                                      : MediaQuery.of(context).size.width *
                                          0.05,
                                ),
                                const SizedBox(width: 10),
                                const Flexible(
                                  child: Text(
                                    'Plan Exclusivo - Beneficios',
                                    style: TextStyle(
                                      color: AppColors.blueBackground,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      letterSpacing: 1.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: const BoxDecoration(
                        color: AppColors.blueBackground,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Servicios',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  (MediaQuery.of(context).size.width <= 500
                                      ? MediaQuery.of(context).size.width * 0.03
                                      : 16),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Descuentos',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  (MediaQuery.of(context).size.width <= 500
                                      ? MediaQuery.of(context).size.width * 0.03
                                      : 16),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Acción',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  (MediaQuery.of(context).size.width <= 500
                                      ? MediaQuery.of(context).size.width * 0.03
                                      : 16),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 400,
                      child: SingleChildScrollView(
                        child: Container(
                          height: 400,
                          child: ListView(children: [
                            Column(
                              children:
                                  List.generate(servicios.length, (index) {
                                String nombre = servicios[index]['data']
                                        ['nombre'] ??
                                    'Servicio';
                                bool isHighlighted = highlightedIndex == index;
                                IconData icon = getIcon(
                                    servicios[index]['data']['iconName']);

                                return Column(
                                  children: [
                                    if (index > 0)
                                      Divider(
                                        color: Colors.grey.shade300,
                                        thickness: 1,
                                      ),
                                    MouseRegion(
                                      onEnter: (_) {
                                        setState(() {
                                          highlightedIndex = index;
                                        });
                                      },
                                      onExit: (_) {
                                        setState(() {
                                          highlightedIndex = null;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        decoration: BoxDecoration(
                                          color: isHighlighted
                                              ? AppColors.lightBlueBackground
                                              : const Color(0xFFEFF3F9),
                                          border: Border.all(
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Icon(icon,
                                                        color: AppColors
                                                            .blueBackground,
                                                        size: 20),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      nombre,
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width <=
                                                                500
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.025
                                                            : 16,
                                                        color: AppColors
                                                            .blueBackground,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                child: Text(
                                                  servicios[index]['data']
                                                          ['descuento'] +
                                                      '%',
                                                  style: const TextStyle(
                                                    color: AppColors
                                                        .greenBackground,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                child: isSmallDevice
                                                    ? IconButton(
                                                        onPressed: () =>
                                                            showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertBeneficio(
                                                              prestadorConsult:
                                                                  true,
                                                              id: "0",
                                                              id_servicio:
                                                                  servicios[
                                                                          index]
                                                                      ['id'],
                                                            );
                                                          },
                                                        ),
                                                        icon: const Icon(
                                                          Icons.search,
                                                          color: AppColors
                                                              .greenBackground,
                                                        ),
                                                      )
                                                    : ElevatedButton.icon(
                                                        onPressed: () =>
                                                            showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertBeneficio(
                                                              prestadorConsult:
                                                                  true,
                                                              id: "0",
                                                              id_servicio:
                                                                  servicios[
                                                                          index]
                                                                      ['id'],
                                                            );
                                                          },
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColors
                                                                  .greenBackground,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                        ),
                                                        icon: const Icon(
                                                          Icons.search,
                                                          size: 14,
                                                          color: Colors.white,
                                                        ),
                                                        label: const Text(
                                                          'Consultar',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ]),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02),
      child: CustomFlatButton(
        text: 'Nuestras Opciones',
        onPressed: () => router.push(RoutePath.signUp),
        buttonColor: AppColors.greenBackground,
        textColor: Colors.white,
      ),
    );
  }
}

class myCustomScrollBahavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevice => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus
      };
}
