import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reportes_medired/layout_main.dart';
import 'package:reportes_medired/payment_report_page.dart';
import 'package:reportes_medired/services_page.dart';
import 'package:universal_html/html.dart' as html;
import 'package:excel/excel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:reportes_medired/list_pss.dart';
import 'package:reportes_medired/register_pss.dart';

class MyHomePage extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<MyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _calculateAge(Timestamp birthdateTimestamp) {
    DateTime birthdate = birthdateTimestamp.toDate();
    DateTime today = DateTime.now();
    int age = today.year - birthdate.year;

    // Ajustar si el cumpleaños no ha ocurrido aún este año
    if (today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day)) {
      age--;
    }

    return age;
  }

  // Variables para estadísticas dinámicas
  int totalMembers = 0;
  int totalAppointments = 0;
  int totalSpecialties = 0;

  List<BarChartGroupData> memberStats = [];
  List<BarChartGroupData> appointmentStats = [];

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    // Miembros
    QuerySnapshot memberSnapshot = await _firestore.collection('member').get();
    setState(() {
      totalMembers = memberSnapshot.size;
    });

    // Especialidades
    QuerySnapshot specialtiesSnapshot =
        await _firestore.collection('especialidades').get();
    setState(() {
      totalSpecialties = specialtiesSnapshot.size;
    });

    // Citas
    QuerySnapshot appointmentsSnapshot =
        await _firestore.collection('appointment').get();
    setState(() {
      totalAppointments = appointmentsSnapshot.size;
    });

    // Estadísticas de miembros por especialidad
    List<Map<String, dynamic>> memberData = memberSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    Map<int, int> specialtyCounts = {};
    for (var member in memberData) {
      List<dynamic> specialties = member['medicalSpecializations'] ?? [];
      for (var specialty in specialties) {
        specialtyCounts[int.parse(specialty.toString())] = (specialtyCounts[specialty] ?? 0) + 1;
      }
    }

    setState(() {
      memberStats = specialtyCounts.entries.map((entry) {
        return BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(toY: entry.value.toDouble(), color: Colors.blue)
          ],
        );
      }).toList();
    });

    // Estadísticas de citas por mes
    List<Map<String, dynamic>> appointmentData = appointmentsSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
    Map<int, int> appointmentCounts = {};
    for (var appointment in appointmentData) {
      DateTime date = (appointment['date'] ?? DateTime.now());
      int month = date.month;
      appointmentCounts[month] = (appointmentCounts[month] ?? 0) + 1;
    }

    setState(() {
      appointmentStats = appointmentCounts.entries.map((entry) {
        return BarChartGroupData(
          x: int.parse(entry.key.toString()),
          barRods: [
            BarChartRodData(toY: entry.value.toDouble(), color: Colors.green)
          ],
        );
      }).toList();
    });
  }

  Future<void> _generateAndDownloadExcel() async {
    await _generateExcel('members.xlsx',
        (setDate, currentDate) => setDate.toDate().isAfter(currentDate));
  }

  Future<void> _generateAndDownloadExpiredExcel() async {
    await _generateExcel('expired_members.xlsx',
        (setDate, currentDate) => setDate.toDate().isBefore(currentDate));
  }

  Future<void> _generateExcel(String fileName,
      bool Function(Timestamp, DateTime) filterCondition) async {
    try {
      QuerySnapshot subscriptionSnapshot =
          await _firestore.collection('subscription').get();
      List<Map<String, dynamic>> subscriptionList = subscriptionSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      List<Map<String, dynamic>> filteredList = [];
      DateTime currentDate = DateTime.now();

      for (var subscription in subscriptionList) {
        Timestamp? setDate = subscription['setDate'] as Timestamp?;
        if (setDate != null && filterCondition(setDate, currentDate)) {
          DocumentSnapshot memberSnapshot = await _firestore
              .collection('member')
              .doc(subscription['uid'])
              .get();
          if (memberSnapshot.exists) {
            var memberData = memberSnapshot.data() as Map<String, dynamic>?;
            if (memberData != null) {
              var personalInfo =
                  memberData['personalInfo'] as Map<String, dynamic>? ?? {};
              var authInfo =
                  memberData['authInfo'] as Map<String, dynamic>? ?? {};
              List<dynamic> documents =
                  personalInfo['documents'] as List<dynamic>? ?? [];
              Timestamp? birthdateTimestamp =
                  personalInfo['birthdate'] as Timestamp?;
              DateTime? birthdate = birthdateTimestamp?.toDate();
              String formattedDate = birthdate != null
                  ? "${birthdate.day}/${birthdate.month}/${birthdate.year}"
                  : 'N/A';
              var extractedData = {
                'email': authInfo['email'] ?? '',
                'name':
                    '${personalInfo['firstName'] ?? ''} ${personalInfo['lastName'] ?? ''}',
                'phoneNumber':
                    personalInfo['phoneNumber'][0]['phoneNumber'] ?? 'N/A',
                'photoUrl': authInfo['photoUrl'] ?? 'N/A',
                'uid': authInfo['uid'] ?? '',
                'sex': personalInfo['sex'] == 0 ? 'Masculino' : 'Femenino',
                'birthday': formattedDate,
                'age': birthdateTimestamp != null
                    ? _calculateAge(
                        birthdateTimestamp) // Llama al método para calcular la edad
                    : 'N/A',
                'points': memberData['points'] ?? 0,
                'document': documents.isNotEmpty
                    ? documents[0]['value'] ?? 'N/A'
                    : 'N/A',
                'totalPaid': memberData['montoTotal'] ?? 0,
                'endDate': setDate.toDate(),
                'medicalConsultation': subscription['medicalConsultation'] ?? 0,
                'medicalImage': subscription['medicalImage'] ?? 0,
                'medicalTest': subscription['medicalTest'] ?? 0
              };
              filteredList.add(extractedData);
            }
          }
        }
      }

      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      if (filteredList.isNotEmpty) {
        // Agregar encabezados
        var headers = filteredList[0].keys.toList();
        sheet.appendRow(headers.cast<CellValue?>());

        // Agregar datos
        for (var row in filteredList) {
          sheet.appendRow(headers
              .map((header) => row[header].toString())
              .cast<CellValue?>()
              .toList());
        }
      } else {
        sheet.appendRow([]);
      }

      var bytes = excel.encode();
      var blob = html.Blob([bytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      var url = html.Url.createObjectUrlFromBlob(blob);
      var anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Archivo Excel generado con éxito.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar el archivo Excel: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: LayoutMain(child:SingleChildScrollView(
        child: Column(
                  children: [
                    Row(
                      children: [
                        _buildStatCard('Miembros Activos',
                            totalMembers.toString(), Colors.blue),
                        const SizedBox(width: 16),
                        _buildStatCard('Especialidades',
                            totalSpecialties.toString(), Colors.green),
                        const SizedBox(width: 16),
                        _buildStatCard('Citas Totales',
                            totalAppointments.toString(), Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildBarChart(
                            title: 'Miembros por Especialidad',
                            barGroups: memberStats,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildBarChart(
                            title: 'Citas por Mes',
                            barGroups: appointmentStats,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
            ));
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(
      {required String title, required List<BarChartGroupData> barGroups}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
