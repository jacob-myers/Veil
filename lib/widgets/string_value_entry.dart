import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';

// Styles
import 'package:veil/styles/styles.dart';
import 'package:veil/widgets/my_text_button.dart';
import 'package:veil/widgets/value_entry.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class StringValueEntry extends StatefulWidget {
  final Function(String) onChanged;
  final String? title;
  final String hintText;
  final String? errorText;
  final bool showResetButton;
  final String defaultValue;
  final String value;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;
  final BorderRadius? borderRadius;
  final int? maxLength;

  const StringValueEntry({
    super.key,
    required this.onChanged,
    this.title,
    this.hintText = 'Enter a value...',
    this.errorText,
    this.showResetButton = false,
    this.defaultValue = "",
    this.value = "",
    this.style,
    this.padding,
    this.textAlign,
    this.borderRadius,
    this.maxLength,
  });

  @override
  State<StringValueEntry> createState() => _StringValueEntry();
}

class _StringValueEntry extends State<StringValueEntry> {
  @override
  Widget build(BuildContext context) {
    return ValueEntry(
      title: widget.title,
      onChanged: widget.onChanged,
      hintText: widget.hintText,
      errorText: widget.errorText,
      defaultValue: widget.defaultValue,
      defaultValueShowsAsBlank: false,
      showResetButton: widget.showResetButton,
      value: widget.value,
      style: widget.style,
      padding: widget.padding,
      textAlign: widget.textAlign,
      borderRadius: widget.borderRadius,
      maxLength: widget.maxLength,
    );
  }
}

/*
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

        widget.title != null ? SizedBox(height: 10) : Container(),

        Focus(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: TextField(
                    style: widget.style ?? CustomStyle.textFieldEntry,
                    textAlign: widget.textAlign ?? TextAlign.left,

                    keyboardType: TextInputType.text,

                    focusNode: focusNode,
                    controller: textFieldController,

                    textInputAction: TextInputAction.done,
                    maxLines: 1,

                    // Styling.
                    cursorColor: CustomStyle.pageScheme.onPrimary,
                    decoration: InputDecoration(
                      contentPadding: widget.padding,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomStyle.pageScheme.onPrimary, width: 1),
                        borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomStyle.pageScheme.onPrimary, width: 1),
                        borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
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

              //widget.showResetButton ? SizedBox(height: 10) : Container(),

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
*/
