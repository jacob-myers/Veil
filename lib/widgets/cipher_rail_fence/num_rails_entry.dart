import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/widgets/integer_value_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

class NumRailsEntry extends StatefulWidget {
  final Alphabet alphabet;
  final Function(int) setNumRails;
  final int numRails;

  const NumRailsEntry({
    super.key,
    required this.alphabet,
    required this.setNumRails,
    this.numRails = 1,
  });

  @override
  State<NumRailsEntry> createState() => _NumRailsEntry();
}

class _NumRailsEntry extends State<NumRailsEntry> {
  String? error;

  @override
  Widget build(BuildContext context) {
    return IntegerValueEntry(
      title: 'Number of Rails',
      hintText: 'Rails...',
      errorText: error,
      defaultValue: 1,
      value: widget.numRails,
      onChanged: (String str) {
        setState(() {
          int? newNumRails = int.tryParse(str);
          if (newNumRails == null && str == '') {
            // Empty
            error = null;
            widget.setNumRails(1);
          }
          else if (newNumRails == null) {
            // Didn't parse
            error = 'Invalid amount';
          }
          else if (newNumRails < 1) {
            // Entry if out of range
            error = 'Value out of range';
          }
          else {
            // Valid
            error = null;
            widget.setNumRails(newNumRails);
          }
        });
      },
    );
  }
}
