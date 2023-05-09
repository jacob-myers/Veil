import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';

// Styles
import 'package:veil/styles/styles.dart';
import 'package:veil/widgets/my_text_button.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class StringValueEntry extends StatefulWidget {
  final Function(String) onChanged;
  final String? title;
  final String hintText;
  final String? errorText;
  final bool showResetButton;
  final String defaultValue;
  final String value;

  const StringValueEntry({
    super.key,
    required this.onChanged,
    this.title,
    this.hintText = 'Enter a value...',
    this.errorText,
    this.showResetButton = false,
    this.defaultValue = "",
    this.value = "",
  });

  @override
  State<StringValueEntry> createState() => _StringValueEntry();
}

class _StringValueEntry extends State<StringValueEntry> {
  FocusNode focusNode = FocusNode();
  TextEditingController textFieldController = TextEditingController();
  bool hideError = true;

  void setText() {
    setState(() {
      int oldOffsetFromEnd = textFieldController.text.length - textFieldController.selection.base.offset;
      textFieldController = TextEditingController(text: widget.value.toString());
      textFieldController.selection = TextSelection.collapsed(offset: textFieldController.text.length - oldOffsetFromEnd);
    });
  }

  @override
  Widget build(BuildContext context) {
    setText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title != null ? Text(widget.title!, style: CustomStyle.headers) : Container(),

        SizedBox(height: 10),

        Focus(
          child: Row(
            children: [
              Flexible(
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
                      errorText: hideError && widget.errorText == null ? null : widget.errorText,
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
              ),

              SizedBox(height: 10),

              widget.showResetButton ? getResetButton() : Container(),

            ],
          ),
          onFocusChange: (hasFocus) {
            setState(() {
              if (!hasFocus) {
                hideError = true;
                widget.onChanged(widget.value.toString());
              }
            });
          },
        ),

      ],
    );
  }

  Widget getResetButton() {
    return Row(
      children: [
        SizedBox(width: 10),
        MyTextButton(
          height: 54,
          text: "Reset",
          onTap: () {
            widget.onChanged(widget.defaultValue);
          }
        )
      ],
    );
  }
}
