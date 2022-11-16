import 'package:flutter/material.dart';

class SelectableItem<T> {
  final Widget item;
  final T value;

  SelectableItem({required this.item, required this.value});
}

class DropDownSelect<T> extends StatelessWidget {
  final List<SelectableItem<T>> selectableItems;
  final Widget defaultItem;
  final void Function(T?) onSelect;
  final TextStyle? textStyle;
  const DropDownSelect({
    super.key,
    required this.selectableItems,
    required this.defaultItem,
    required this.onSelect,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: selectableItems
          .map((e) => DropdownMenuItem<T>(
                value: e.value,
                child: e.item,
              ))
          .toList(),
      onChanged: onSelect,
      hint: defaultItem,
      style: textStyle,
    );
  }
}
