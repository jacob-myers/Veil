import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';

// Styles
import 'package:veil/styles/styles.dart';

class DisabledTextDisplay extends StatefulWidget {
  final String? title;
  final String content;

  const DisabledTextDisplay({
    super.key,
    this.title,
    required this.content,
  });


  @override
  State<DisabledTextDisplay> createState() => _DisabledTextDisplay();
}

class _DisabledTextDisplay extends State<DisabledTextDisplay> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title != null ? Text(widget.title!, style: CustomStyle.headers) : Container(),

          SizedBox(height: 10),

          IntrinsicHeight(
            child: TextField(
              style: CustomStyle.disabledTextEntry,
              controller: TextEditingController(text: widget.content),
              enabled: false,

              // Styling.
              cursorColor: CustomStyle.pageScheme.onPrimary,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomStyle.disabledTextEntryBorderColor, width: 1)
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
