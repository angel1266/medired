import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:medired/ui/molecules/custom_flex.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({
    super.key,
    required this.rows,
    this.rowsDecoration,
    this.columnsDecoration,
    this.cellPadding,
    this.cellAlignment = Alignment.center,
    this.rowsHeight,
    this.rowSeparation = 0,
    this.columnSeparation = 0,
    this.tableMode = CustomTableMode.rowsOnColumns,
    this.headerDecoration, required List<StatelessWidget> header,
  });

  final List<List<Widget?>> rows;
  final List<BoxDecoration?>? rowsDecoration;
  final List<BoxDecoration?>? columnsDecoration;
  final EdgeInsetsGeometry? cellPadding;
  final AlignmentGeometry cellAlignment;
  final List<double?>? rowsHeight;
  final double rowSeparation;
  final double columnSeparation;
  final CustomTableMode tableMode;
  final BoxDecoration? headerDecoration;

  @override
  Widget build(BuildContext context) {
    return CustomFlex(
      direction: Axis.vertical,
      children: getRows(),
    );
  }

  List<Widget> getRows() {
    var mapedRows = rows
        .mapIndexed<Widget>(
          (rowIndex, rowElements) => IntrinsicHeight(
            child: CustomFlex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rowElements
                  .mapIndexed((cellIndex, cellElement) =>
                      getCell(rowIndex, cellIndex, cellElement))
                  .toList(),
            ),
          ),
        )
        .toList();

    if (rowSeparation > 0 && mapedRows.isNotEmpty) {
      mapedRows = mapedRows
          .expandIndexed(
            (rowIndex, element) => [
              element,
              Row(
                children: rows[rowIndex]
                    .mapIndexed(
                      (cellIndex, element) => Expanded(
                        child: Container(
                          height: rowSeparation,
                          decoration: modulatedIndex(
                            columnsDecoration,
                            cellIndex,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          )
          .toList();
      mapedRows.removeLast();
    }

    return mapedRows.toList();
  }

  Widget getCell(int rowIndex, int cellIndex, Widget? cellElement) {
    return Expanded(
      child: Container(
        decoration: (() {
          if (tableMode == CustomTableMode.columnsOnRows) {
            return getRowsDecoration(rowIndex);
          } else {
            return modulatedIndex(
              columnsDecoration,
              cellIndex,
            );
          }
        })(),
        height: modulatedIndex(rowsHeight, rowIndex),
        child: Container(
          decoration: (() {
            if (tableMode == CustomTableMode.rowsOnColumns) {
              return getRowsDecoration(rowIndex);
            } else {
              return modulatedIndex(
                columnsDecoration,
                cellIndex,
              );
            }
          })(),
          alignment: cellAlignment,
          child: cellElement,
        ),
      ),
    );
  }

  BoxDecoration? getRowsDecoration(int index) {
    if (headerDecoration != null) {
      if(index == 0){
        return headerDecoration;
      }

      index -= 1;
    }

    if (index >= 0) {
      return modulatedIndex(rowsDecoration, index);
    }

    return null;
  }

  T? modulatedIndex<T>(
    List<T?>? array,
    int index,
  ) {
    if (array == null || array.isEmpty) {
      return null;
    }

    return array[index % array.length];
  }
}

enum CustomTableMode {
  columnsOnRows,
  rowsOnColumns,
}
