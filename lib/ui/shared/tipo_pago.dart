import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';

class TypePago extends StatefulWidget {
  const TypePago({
    super.key,
    required this.device,
    required this.width,
    required this.callback,
  });

  final bool device;
  final double width;
  final Function(int) callback;

  @override
  State<TypePago> createState() => _TypePagoState();
}

class _TypePagoState extends State<TypePago> {
  int selectedindex = 0;
  final List<String> buttonLabels = [
    'Mensual',
    'Trimestral',
    'Semestral',
    'Anual'
  ];

  @override
  Widget build(BuildContext context) {
    return widget.width > 450
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: contents,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: contents,
          );
  }

  List<Widget> get contents {
    return List.generate(
      buttonLabels.length,
      (index) => SizedBox(
        width: widget.device
            ? (widget.width * 0.1025)
            : (widget.width > 450 ? (widget.width * 0.21) : (widget.width)),
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: SizedBox(
            width: widget.device ? (widget.width * 0.55) : (widget.width),
            child: CustomFlatButton(
              textColor: selectedindex == index
                  ? Colors.white
                  : AppColors.blueBackground,
              buttonColor: selectedindex == index
                  ? AppColors.greenBackground
                  : AppColors.lightBorder.withOpacity(1),
              text: buttonLabels[index],
              onPressed: () {
                widget.callback(index);
                setState(() {
                  selectedindex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
