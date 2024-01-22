import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';

// Styles
import 'package:veil/styles/styles.dart';
import 'package:veil/widgets/my_text_button.dart';

class ValueEntry extends StatefulWidget {
  final String? title;
  final Function(String) onChanged;
  final String hintText;
  final String? errorText;
  bool hideError;
  final String defaultValue;
  final bool defaultValueShowsAsBlank;
  final bool showResetButton;
  final String value;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;
  final BorderRadius? borderRadius;
  final Widget? contentRightOfTextEntry;

  ValueEntry({
    super.key,
    this.title,
    required this.onChanged,
    this.hintText = 'Enter a value...',
    this.errorText,
    this.hideError = true,
    this.defaultValue = "",
    this.defaultValueShowsAsBlank = false,
    this.showResetButton = false,
    this.value = "",
    this.style,
    this.padding,
    this.textAlign,
    this.borderRadius,
    this.contentRightOfTextEntry,
  });

  @override
  State<ValueEntry> createState() => _ValueEntry();
}

class _ValueEntry extends State<ValueEntry> {
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Set the cursor location for the Text Field.
    int oldOffsetFromEnd = textFieldController.text.length - textFieldController.selection.base.offset;
    textFieldController = TextEditingController(text: widget.value.toString());
    if (widget.value == widget.defaultValue && widget.defaultValueShowsAsBlank) { textFieldController = TextEditingController(text: ''); }
    textFieldController.selection = TextSelection.collapsed(offset: textFieldController.text.length - oldOffsetFromEnd);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title != null ? Text(widget.title!, style: CustomStyle.headers) : Container(),
        widget.title != null ? const SizedBox(height: 10) : Container(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: TextField(
                controller: textFieldController,
                style: widget.style ?? CustomStyle.textFieldEntry,
                textAlign: widget.textAlign ?? TextAlign.left,
                maxLines: 1,

                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,

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
                  errorText: widget.hideError && widget.errorText == null ? null : widget.errorText,
                  hintText: widget.hintText,
                ),

                // When the text is changed.
                onChanged: (String str) {
                  widget.hideError = false;
                  widget.onChanged(str);
                }
              ),
            ),

            widget.contentRightOfTextEntry ?? Container(),

            !widget.showResetButton ? Container() : Row(
              children: [
                SizedBox(width: 10),
                MyTextButton(
                  height: 54,
                  text: "Reset",
                  onTap: () { widget.onChanged(widget.defaultValue); }
                )
              ],
            ),
          ],
        )
      ],
    );
  }
}