import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';

// Styles
import 'package:veil/styles/styles.dart';
import 'package:veil/widgets/string_value_entry.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class GridEditable extends StatefulWidget {
  final String? title;
  List<String> colTitles;
  List<String> rowTitles;
  List<List<String?>> values;
  Function(String) onValueChange;
  int? charLimit;

  GridEditable({
    super.key,
    this.title,
    required this.colTitles,
    required this.rowTitles,
    required this.values,
    required this.onValueChange,
    this.charLimit
  });

  @override
  State<GridEditable> createState() => _GridEditable();
}
class _GridEditable extends State<GridEditable> {
  @override
  Widget build(BuildContext context) {
    int colCount = widget.colTitles.length;
    int rowCount = widget.rowTitles.length;
    double colsHeight = 50;
    double rowsWidth = 50;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: rowsWidth, height: colsHeight),
            Expanded(
              child: Row(
                children: List.generate(colCount, (index) => Expanded(
                  child: Text(
                    widget.colTitles[index],
                    style: CustomStyle.bodyLargeText,
                    textAlign: TextAlign.center,
                  ))
                ),
              ),
            )
          ],
        ),

        Row(
          children: [
            Expanded(
              child: Column(
                children: List.generate(rowCount, (index_r) => Row(
                  children: <Widget>[
                    SizedBox(
                      width: rowsWidth,
                      child: Text(
                        widget.colTitles[index_r],
                        style: CustomStyle.bodyLargeText,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ] + List<Widget>.generate(colCount, (index_c) => Expanded(
                    child: StringValueEntry(
                      style: CustomStyle.textFieldEntry.copyWith(fontSize: 20),
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 3.0, bottom: 3.0),
                      textAlign: TextAlign.center,
                      borderRadius: BorderRadius.zero,
                      hintText: "",
                      value: widget.values[index_r][index_c] ?? "",
                      maxLength: 1,
                      onChanged: (String str) {
                        setState(() {
                          widget.values[index_r][index_c] = str;
                          widget.onValueChange(str);
                        });
                      },
                    )
                  )),
                )),
              ),
            ),
          ],
        )
      ]
    );

  }

}
