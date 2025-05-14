import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarTemplate extends StatelessWidget {
  const CalendarTemplate({
    super.key,
    required this.source,
  });

  final List<Meeting> source;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            const Expanded(flex: 1, child: SizedBox.shrink()),
            Expanded(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  color: AppColors.lightBorder.withOpacity(0.6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ..._calendarContainer(
                              context: context,
                              source: source,
                              title: 'Agenda',
                              view: CalendarView.month,
                            ),
                            ..._calendarContainer(
                              context: context,
                              source: source,
                              title: 'Hoy',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox.shrink()),
          ],
        );
      },
    );
  }

  List<Widget> _calendarContainer({
    required BuildContext context,
    required String title,
    required List<Meeting> source,
    CalendarView view = CalendarView.day,
  }) {
    return [
      Text(title,
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: AppColors.blueBackground)),
      const SizedBox(width: 8),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: SfCalendar(
            view: view,
            showTodayButton: true,
            showNavigationArrow: true,
            cellBorderColor: Colors.transparent,
            backgroundColor: Colors.white,
            dataSource: MeetingDataSource(source),
            monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
    ];
  }
}
