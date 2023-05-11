import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/functions/cipher_affine.dart';
import 'package:veil/widgets/integer_value_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class DigramTableSizeEntry extends StatefulWidget {
  final Alphabet alphabet;
  final Function(int) setN;
  final int n;

  const DigramTableSizeEntry({
    super.key,
    required this.alphabet,
    required this.setN,
    this.n = 0,
  });

  @override
  State<DigramTableSizeEntry> createState() => _DigramTableSizeEntry();
}

class _DigramTableSizeEntry extends State<DigramTableSizeEntry> {
  String? error;

  @override
  Widget build(BuildContext context) {
    return IntegerValueEntry(
      title: 'Table Size',
      hintText: 'Enter Size...',
      errorText: error,
      value: widget.n,
      onChanged: (String str) {
        setState(() {
          int? newN = int.tryParse(str);
          if (newN == null && str == '') {
            // Empty
            error = null;
            widget.setN(10);
          }
          else if (newN == null) {
            // Didn't parse
            error = 'Invalid Size';
          }
          else if (newN <= 0 || newN > widget.alphabet.length) {
            // Entry is out of range
            error = 'Value out of range';
          }
          else {
            // Valid
            error = null;
            widget.setN(newN);
          }
        });
      },
    );
  }
}
