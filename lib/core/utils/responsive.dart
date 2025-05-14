import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart';

Future<dynamic> showAdaptiveSheet(
    {required BuildContext context,
    required Widget body,
    required double bottomSheetHeight}) async {
  if (MediaQuery.of(context).size.width >= 425) {
    return SideSheet.right(
      width: 425,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: body,
      ),
      context: context,
    );
  } else {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // set this to true
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * bottomSheetHeight,
              child: body,
            );
          },
        ),
      ),
    );
  }
}
