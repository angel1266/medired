import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';

class CustomScheduleWidget extends StatefulWidget {
  const CustomScheduleWidget({super.key});

  @override
  State<CustomScheduleWidget> createState() => _CustomScheduleWidgetState();
}

class _CustomScheduleWidgetState extends State<CustomScheduleWidget> {
  Map<String, String?> selectedTimes = {};
  List<String> dayNames = [];
  DateTime currentDate = DateTime.now();
  final int numberdays = 60;

  @override
  void initState() {
    super.initState();
    dayNames = [
      for (int i = 0; i < numberdays; i++)
        _getDayName(currentDate.add(Duration(days: i)))
    ];
    for (int i = 0; i < numberdays; i++) {
      String dayName = dayNames[i];
      selectedTimes[dayName] = null;
    }
  }

  String _getDayName(DateTime date) {
    if (date.day == currentDate.day) {
      return 'Hoy';
    } else if (date.day == currentDate.add(const Duration(days: 1)).day) {
      return 'Mañana';
    } else {
      List<String> dayNames = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
      int dayIndex = date.weekday % 7;
      return dayNames[dayIndex];
    }
  }

  final ScrollController _scrollController = ScrollController();
  void scrollToRight() {
    _scrollController.animateTo(
      _scrollController.offset + MediaQuery.of(context).size.width * 0.22,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void scrollToLeft() {
    _scrollController.animateTo(
      _scrollController.offset - MediaQuery.of(context).size.width * 0.22,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dayColumns = [];

    for (int i = 0; i < numberdays; i++) {
      String dayName = dayNames[i];
      String dayAndMonth =
          '${currentDate.add(Duration(days: i)).day} ${_getMonthName(currentDate.add(Duration(days: i)).month)}';

      List<TimeSlot> timeSlots = [
        TimeSlot(
            textoMostrar: '08:00',
            fecha: currentDate.add(Duration(days: i)),
            timeAvailable: true),
        TimeSlot(
            textoMostrar: '09:00',
            fecha: currentDate.add(Duration(days: i)),
            timeAvailable: true),
        TimeSlot(
            textoMostrar: '10:00',
            fecha: currentDate.add(Duration(days: i)),
            timeAvailable: true),
        TimeSlot(
            textoMostrar: '11:00',
            fecha: currentDate.add(Duration(days: i)),
            timeAvailable: true),
        TimeSlot(
            textoMostrar: '12:00',
            fecha: currentDate.add(Duration(days: i)),
            timeAvailable: false),
        TimeSlot(
            textoMostrar: '01:00',
            fecha: currentDate.add(Duration(days: i)),
            timeAvailable: false),
      ];

      dayColumns.add(
        _buildColumn(
          dayName,
          dayAndMonth,
          timeSlots,
          const Color(0xFF5F7DC9).withOpacity(0.07),
          const Color(0xFF5684FA),
          dayName,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: scrollToLeft,
                icon: const Icon(Icons.arrow_left,
                    color: AppColors.blueBackground),
              ),
              const Text('Calendario',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF213976),
                      fontFamily: 'Outfit')),
              IconButton(
                onPressed: scrollToRight,
                icon: const Icon(
                  Icons.arrow_right,
                  color: AppColors.blueBackground,
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.66,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              children:
                  //dayColumns
                  [
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: dayColumns,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'ene';
      case 2:
        return 'feb';
      case 3:
        return 'mar';
      case 4:
        return 'abr';
      case 5:
        return 'may';
      case 6:
        return 'jun';
      case 7:
        return 'jul';
      case 8:
        return 'ago';
      case 9:
        return 'sep';
      case 10:
        return 'oct';
      case 11:
        return 'nov';
      case 12:
        return 'dic';
      default:
        return '';
    }
  }

  Widget _buildColumn(String title, String date, List<TimeSlot> timeSlots,
      Color backgroundColor, Color textColor, String dayName) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF213976),
                fontFamily: 'Outfit'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            date,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          for (TimeSlot timeSlot in timeSlots)
            Container(
              // width: double.infinity,
              height: 60.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: timeSlot.timeAvailable
                  ? ElevatedButton(
                      onPressed: () {
                        // Lógica para cambiar la hora seleccionada
                        setState(() {
                          selectedTimes = {
                            for (var key in selectedTimes.keys)
                              if (key == dayName)
                                key: timeSlot.textoMostrar
                              else
                                key: null
                          };
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xFFD1DEFF)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: selectedTimes[dayName] ==
                                      timeSlot.textoMostrar
                                  ? Colors.green
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          timeSlot.textoMostrar,
                          style: TextStyle(
                            color:
                                selectedTimes[dayName] == timeSlot.textoMostrar
                                    ? Colors.green
                                    : const Color(0xFF5684FA),
                            fontSize: 14,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: null,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.transparent),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          timeSlot.textoMostrar,
                          style: const TextStyle(
                            color: Color.fromRGBO(33, 57, 118, 0.51),
                            fontSize: 14,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}

class TimeSlot {
  final String textoMostrar;
  final DateTime fecha;
  final bool timeAvailable;

  TimeSlot(
      {required this.textoMostrar,
      required this.fecha,
      required this.timeAvailable});
}
