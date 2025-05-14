import 'package:flutter/material.dart';

class RegisterTemplate extends StatelessWidget {
  const RegisterTemplate({
    required this.backgroundColor,
    required this.imageBackground,
    required this.gradientColors,
    required this.formChildren,
    required this.adChildren,
    super.key,
  });

  final Color backgroundColor;
  final String imageBackground;
  final List<Color> gradientColors;
  final List<Widget> formChildren;
  final List<Widget> adChildren;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          // Use a layout for larger screens
          return Container(
            color: backgroundColor,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      const Expanded(flex: 1, child: SizedBox.shrink()),
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          child: Column(
                            children: formChildren
                                .expand((element) =>
                                    [const SizedBox(height: 25), element])
                                .toList(),
                          ),
                        ),
                      ),
                      const Expanded(flex: 1, child: SizedBox.shrink()),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image(
                          image: AssetImage(imageBackground),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: gradientColors,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Expanded(
                                    flex: 1, child: SizedBox.shrink()),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: adChildren
                                        .expand((element) => [
                                              const SizedBox(height: 25),
                                              element
                                            ])
                                        .toList(),
                                  ),
                                ),
                                const Expanded(
                                    flex: 1, child: SizedBox.shrink()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          // Use a layout for smaller screens
          return Container(
            color: backgroundColor,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: formChildren
                            .expand((element) =>
                                [const SizedBox(height: 25), element])
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
