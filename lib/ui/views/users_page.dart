import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/core/value_objects/document_type.dart';
import 'package:medired/core/value_objects/subscription_type.dart';
import 'package:medired/core/value_objects/user_sex.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:medired/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/profile_picture.dart';
import 'package:medired/ui/organisms/company_update_info_form.dart';
import 'package:medired/ui/organisms/patient_update_info_form.dart';
import 'package:medired/ui/organisms/personal_info_form.dart';
import 'package:medired/ui/organisms/subscription_info.dart';
import 'package:medired/ui/template/profile_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:medired/core/database/collections.dart';
import 'package:medired/widget/web_data_column.dart';
import 'package:medired/widget/web_data_table.dart';

import '../../widget/web_data_table_source.dart';


class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<PrestadorModel> prestador = [];
  List<SuscripcionModel> suscripcion = [];

  Future<List<dynamic>> getDocs(String table, String field, dynamic filter,
      {String tipo = "servicio", fecha = false, bool igual = true}) async {
    final QuerySnapshot? querySnapshot;

    if (fecha) {
      querySnapshot = await FirebaseFirestore.instance
          .collection(table)
          .where(field, isGreaterThan: filter)
          .get();
    } else {
      if (igual) {
        querySnapshot = await FirebaseFirestore.instance
            .collection(table)
            .where(field, isEqualTo: filter)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection(table)
            .where(field, isNotEqualTo: filter)
            .get();
      }
    }

    List<QueryDocumentSnapshot> documentos = querySnapshot.docs;
    if (tipo == "servicio") {
      documentos.sort((a, b) => a['nombre'].compareTo(b['nombre']));
    } else if (tipo == "miembros") {
      documentos.sort((a, b) => a['personalInfo']["firstName"]
          .compareTo(b['personalInfo']["firstName"]));
    }

    List<dynamic> list = [];

    for (var doc in documentos) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      list.add([data, doc.id]);
    }
    return list;
  }

  Future<void> _fetchMiembros() async {
    try {
      List<dynamic> fetchedData = await getDocs(
          'member', 'memberInfo.memberType', 2,
          igual: false, tipo: "miembros");

      setState(() {
        prestador = fetchedData.map((entry) {
          return PrestadorModel(
              id: entry[1],
              dni: entry[0]["personalInfo"]["documents"][0]["value"] ?? "",
              phone: entry[0]["personalInfo"]["phoneNumber"][0]
                      ["phoneNumber"] ??
                  "",
              email: entry[0]["authInfo"]["email"] ?? "",
              photo: entry[0]["authInfo"]["photoUrl"] ?? "",
              firname: entry[0]["personalInfo"]["firstName"],
              fullname: (entry[0]["personalInfo"]["firstName"] ?? "") +
                  " " +
                  (entry[0]["personalInfo"]["lastName"] ?? ""),
              status: suscripcion.isNotEmpty
                  ? suscripcion
                          .where((element) => element.uid == entry[1])
                          .isNotEmpty
                      ? true
                      : false
                  : false);
        }).toList();
      });
    } catch (e) {
      debugPrint('Error prestador fetching data: $e');
    }
  }

  Future<void> _fetchSuscripcion() async {
    try {
      List<dynamic> fetchedData = await getDocs(
          'subscription', 'setDate', Timestamp.now(),
          tipo: "suscripcion", fecha: true);

      setState(() {
        suscripcion = fetchedData.map((entry) {
          return SuscripcionModel(
              id: entry[1], uid: entry[0]["uid"], setDate: entry[0]["setDate"]);
        }).toList();
      });
      _fetchMiembros();
    } catch (e) {
      debugPrint('Error prestador fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSuscripcion();
  }

  TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> _filteredUsers = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                (previous is AuthenticatedState &&
                        current is AuthenticatedState) &&
                    (previous.user != current.user) ||
                (previous is LoadingAuthState && current is AuthenticatedState),
            listener: _authListener,
          ),
          BlocListener<SubscriptionBloc, SubscriptionState>(
            listener: _subscriptionListener,
          )
        ],
        child: MyApp(
          list: prestador,
        ));
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthenticatedState) {
      context.read<ProfileBloc>().add(LoadProfile(auth: state.user));
      context
          .read<SubscriptionBloc>()
          .add(StartListeningSubscription(uid: state.user.authInfo.uid!));
      context
          .read<SubscriptionBloc>()
          .add(GetSubscription(uid: state.user.authInfo.uid!));
    }
  }

  void _subscriptionListener(BuildContext context, SubscriptionState state) {
    if (state is SuccessGetSubscription) {
      var profileState = context.read<ProfileBloc>().state;
      if (profileState is ProfileLoaded<Patient>) {
        context.read<ProfileBloc>().add(LoadProfile(
              auth: profileState.user.copyWith(
                memberInfo: profileState.user.memberInfo.copyWith(
                  subscriptionType: state.subscription.subscriptionType,
                ),
              ),
            ));
      }
    } else if (state is SuccessListenSubscription) {
      var profileState = context.read<ProfileBloc>().state;
      if (profileState is ProfileLoaded<Patient>) {
        context.read<ProfileBloc>().add(LoadProfile(
              auth: profileState.user.copyWith(
                memberInfo: profileState.user.memberInfo.copyWith(
                  subscriptionType: state.subscription.subscriptionType,
                ),
              ),
            ));
      }
    }
  }
}

class MyApp extends StatefulWidget {
  List<PrestadorModel> list;
  MyApp({required this.list});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String _sortColumnName;
  late bool _sortAscending;
  List<String> _filterTexts = [];
  bool _willSearch = true;
  Timer? _timer;
  int? _latestTick;
  List<String> _selectedRowKeys = [];
  int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _sortColumnName = 'browser';
    _sortAscending = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_willSearch) {
        if (_latestTick != null && timer.tick > _latestTick!) {
          _willSearch = true;
        }
      }
      if (_willSearch) {
        _willSearch = false;
        _latestTick = null;
        setState(() {
          if (_filterTexts != null && _filterTexts!.isNotEmpty) {
            _filterTexts = _filterTexts;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  String getInitials(String? name, String? id) {
    if (name == null || name.isEmpty) {
      return '';
    }
    return name
            .split(' ')
            .map((word) => word.isNotEmpty ? word[0] : "")
            .join() +
        (id!.substring(id.length - 4));
  }

  List<Map<String, dynamic>> getData() {
    List<Map<String, dynamic>> rows;
    List<dynamic> lista = [];
//widget.list[i].fullname[0].toUpperCase() + widget.list[i].fullname.substring(1)
    if (widget.list.isNotEmpty) {
      for (var i = 0; i < widget.list.length; i++) {
        if (widget.list[i].dni != "" && widget.list[i].fullname != "") {
          var nombre = "";
        
          widget.list[i].fullname.split(' ').forEach((nom) { 
            if(nom.isNotEmpty){
               nombre += nom[0].toUpperCase() +nom.substring(1)+" ";
            }

           });
          lista.add([
            '${nombre}',
            '${widget.list[i].dni}',
            '${widget.list[i].phone}',
            '${widget.list[i].email}',
            '${widget.list[i].firname != null && widget.list[i].firname != "" ? getInitials(widget.list[i].firname, widget.list[i].id) : ''}',
            '${widget.list[i].status ? 'Activo' : 'Sin Suscripción'}',
          ]);
        }
      }
    }
    rows = lista.map((dat) {
      return {
        'nombre': dat[0],
        'dni': dat[1],
        'phone': dat[2],
        'email': dat[3],
        'carnet': dat[4],
        'status': dat[5],
      };
    }).toList();

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(8.0),
        child: WebDataTable(
          header: Text('Lista de Usuarios'),
          actions: [
            Container(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar Usuario',
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ),
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    for (var i = 0; i < text.trim().split(' ').length; i++) {
                      _filterTexts = [];
                      _filterTexts.add(
                          text.trim().split(' ')[i][0].toUpperCase() +
                              text.trim().split(' ')[i].substring(1));
                    }
                    _willSearch = false;
                  _latestTick = _timer?.tick;

                  } else {
                    _filterTexts = [];
                  }

                  
                },
              ),
            ),
          ],
          source: WebDataTableSource(
            sortColumnName: _sortColumnName,
            sortAscending: _sortAscending,
            filterTexts: _filterTexts,
            columns: [
              WebDataColumn(
                name: 'nombre',
                label: const Text('Nombre'),
                dataCell: (value) => DataCell(Text('$value')),
              ),
              WebDataColumn(
                name: 'dni',
                label: const Text('Cedula'),
                dataCell: (value) => DataCell(Text('$value')),
              ),
              WebDataColumn(
                name: 'phone',
                label: const Text('Teléfono'),
                dataCell: (value) => DataCell(Text('$value')),
              ),
              WebDataColumn(
                name: 'email',
                label: const Text('Correo'),
                dataCell: (value) => DataCell(Text('$value')),
              ),
              WebDataColumn(
                name: 'carnet',
                label: const Text('Carnet'),
                dataCell: (value) => DataCell(Text('$value')),
              ),
              WebDataColumn(
                name: 'status',
                label: const Text('Estatus'),
                dataCell: (value) => DataCell(Text('$value')),
              ),
            ],
            rows: getData(),
            selectedRowKeys: _selectedRowKeys,
            onTapRow: (rows, index) {},
            onSelectRows: (keys) {
              setState(() {
                _selectedRowKeys = keys;
              });
            },
            primaryKeyName: 'id',
          ),
          horizontalMargin: 100,
          onPageChanged: (offset) {},
          onSort: (columnName, ascending) {
            setState(() {
              _sortColumnName = columnName;
              _sortAscending = ascending;
            });
          },
          onRowsPerPageChanged: (rowsPerPage) {
            setState(() {
              if (rowsPerPage != null) {
                _rowsPerPage = rowsPerPage;
              }
            });
          },
          rowsPerPage: _rowsPerPage,
        ),
      ),
    );
  }
}

class PrestadorModel {
  final String fullname;
  final String firname;
  final String phone;
  final String dni;
  final String email;
  final bool status;
  final String id;
  final String photo;

  PrestadorModel(
      {required this.dni,
      required this.phone,
      required this.email,
      required this.fullname,
      required this.id,
      required this.photo,
      required this.firname,
      required this.status});
}

class SuscripcionModel {
  dynamic setDate;
  final String uid;
  final String id;
  SuscripcionModel(
      {required this.setDate, required this.uid, required this.id});
}
