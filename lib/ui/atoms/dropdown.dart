import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/app_decorations.dart';

class Dropdown<T> extends StatelessWidget {
  final Map<T, dynamic> options;
  final void Function(T? newValue) onChanged;
  final T? currentValue;

  const Dropdown({
    required this.options,
    required this.onChanged,
    required this.currentValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: AppDecorations.input.copyWith(
        hintText: 'Selecciona una opción',
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blueBackground),
        ),
      ),
      value: currentValue,
      onChanged: (value) => onChanged(value),
      items: options.entries.map((entry) {
        return DropdownMenuItem<T>(
          value: entry.key,
          child: Text(
            entry.value,
          ),
        );
      }).toList(),
      icon: currentValue != null
          ? const Icon(Icons.check,
              color:
                  Colors.blue) // Check icon in blue when an option is selected
          : const Icon(Icons
              .arrow_drop_down), // Default down arrow icon when no option is selected
    );
  }
}
