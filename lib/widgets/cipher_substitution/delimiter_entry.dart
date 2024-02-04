import 'package:flutter/material.dart';

// Styles
import 'package:veil/widgets/string_value_entry.dart';

class DelimiterEntry extends StatefulWidget {
  final String value;
  final Function(String) onChanged;

  const DelimiterEntry({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<DelimiterEntry> createState() => _DelimiterEntry();
}

class _DelimiterEntry extends State<DelimiterEntry> {
  @override
  Widget build(BuildContext context) {
    return StringValueEntry(
      value: widget.value,
      hintText: "...",
      maxLength: 1,
      padding: const EdgeInsets.only(left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
      onChanged: (String str) {
        widget.onChanged(str);
      },
    );
  }
}