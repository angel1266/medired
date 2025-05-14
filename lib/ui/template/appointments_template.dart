import 'package:flutter/material.dart';
import 'package:medired/ui/shared/calendar.dart';
import 'package:medired/ui/template/calendar_template.dart';

class AppointmentsTemplate extends StatelessWidget {
  const AppointmentsTemplate({
    required this.appointments,
    required this.source,
    this.backgroundColor,
    this.floatingActionButton,
    super.key,
  });

  final List<Widget> appointments;
  final List<Meeting> source;
  final Color? backgroundColor;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: backgroundColor,
          //floatingActionButton: floatingActionButton,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border:const BorderDirectional(bottom: BorderSide(color: Color.fromARGB(255, 223, 223, 223)))
                ),
                child:  Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 200,
                    child: floatingActionButton),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    if (constraints.maxWidth > 768)
                      Expanded(
                        flex: 4,
                        child: CalendarTemplate(source: source),
                      ),
                    constraints.maxWidth > 768
                        ? Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                const Expanded(
                                    flex: 1, child: SizedBox.shrink()),
                                Expanded(
                                  flex: 4,
                                  child: appointments.isEmpty
                                      ? _emptyAppointmentsList()
                                      : _appointmentsList(),
                                ),
                                const Expanded(
                                    flex: 1, child: SizedBox.shrink()),
                              ],
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: appointments.isEmpty
                                  ? _emptyAppointmentsList()
                                  : _appointmentsList(),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ListView _appointmentsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return appointments[index];
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemCount: appointments.length,
    );
  }

  Widget _emptyAppointmentsList() {
    return const Center(child: Text('No tienes citas agendadas'));
  }
}
