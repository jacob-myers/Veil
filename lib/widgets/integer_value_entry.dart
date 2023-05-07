import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';

// Styles
import 'package:veil/styles/styles.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class IntegerValueEntry extends StatefulWidget {
  final Function(String) onChanged;
  final String? title;
  final String hintText;
  final String? errorText;
  final int defaultValue;
  final int value;

  const IntegerValueEntry({
    super.key,
    required this.onChanged,
    this.title,
    this.hintText = 'Enter a value...',
    this.errorText,
    this.defaultValue = 0,
    this.value = 0,
  });

  @override
  State<IntegerValueEntry> createState() => _IntegerValueEntry();
}

class _IntegerValueEntry extends State<IntegerValueEntry> {
  FocusNode focusNode = FocusNode();
  TextEditingController textFieldController = TextEditingController();
  bool hideError = true;

  void setText() {
    setState(() {
      int oldOffsetFromEnd = textFieldController.text.length - textFieldController.selection.base.offset;
      textFieldController = TextEditingController(text: widget.value.toString());
      if (widget.value == widget.defaultValue) { textFieldController = TextEditingController(text: ''); }
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

          widget.title != null ? Text(widget.title!, style: CustomStyle.headers) : Container(),

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
                  errorText: hideError ? null : widget.errorText,
                  hintText: widget.hintText,
                ),

                onSubmitted: (String str) {
                  focusNode.requestFocus();
                },

                // When the text is changed.
                onChanged: (String str) {
                  hideError = false;
                  widget.onChanged(str);
                }
              ),

              onFocusChange: (hasFocus) {
                setState(() {
                  if (!hasFocus) {
                    hideError = true;
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
