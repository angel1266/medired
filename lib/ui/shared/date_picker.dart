import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdayDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final Color backgroundColor;
  final Color selectedColor;
  final Color todayColor;

  BirthdayDatePicker({
    required this.onDateSelected,
    this.backgroundColor = Colors.white,
    this.selectedColor = Colors.blue,
    this.todayColor = Colors.green,
    DateTime? initialDate,
    super.key,
  })  : initialDate = initialDate ?? DateTime.now();

  @override
  State<BirthdayDatePicker> createState() => _BirthdayDatePickerState();
}

class _BirthdayDatePickerState extends State<BirthdayDatePicker> {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          child: Row(
            children: [
              Text(
                'Fecha de Nacimiento',
                style: TextStyle(
                    fontFamily: 'Outfit',
                    // fontSize: (sizewidth * 0.45) * 0.032,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GestureDetector(
            onTap: () {
              _showDatePicker(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _dateFormat.format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: widget.selectedColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        widget.onDateSelected(pickedDate);
      });
    }
  }
}
