import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/widgets/integer_value_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

class OffsetEntry extends StatefulWidget {
  final Alphabet alphabet;
  final Function(int) setOffset;
  final int offset;

  const OffsetEntry({
    super.key,
    required this.alphabet,
    required this.setOffset,
    this.offset = 0,
  });

  @override
  State<OffsetEntry> createState() => _OffsetEntry();
}

class _OffsetEntry extends State<OffsetEntry> {
  String? error;

  @override
  Widget build(BuildContext context) {
    return IntegerValueEntry(
      title: 'Offset',
      hintText: 'Offset...',
      errorText: error,
      defaultValue: 0,
      value: widget.offset,
      onChanged: (String str) {
        setState(() {
          int? newOffset = int.tryParse(str);
          if (newOffset == null && str == '') {
            // Empty
            error = null;
            widget.setOffset(0);
          }
          else if (newOffset == null) {
            // Didn't parse
            error = 'Invalid Offset';
          }
          else if (newOffset < 0) {
            // Entry if out of range
            error = 'Value out of range';
          }
          else {
            // Valid
            error = null;
            widget.setOffset(newOffset);
          }
        });
      },
    );
  }
}
