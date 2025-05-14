import 'package:flutter/material.dart';
import 'package:medired/ui/template/base_desktop_template.dart';

class MassiveUploadTemplate extends StatelessWidget {
  const MassiveUploadTemplate({
    required this.isLoading,
    required this.table,
    required this.uploadFile,
    required this.uploadBatch,
    required this.cancel,
    super.key,
  });

  final bool isLoading;
  final Widget table;
  final Widget uploadFile;
  final Widget uploadBatch;
  final Widget cancel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          return BaseDesktopTemplate(
            leftFlex: 5,
            rightFlex: 2,
            left: isLoading
                ? const Center(child: CircularProgressIndicator())
                : table,
            right: SingleChildScrollView(
              child: Column(children: [
                uploadFile,
                Row(children: [
                  Expanded(child: uploadBatch),
                  const SizedBox(width: 8),
                  Expanded(child: cancel),
                ],),
              ]),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
