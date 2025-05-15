import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:universal_html/html.dart' as html;
import 'layout_main.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  List<Map<String, dynamic>> _activeUsers = [];
  List<Map<String, dynamic>> _inactiveUsers = [];
  List<SuscripcionModel> suscripcion = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    DateTime now = DateTime.now();

    try {
      // Obtener suscripciones
      QuerySnapshot subscriptionSnapshot = await _firestore
          .collection('subscription')
          .where("setDate", isGreaterThanOrEqualTo: Timestamp.now())
          .get();

      Map<String, DateTime> subscriptionMap = {};
      for (var doc in subscriptionSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        suscripcion.add(SuscripcionModel(
            id: doc.id, uid: data["uid"], setDate: data["setDate"]));
      }

      // Obtener todos los miembros
      QuerySnapshot memberSnapshot =
          await _firestore.collection('member').get();

      List<Map<String, dynamic>> activeUsers = [];
      List<Map<String, dynamic>> inactiveUsers = [];

      for (var doc in memberSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String uid = data["authInfo"]['uid'] ?? '';
        var personalInfo = data['personalInfo'] as Map<String, dynamic>? ?? {};
        var authInfo = data['authInfo'] as Map<String, dynamic>? ?? {};

        //DateTime? subscriptionEndDate = subscriptionMap[uid];
        bool isActive = false;

        // Verificar si la suscripción está vigente
        if (suscripcion.where((element) => element.uid.toString() ==uid.toString()).isNotEmpty) {
          isActive = true;
        }

        DateTime birthdate =
            (personalInfo['birthdate'] as Timestamp?)?.toDate() ??
                DateTime.now();
        String formattedBirthdate = DateFormat('dd/MM/yyyy').format(birthdate);

        var userInfo = {
          'email': authInfo['email'] ?? '',
          'name':
              '${personalInfo['firstName'] ?? ''} ${personalInfo['lastName'] ?? ''}',
          'phoneNumber': personalInfo['phoneNumber'][0]['phoneNumber'] ?? 'N/A',
          'photoUrl': authInfo['photoUrl'] ?? 'N/A',
          'uid': uid,
          'sex': personalInfo['sex'] == 0 ? 'Masculino' : 'Femenino',
          'birthday': formattedBirthdate,
          'age': DateTime.now().year - birthdate.year,
          'points': data['points'] ?? 0,
          'document': personalInfo['documents']?[0]['value'] ?? 'N/A',
          'totalPaid': data['montoTotal'] ?? 0,
          'endDate': suscripcion.where((element) => element.uid.toString() ==uid.toString()).isNotEmpty 
              ? DateFormat('dd/MM/yyyy').format(suscripcion.firstWhere((element) => element.uid.toString() ==uid.toString()).setDate.toDate())
              : (data['points']?? 0) > 0 ? 'Vencida' : 'No tiene',
        };

        if (isActive) {
          activeUsers.add(userInfo);
        } else {
          inactiveUsers.add(userInfo);
        }
      }

      setState(() {
        _activeUsers = activeUsers;
        _inactiveUsers = inactiveUsers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar usuarios: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadExcel(
      String fileName, List<Map<String, dynamic>> users) async {
    var excel = Excel.createExcel();
    excel.delete('Sheet1');
    var sheet = excel[fileName];

    sheet.appendRow([
      TextCellValue('Email'),
      TextCellValue('Nombre'),
      TextCellValue('Teléfono'),
      TextCellValue('Foto'),
      TextCellValue('Sexo'),
      TextCellValue('Cumpleaños'),
      TextCellValue('Edad'),
      TextCellValue('Puntos'),
      TextCellValue('Documento'),
      TextCellValue('Total Pagado'),
      TextCellValue('Fecha Fin')
    ]);

    for (var user in users) {
      sheet.appendRow([
        TextCellValue(user['email']),
        TextCellValue(user['name']),
        TextCellValue(user['phoneNumber']),
        TextCellValue(user['photoUrl']),
        TextCellValue(user['sex']),
        TextCellValue(user['birthday']),
        TextCellValue(user['age'].toString()),
        TextCellValue(user['points'].toString()),
        TextCellValue(user['document']),
        TextCellValue(user['totalPaid'].toString()),
        TextCellValue(user['endDate']),
      ]);
    }

    var bytes = excel.encode();
    if (bytes != null) {
      var blob = html.Blob([bytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      var url = html.Url.createObjectUrlFromBlob(blob);
      var anchor = html.AnchorElement(href: url)
        ..setAttribute('download', '$fileName.xlsx')
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutMain(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Usuarios',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Buscar por nombre',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      var currentTab = _tabController.index;
                      if (currentTab == 0) {
                        _downloadExcel('usuarios_activos', _activeUsers);
                      } else {
                        _downloadExcel('usuarios_inactivos', _inactiveUsers);
                      }
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Exportar'),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Activos'),
                Tab(text: 'Inactivos'),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildUserTable(_activeUsers),
                        _buildUserTable(_inactiveUsers),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTable(List<Map<String, dynamic>> users) {
    final filteredUsers = users.where((user) {
      final query = _searchController.text.toLowerCase();
      return user['name'].toLowerCase().contains(query);
    }).toList();

    return SingleChildScrollView(
      child: PaginatedDataTable(
        columns: const [
          DataColumn(label: Text('Nombre')),
          DataColumn(label: Text('Puntos')),
          DataColumn(label: Text('Vigencia')),
          DataColumn(label: Text('Foto')),
        ],
        source: _UsersDataSource(filteredUsers),
        rowsPerPage: 5,
      ),
    );
  }
}

class _UsersDataSource extends DataTableSource {
  final List<Map<String, dynamic>> users;

  _UsersDataSource(this.users);

  @override
  DataRow getRow(int index) {
    final user = users[index];
    return DataRow(
      cells: [
        DataCell(Text(user['name'])),
        DataCell(Text(user['points'].toString())),
        DataCell(Text(user['endDate'])),
        DataCell(user['photoUrl'] != 'N/A'
            ? CircleAvatar(backgroundImage: NetworkImage(user['photoUrl']))
            : const Icon(Icons.person)),
      ],
    );
  }

  @override
  int get rowCount => users.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class SuscripcionModel {
  dynamic setDate;
  final String uid;
  final String id;
  SuscripcionModel(
      {required this.setDate, required this.uid, required this.id});
}
