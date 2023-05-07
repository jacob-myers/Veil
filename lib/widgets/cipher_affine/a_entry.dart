import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/functions/cipher_affine.dart';
import 'package:veil/widgets/integer_value_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class AEntry extends StatefulWidget {
  final Alphabet alphabet;
  final Function(int) setA;
  final int a;

  const AEntry({
    super.key,
    required this.alphabet,
    required this.setA,
    this.a = 1,
  });

  @override
  State<AEntry> createState() => _AEntry();
}

class _AEntry extends State<AEntry> {
  String? error;

  @override
  Widget build(BuildContext context) {
    return IntegerValueEntry(
      alphabet: widget.alphabet,
      title: 'Coefficient A',
      hintText: 'Enter A...',
      errorText: error,
      defaultValue: 1,
      value: widget.a,
      onChanged: (String str) {
        setState(() {
          int? newA = int.tryParse(str);
          if (newA == null && str == '') {
            // Empty
            error = null;
            widget.setA(1);
          }
          else if (newA == null) {
            // Didn't parse
            error = 'Invalid A';
          }
          else if (newA <= 0 || newA > widget.alphabet.length) {
            // Entry is out of range
            error = 'Value out of range';
          }
          else if (!isValidAffineParamsWithMod(newA, widget.alphabet.length)) {
            // A is not relatively prime with mod.
            error = 'Not relatively prime with n.';
            widget.setA(newA);
          }
          else {
            // Valid
            error = null;
            widget.setA(newA);
          }
        });
      },
    );
  }
}
