//このファイルは使ってないので無視して良いです！

import 'package:flutter/material.dart';

class FilteredCard extends StatelessWidget {
  final String label;
  final bool currentValue;
  final void Function(bool?) updateValue;

  FilteredCard({
    Key? key,
    required this.label,
    required this.currentValue,
    required this.updateValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Text(label),
            ),
          ),
          Checkbox(
            value: currentValue,
            onChanged: updateValue,
          ),
        ],
      ),
    );
  }
}
