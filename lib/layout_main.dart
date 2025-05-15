import 'package:flutter/cupertino.dart';
import 'package:excel/excel.dart' as exc;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reportes_medired/especialidades_page.dart';
import 'package:reportes_medired/list_pss.dart';
import 'package:reportes_medired/my_home_page.dart';
import 'package:reportes_medired/payment_report_page.dart';
import 'package:reportes_medired/register_pss.dart';
import 'package:reportes_medired/services_page.dart';
import 'package:universal_html/html.dart' as html;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'users_page.dart';

class LayoutMain extends StatefulWidget {
  final Widget child;

  LayoutMain({required this.child});

  @override
  createState() => _LayoutMainState();
}

class _LayoutMainState extends State<LayoutMain> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Funciones para generación de reportes
  // Future<void> _generateAndDownloadExcel() async {
  //   await _generateExcel('members.xlsx',
  //       (setDate, currentDate) => setDate.toDate().isAfter(currentDate));
  // }

  // Future<void> _generateAndDownloadExpiredExcel() async {
  //   await _generateExcel('expired_members.xlsx',
  //       (setDate, currentDate) => setDate.toDate().isBefore(currentDate));
  // }

  // Future<void> _generateExcel(String fileName,
  //     bool Function(Timestamp, DateTime) filterCondition) async {
  //   try {
  //     QuerySnapshot subscriptionSnapshot =
  //         await _firestore.collection('subscription').get();
  //     List<Map<String, dynamic>> subscriptionList = subscriptionSnapshot.docs
  //         .map((doc) => doc.data() as Map<String, dynamic>)
  //         .toList();

  //     var excel = exc.Excel.createExcel();
  //     var sheet = excel['Sheet1'];

  //     if (subscriptionList.isNotEmpty) {
  //       var headers = subscriptionList[0].keys.toList();
  //       sheet.appendRow(headers.cast<exc.CellValue?>());

  //       for (var row in subscriptionList) {
  //         sheet.appendRow(headers
  //             .map((header) => row[header].toString())
  //             .cast<exc.CellValue?>()
  //             .toList());
  //       }
  //     } else {
  //       sheet.appendRow([]);
  //     }

  //     var bytes = excel.encode();
  //     var blob = html.Blob([bytes],
  //         'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  //     var url = html.Url.createObjectUrlFromBlob(blob);
  //     var anchor = html.AnchorElement(href: url)
  //       ..setAttribute('download', fileName)
  //       ..click();
  //     html.Url.revokeObjectUrl(url);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Archivo Excel generado con éxito.')));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error al generar el archivo Excel: $e')));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppHeader(), // Header superior agregado

          Expanded(
            child: Row(
              children: [
                // Menú lateral
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 250,
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      // _buildSidebarHeader(), // Logo en el sidebar
                      Expanded(
                        child: ListView(
                          children: [
                            // ListTile(
                            //   leading: const Icon(Icons.file_download),
                            //   title: const Text('Reporte Activos'),
                            //   onTap: _generateAndDownloadExcel,
                            // ),
                            // ListTile(
                            //   leading: const Icon(Icons.file_download),
                            //   title: const Text('Reporte Inactivos'),
                            //   onTap: _generateAndDownloadExpiredExcel,
                            // ),
                            ListTile(
                              leading: const Icon(Icons.payment),
                              title: const Text('Reporte de Pagos'),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PaymentReportPage()),
                                );
                              },
                            ),
                            
                            ListTile(
                              leading: const Icon(Icons.manage_accounts),
                              title: const Text('Gestionar Prestadores'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PSSListPage()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.list),
                              title: const Text('Servicios'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ServicesPage()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.list),
                              title: const Text('Especialidades'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EspecialidadesPage()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.people),
                              title: const Text('Usuarios o Pacientes'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const UsersPage()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Contenido principal
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header superior con logo y título
  Widget _buildAppHeader() {
    return Container(
      color: const Color.fromARGB(255, 218, 218, 218),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
            child: Image.asset('assets/images/logo.png', height: 40),
          ),
          const SizedBox(width: 10),
          const Text(
            'Medired Admin Panel',
            style:
                TextStyle(color: Color.fromARGB(255, 8, 1, 41), fontSize: 20),
          ),
          const Spacer(),
          // const Icon(Icons.notifications, color: Colors.white),
          const SizedBox(width: 10),
          const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 2, 10, 87),
            backgroundImage: AssetImage(
                'assets/images/logop.png'), // Cambia la ruta según la ubicación de tu logo
          )
        ],
      ),
    );
  }

  // Logo en el sidebar
  // Widget _buildSidebarHeader() {
  //   return Container(
  //     color: Colors.blue,
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       children: [
  //         Image.asset('assets/images/logo.png', height: 80),
  //         const SizedBox(height: 10),
  //         const Text(
  //           'Medired',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 22,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
