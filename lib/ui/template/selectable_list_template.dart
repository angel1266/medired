import 'package:flutter/material.dart';

import 'package:medired/core/router/router.dart';

class SelectableListTemplate<T> extends StatefulWidget {
  const SelectableListTemplate(
      {super.key,
      required this.items,
      required this.options,
      required this.onSubmit});

  final List<MapEntry<T, bool>> items;

  final List<String> options;

  final Function(List<MapEntry<T, bool>>) onSubmit;

  @override
  State<SelectableListTemplate<T>> createState() =>
      _SelectableListTemplateState<T>();
}

class _SelectableListTemplateState<T> extends State<SelectableListTemplate<T>> {
  late List<MapEntry<T, bool>> items;

  @override
  void initState() {
    super.initState();

    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.items.length,
            itemBuilder: (context, index) => CheckboxListTile(
              value: items[index].value,
              onChanged: (value) => setState(() {
                items[index] =
                    MapEntry(widget.items[index].key, value ?? false);
              }),
              title: Text(widget.options[index]),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  widget.onSubmit(items);
                  router.pop();
                },
                child: const Text('Guardar'),
              )),
            ],
          )
        ],
      ),
    );
  }
}
