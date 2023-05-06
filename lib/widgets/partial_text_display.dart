import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/cryptext.dart';

// Styles
import 'package:veil/styles/styles.dart';

class PartialTextDisplay extends StatefulWidget {
  final Cryptext cryptext;

  PartialTextDisplay({
    super.key,
    cryptext,
  })
  : this.cryptext = cryptext ?? Cryptext.fromString('');

  @override
  State<PartialTextDisplay> createState() => _PartialTextDisplay();
}

class _PartialTextDisplay extends State<PartialTextDisplay> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        readOnly: true,
        style: CustomStyle.textFieldEntry,
        //controller: textFieldController,
        controller: TextEditingController(text: widget.cryptext.lettersAsString),

        keyboardType: TextInputType.text,

        textInputAction: TextInputAction.done,
        maxLines: 1,

        // Styling.
        cursorColor: CustomStyle.pageScheme.onPrimary,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: CustomStyle.pageScheme.onPrimary, width: 1)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: CustomStyle.pageScheme.onPrimary, width: 1)
          ),
        ),
      ),
    );
  }
}