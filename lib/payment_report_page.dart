import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:reportes_medired/layout_main.dart';
import 'package:universal_html/html.dart' as html;

class PaymentReportPage extends StatefulWidget {
  const PaymentReportPage({super.key});

  @override
  _PaymentReportPageState createState() => _PaymentReportPageState();
}

class _PaymentReportPageState extends State<PaymentReportPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> _paymentData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _endDate = DateTime.now();
    _startDateController.text = DateFormat('dd/MM/yyyy').format(_startDate!);
    _endDateController.text = DateFormat('dd/MM/yyyy').format(_endDate!);
    _fetchPayments();
  }

  Future<void> _selectDateRange(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate! : _endDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          _startDateController.text =
              DateFormat('dd/MM/yyyy').format(pickedDate);
        } else {
          _endDate = pickedDate;
          _endDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        }
      });
    }
  }

  Future<void> _fetchPayments() async {
    if (_startDate == null || _endDate == null) return;

    setState(() {
      _isLoading = true;
    });

    QuerySnapshot paymentsSnapshot = await _firestore
        .collection('payments')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(_startDate!))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(_endDate!))
        .get();

    List<Map<String, dynamic>> payments = [];
    for (var doc in paymentsSnapshot.docs) {
      var paymentData = doc.data() as Map<String, dynamic>;
      String uid = paymentData['uid'];

      DocumentSnapshot memberSnapshot =
          await _firestore.collection('member').doc(uid).get();
      var memberData = memberSnapshot.data() as Map<String, dynamic>?;

      String fullName = '';
      if (memberData != null) {
        var personalInfo =
            memberData['personalInfo'] as Map<String, dynamic>? ?? {};
        fullName =
            '${personalInfo['firstName'] ?? ''} ${personalInfo['lastName'] ?? ''}';
      }

      var date = (paymentData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);

      payments.add({
        'amount': paymentData['amount'],
        'date': formattedDate,
        'id': paymentData['id'],
        'uid': uid,
        'fullName': fullName,
      });
    }

    setState(() {
      _paymentData = payments;
      _isLoading = false;
    });
  }

  Future<void> _downloadExcel() async {
    var excel = Excel.createExcel();
    var sheet = excel['Reporte de Pagos'];

    // Cabeceras
    sheet.appendRow([
      TextCellValue('Nombre'),
      TextCellValue('Monto'),
      TextCellValue('Fecha'),
      TextCellValue('ID'),
    ]);

    for (var payment in _paymentData) {
      sheet.appendRow([
        TextCellValue(payment['fullName']),
        TextCellValue(payment['amount'].toString()),
        TextCellValue(payment['date']),
        TextCellValue(payment['id'] ?? ''),
      ]);
    }

    var bytes = excel.encode();
    var blob = html.Blob([bytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    var url = html.Url.createObjectUrlFromBlob(blob);
    var anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'reporte_pagos.xlsx')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void _showPaymentDetails(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del Pago'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nombre: ${payment['fullName']}'),
                Text('Monto: ${payment['amount']}'),
                Text('Fecha: ${payment['date']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutMain(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha Inicio',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDateRange(context, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _endDateController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha Fin',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDateRange(context, false),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _fetchPayments,
                  child: const Text('Buscar'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _downloadExcel,
                  child: const Text('Descargar Excel'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // Cálculo automático de filas por página
                        final int rowsPerPage =
                            (constraints.maxHeight ~/ 80).clamp(5, 20);
                        return SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: SingleChildScrollView(
                            child: PaginatedDataTable(
                              header: const Text('Reporte de Pagos'),
                              columns: const [
                                DataColumn(label: Text('Nombre')),
                                DataColumn(label: Text('Monto')),
                                DataColumn(label: Text('Fecha')),
                                DataColumn(label: Text('Acciones')),
                              ],
                              source: _PaymentDataSource(
                                  _paymentData, _showPaymentDetails),
                              rowsPerPage: rowsPerPage,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ));
  }
}

class _PaymentDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final Function(Map<String, dynamic>) onDetailsView;

  _PaymentDataSource(this.data, this.onDetailsView);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final payment = data[index];
    return DataRow(
      cells: [
        DataCell(Text(payment['fullName'])),
        DataCell(Text('${payment['amount']}')),
        DataCell(Text(payment['date'])),
        DataCell(
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () => onDetailsView(payment),
            tooltip: 'Ver Detalles',
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
