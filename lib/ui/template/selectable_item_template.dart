import 'package:flutter/material.dart';

import 'package:medired/core/utils/selectable_item.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';

class SelectableItemTemplate<T> extends StatefulWidget {
  const SelectableItemTemplate({
    super.key,
    required this.items,
    required this.onSelected,
    required this.hintText,
  });

  final List<SelectableItem<T>> items;
  final Function(SelectableItem<T>) onSelected;
  final String hintText;

  @override
  State<SelectableItemTemplate<T>> createState() =>
      _SelectableItemTemplateState<T>();
}

class _SelectableItemTemplateState<T> extends State<SelectableItemTemplate<T>> {
  late SelectableItem<T> selectedItem;
  late List<SelectableItem<T>> items;

  @override
  void initState() {
    items = widget.items;
    super.initState();
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: CustomTextFormField(
        'Escribe para buscar',
        hintText: widget.hintText,
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              items = widget.items;
            });
          }
          setState(() {
            items = widget.items
                .where((e) => e.title.toLowerCase().contains(
                      value.toLowerCase(),
                    ))
                .toList();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchField(),
        _buildList(),
      ],
    );
  }

  Expanded _buildList() {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(items[index].title),
          onTap: () {
            widget.onSelected(items[index]);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
