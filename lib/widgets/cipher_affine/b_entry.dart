import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/functions/cipher_affine.dart';
import 'package:veil/widgets/integer_value_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class BEntry extends StatefulWidget {
  final Alphabet alphabet;
  final Function(int) setB;
  final int b;

  const BEntry({
    super.key,
    required this.alphabet,
    required this.setB,
    this.b = 1,
  });

  @override
  State<BEntry> createState() => _BEntry();
}

class _BEntry extends State<BEntry> {
  String? error;

  @override
  Widget build(BuildContext context) {
    return IntegerValueEntry(
      title: 'Coefficient B',
      hintText: 'Enter B...',
      errorText: error,
      defaultValue: 0,
      value: widget.b,
      onChanged: (String str) {
        setState(() {
          int? newB = int.tryParse(str);
          if (newB == null && str == '') {
            // Empty
            error = null;
            widget.setB(0);
          }
          else if (newB == null) {
            // Didn't parse
            error = 'Invalid B';
          }
          else if (newB <= 0 || newB > widget.alphabet.length) {
            // Entry is out of range
            error = 'Value out of range';
          }
          else {
            // Valid
            error = null;
            widget.setB(newB);
          }
        });
      },
    );
  }
}