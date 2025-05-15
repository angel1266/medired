import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reportes_medired/layout_main.dart';
import 'package:reportes_medired/register_pss.dart';

class PSSListPage extends StatefulWidget {
  @override
  _PSSListPageState createState() => _PSSListPageState();
}

class _PSSListPageState extends State<PSSListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _pssData = [];
  List<Map<String, dynamic>> _filteredData = [];
  bool _isLoading = true;

  final String defaultLogo = 'assets/images/logop.png';

  @override
  void initState() {
    super.initState();
    _fetchPSSData();
    _searchController.addListener(_filterResults);
  }

  Future<void> _fetchPSSData() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('member')
          .where('memberInfo.memberType', isEqualTo: 2)
          .get();

      List<Map<String, dynamic>> pssList = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String id = doc.id;

        // Obtener nombre del prestador
        String name = data['companyInfo']?['name'] ?? 'Sin nombre';

        // Obtener imagen del prestador
        String? logo = data['authInfo']?['photoUrl'];
        bool hasValidLogo = logo != null && logo.isNotEmpty;

        // Obtener servicios
        List<dynamic> medicalTests = data['medicalTests'] ?? [];
        List<String> services = medicalTests.map<String>((test) {
          return test['name'] ?? 'Servicio desconocido';
        }).toList();

        // Obtener información de documentos
        List<dynamic> documents = data['companyInfo']?['documents'] ?? [];
        String documentInfo = documents.isNotEmpty
            ? 'Doc: ${documents[0]['value'] ?? 'N/A'}'
            : 'N/A';

        // Agregar a la lista
        pssList.add({
          'id': id,
          'name': name,
          'logo': hasValidLogo ? logo : defaultLogo,
          'services': services,
          'documents': documentInfo,
        });
      }

      setState(() {
        _pssData = pssList;
        _filteredData = _pssData;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    }
  }

  void _filterResults() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _pssData.where((pss) {
        final name = pss['name'].toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<void> _markAsDeleted(String docId) async {
    final bool confirmed = await _showDeleteConfirmation();
    if (confirmed) {
      _firestore
          .collection('member')
          .doc(docId)
          .update({'memberInfo.memberType': -2}).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prestador eliminado correctamente')),
        );
        _fetchPSSData();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el Prestador: $error')),
        );
      });
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text(
                '¿Está seguro de eliminar este prestador? Esta acción no se puede deshacer.'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child:
                    const Text('Eliminar', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutMain(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Listado de Prestadores',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ServiceProviderSignUpForm()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Prestador'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Buscar por nombre',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: SizedBox(
                              width: double.infinity,
                              child: PaginatedDataTable(
                                header: const Text('Lista de Prestadores'),
                                columns: const [
                                  DataColumn(label: Text('Logo')),
                                  DataColumn(label: Text('Nombre')),
                                  DataColumn(label: Text('Servicios')),
                                  DataColumn(label: Text('Documentos')),
                                  DataColumn(label: Text('Acciones')),
                                ],
                                source: _PSSDataSource(
                                  pssData: _filteredData,
                                  onEdit: (id) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ServiceProviderSignUpForm(
                                                    id: id)));
                                  },
                                  onDelete: _markAsDeleted,
                                ),
                                rowsPerPage:
                                    (constraints.maxHeight ~/ 80).clamp(5, 20),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PSSDataSource extends DataTableSource {
  final List<Map<String, dynamic>> pssData;
  final Function(String) onEdit;
  final Function(String) onDelete;

  _PSSDataSource({
    required this.pssData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= pssData.length) return null;

    final pss = pssData[index];
    return DataRow(cells: [
      DataCell(CircleAvatar(
        backgroundImage: pss['logo'].startsWith('assets')
            ? AssetImage(pss['logo']) as ImageProvider
            : NetworkImage(pss['logo']),
      )),
      DataCell(Text(pss['name'])),
      DataCell(
        PopupMenuButton<String>(
          itemBuilder: (context) {
            return pss['services'].map<PopupMenuEntry<String>>((service) {
              return PopupMenuItem<String>(
                value: service,
                child: Text(service),
              );
            }).toList();
          },
          child: const Text('Ver Servicios'),
        ),
      ),
      DataCell(Text(pss['documents'])),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => onEdit(pss['id']),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDelete(pss['id']),
          ),
        ],
      )),
    ]);
  }

  @override
  int get rowCount => pssData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
