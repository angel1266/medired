import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';

class Plan {
  final String name;
  final String costo;
  final int consultas;
  final int laboratorios;
  final int imagenes;
  final int audiometria;
  final int odontologia;

  Plan({
    required this.name,
    required this.costo,
    required this.consultas,
    required this.laboratorios,
    required this.imagenes,
    required this.audiometria,
    required this.odontologia,
  });
}

class PricingTable extends StatefulWidget {
  final List<Plan> planes;
  final double height;
  final double width;
  final Color? selectedRowColor;
  final Color? selectedRowTextColor;
  final Color? unselectedRowColor;
  final Color? unselectedRowTextColor;
  final Color? divicionColor;

  const PricingTable({
    super.key,
    required this.planes,
    required this.height,
    required this.width,
    this.selectedRowColor,
    this.selectedRowTextColor,
    this.unselectedRowColor,
    this.unselectedRowTextColor,
    this.divicionColor,
  });

  @override
  State<PricingTable> createState() => _PricingTableState();
}

class _PricingTableState extends State<PricingTable> {
  int _selectedRow = -1;

  late Color _selectedRowColor;
  late Color _selectedRowTextColor;
  late Color _unselectedRowColor;
  late Color _unselectedRowTextColor;
  late Color _divicionColor;
  double headsizeborder = 10;
  double dividesize = 10;

  @override
  void initState() {
    _selectedRowColor = widget.selectedRowColor ?? Colors.lightGreenAccent;
    _selectedRowTextColor = widget.selectedRowTextColor ?? Colors.white;
    _unselectedRowColor = widget.unselectedRowColor ?? AppColors.blueBackground;
    _unselectedRowTextColor = widget.unselectedRowTextColor ?? Colors.white;
    _divicionColor =
        widget.divicionColor ?? const Color.fromARGB(255, 109, 128, 205);

    headsizeborder = widget.height * 0.06;
    dividesize = widget.width * 0.009;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildHeaderRow(true),
          Flexible(
            child: ListView.builder(
              itemCount: widget.planes.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildRow(widget.planes[index], index);
              },
            ),
          ),
          _buildHeaderRow(false),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(bool point) {
    List<Widget> headerCells = [];

    for (int i = 0; i < 8; i++) {
      headerCells.add(point
          ? _buildHeaderCell(_getTitleByIndex(i))
          : _buildFooterCell(_getTitleByIndex(i)));
      if (i < 7) {
        headerCells.add(
          SizedBox(
            width: dividesize,
          ),
        );
      }
    }

    return Container(
      color: Colors.transparent,
      child: Row(
        children: headerCells,
      ),
    );
  }

  Widget _buildFooterCell(String text) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: text != ''
                ? dividesize * 2
                : dividesize, // Adjust the height to make it visible
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  blurRadius: 7.0,
                  offset: const Offset(0, 8), // Elevación de la sombra
                )
              ],
              color: _unselectedRowColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(dividesize),
                bottomRight: Radius.circular(dividesize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTitleByIndex(int index) {
    switch (index) {
      case 0:
        return '';
      case 1:
        return 'Costo';
      case 2:
        return 'Consultas';
      case 3:
        return 'Laboratorios';
      case 4:
        return 'Imágenes';
      case 5:
        return 'Audiometría';
      case 6:
        return 'Odontología';
      default:
        return '';
    }
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: dividesize, // Adjust the height to make it visible
            decoration: BoxDecoration(
              color: _unselectedRowColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(dividesize),
                topRight: Radius.circular(dividesize),
              ),
            ),
          ),
          text != ''
              ? Container(
                  decoration: BoxDecoration(
                    color: text != '' ? Colors.white : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      text,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: AppColors.blueBackground,
                                //  fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildCell(String text, int index) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _selectedRow == index
                    ? _selectedRowColor
                    : _unselectedRowColor,
              ),
              child: Center(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: _selectedRow == index
                            ? _selectedRowTextColor
                            : _unselectedRowTextColor,
                        //  fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          ),
          Container(
            height: dividesize,
            color: _divicionColor,
          )
        ],
      ),
    );
  }

  Widget _buildRow(
    Plan plan,
    int index,
  ) {
    return InkWell(
      onTap: () {
        _onRowSelected(index);
      },
      child: Container(
        height: widget.height * 0.215, // Altura de cada fila
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.height * 0.215)),
          color: _selectedRow == index
              ? _selectedRowColor.withOpacity(0.7)
              : Colors.transparent,
          boxShadow: _selectedRow == index
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5.0,
                    offset: const Offset(0, 10), // Elevación de la sombra
                  )
                ]
              : null,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                children: [
                  for (int i = 0; i < 8; i++) ...[
                    _buildCell(_getCellData(i, plan).toString(), index),
                    SizedBox(
                      width: i != 7 ? dividesize : 0,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic _getCellData(
    int index,
    Plan plan,
  ) {
    switch (index) {
      case 0:
        return plan.name;
      case 1:
        return plan.costo;
      case 2:
        return plan.consultas;
      case 3:
        return plan.laboratorios;
      case 4:
        return plan.imagenes;
      case 5:
        return plan.audiometria;
      case 6:
        return plan.odontologia;
      default:
        return '';
    }
  }

  void _onRowSelected(int index) {
    setState(() {
      _selectedRow = index;
    });
  }
}
