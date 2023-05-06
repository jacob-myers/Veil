import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';

// Styles
import 'package:veil/styles/styles.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class ShiftAmountEntry extends StatefulWidget {
  final Alphabet alphabet;
  final Function(int?) setShift;
  final String title;
  final String hintText;
  final int shift;

  const ShiftAmountEntry({
    super.key,
    required this.alphabet,
    required this.setShift,
    this.title = 'Shift amount (k)',
    this.hintText = 'Enter a shift...',
    this.shift = 0,
  });

  @override
  State<ShiftAmountEntry> createState() => _ShiftAmountEntry();
}

class _ShiftAmountEntry extends State<ShiftAmountEntry> {
  FocusNode focusNode = FocusNode();
  String? shiftAmountError;
  TextEditingController textFieldController = TextEditingController();

  void setText() {
    setState(() {
      int oldOffsetFromEnd = textFieldController.text.length - textFieldController.selection.base.offset;
      textFieldController = TextEditingController(text: widget.shift.toString());
      if (widget.shift == 0) { textFieldController = TextEditingController(text: ''); }
      textFieldController.selection = TextSelection.collapsed(offset: textFieldController.text.length - oldOffsetFromEnd);
    });
  }

  @override
  Widget build(BuildContext context) {
    setText();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(widget.title, style: CustomStyle.headers),

          SizedBox(height: 10),

          IntrinsicHeight(
            child: Focus(
              child: TextField(
                style: CustomStyle.textFieldEntry,

                keyboardType: TextInputType.text,

                focusNode: focusNode,
                controller: textFieldController,

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
                  errorText: shiftAmountError,
                  hintText: widget.hintText,

                ),

                onSubmitted: (String str) {
                  focusNode.requestFocus();
                },

                // When the text is changed.
                onChanged: (String str)
                {
                  setState(() {
                    //print(str);
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
                }
              ),

              onFocusChange: (hasFocus) {
                setState(() {
                  if (!hasFocus) {
                    shiftAmountError = null;
                  }
                });
              },
            )
          ),

        ],
      ),
    );
  }
}
