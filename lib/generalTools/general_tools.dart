import 'package:flutter/material.dart';

/// Flutter code sample for [DropdownButton].

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class CDropdownButton extends StatefulWidget {

  const CDropdownButton({super.key});

  @override
  State<CDropdownButton> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<CDropdownButton> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    final double DW = MediaQuery.of(context).size.width;
    return DropdownMenu<String>(
      //initialSelection: list.first,

      hintText: "Sub Title",
      width: DW * 0.4925,
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        constraints: BoxConstraints.tight(const
        Size.fromHeight(40)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });

      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),

    );
  }
}