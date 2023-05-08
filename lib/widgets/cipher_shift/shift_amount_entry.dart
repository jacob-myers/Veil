import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/widgets/integer_value_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class ShiftAmountEntry extends StatefulWidget {
  final Alphabet alphabet;
  final Function(int?) setShift;
  final int shift;

  const ShiftAmountEntry({
    super.key,
    required this.alphabet,
    required this.setShift,
    this.shift = 0,
  });

  @override
  State<ShiftAmountEntry> createState() => _ShiftAmountEntry();
}

class _ShiftAmountEntry extends State<ShiftAmountEntry> {
  String? shiftAmountError;

  @override
  Widget build(BuildContext context) {
    return IntegerValueEntry(
      title: 'Shift of plaintext (k)',
      hintText: 'Enter a shift...',
      errorText: shiftAmountError,
      value: widget.shift,
      onChanged: (String str) {
        setState(() {
          int? newShift = int.tryParse(str);
          if (newShift == null && str == '') {
            // Empty
            shiftAmountError = null;
            widget.setShift(0);
          }
          else if (newShift == null) {
            // Didn't parse
            shiftAmountError = 'Invalid Shift';
          }
          else if (newShift >= 0 && newShift < widget.alphabet.length) {
            // Valid
            shiftAmountError = null;
            widget.setShift(newShift);
          }
          else {
            // Entry is out of range
            shiftAmountError = 'Shift out of range';
          }
        });
      },
    );
  }
}
