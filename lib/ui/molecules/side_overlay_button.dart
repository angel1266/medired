import 'package:flutter/material.dart';

class SideOverlayButton extends StatefulWidget {
  const SideOverlayButton({super.key});

  static OverlayState? _overlayState;
  static OverlayEntry? _overlayEntry;

  static void createOverlay(BuildContext context) {
    if (_overlayState != null) {
      return;
    }

    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (contex) => const SideOverlayButton(),
    );

    (() async {
      Future.delayed(const Duration(milliseconds: 1));
      _overlayState!.insert(_overlayEntry!);
    })();
  }

  static void removeOverlay() {
    if (_overlayState == null) {
      return;
    }
    _overlayEntry!.remove();
    _overlayState!.dispose();
    _overlayEntry!.dispose();

    _overlayEntry = null;
    _overlayState = null;
  }

  @override
  State<SideOverlayButton> createState() => _SideOverlayButtonState();
}

class _SideOverlayButtonState extends State<SideOverlayButton> {
  bool opened = false;

  @override
  void initState() {
    opened = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      child: Center(
        child: RotatedBox(
          quarterTurns: 3,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      opened = !opened;
                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(95, 125, 201, 1),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(33, 57, 118, 0),
                            Color.fromRGBO(33, 57, 118, 1),
                          ],
                        ),
                      ),
                      child: const Text(
                        '¡OFERTA POR 6 MESES!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                expandedContent()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget expandedContent() {
    if (!opened) {
      return Container();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        child: RotatedBox(
          quarterTurns: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(95, 125, 201, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Adquiere nuestra Tarjeta de Membresía Digital',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Y mira todo lo que puedes hacer en',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  '6',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Meses',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('ADQUIRIR PLAN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
