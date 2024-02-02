import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data/app_settings.dart';

// Styles
import 'package:veil/styles/styles.dart';

/// Necessary for stupid bullshit constructor rules.
void defaultOnChanged (Cryptext c) { }

class CryptIOText extends StatefulWidget {
  final String title;
  Cryptext cryptext;
  final Alphabet alphabet;
  String hintText;
  bool enabled;
  bool hideTitle;
  final Function(Cryptext) onChanged;

  CryptIOText({
    super.key,
    this.title = 'My title',
    Cryptext? cryptext,
    required this.alphabet,
    this.hintText = '',
    this.enabled = true,
    this.hideTitle = false,
    Function(Cryptext)? onChanged,
  })
  : cryptext = cryptext ?? Cryptext(alphabet: alphabet),
  onChanged = onChanged ?? defaultOnChanged;

  @override
  State<CryptIOText> createState() => _CryptIOText();
}

class _CryptIOText extends State<CryptIOText> {
  var textFieldController = TextEditingController();
  FocusNode focusNode = FocusNode();
  int charLimit = AppSettings.characterLimit;

  void setText([Cryptext? cryptext]) {
    setState(() {
      int oldOffsetFromEnd = textFieldController.text.length - textFieldController.selection.base.offset;
      widget.cryptext = cryptext ?? widget.cryptext;
      textFieldController = TextEditingController(text: widget.cryptext.lettersAsString);
      textFieldController.selection = TextSelection.collapsed(offset: textFieldController.text.length - oldOffsetFromEnd);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Updates text for the build.
    setText();

    return Column(
      children: [

        widget.hideTitle? Text(widget.title, style: CustomStyle.headers) : Container(),

        widget.hideTitle? SizedBox(height: 20) : Container(),

        TextField(
          readOnly: !widget.enabled,
          style: CustomStyle.textFieldEntry,
          controller: textFieldController,
          focusNode: focusNode,

          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,

          maxLines: null,
          minLines: 5,
          //maxLength: widget.enabled ? AppSettings.characterLimit : null,

          // Styling.
          cursorColor: CustomStyle.pageScheme.onPrimary,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: CustomStyle.pageScheme.onPrimary, width: 1)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CustomStyle.pageScheme.onPrimary, width: 1)
            ),
            hintText: widget.hintText,

          ),

          // When Enter is pressed.
          onSubmitted: (String str) {
            focusNode.requestFocus();
          },
          // When the text is changed.
          onChanged: (String str)
          {
            //setText(Cryptext.fromString(str));
            // Can't handle Windows newlines.
            str = str.replaceAll('\r\n', '\n');

            // Manual enforcement of character limit (didn't like formatting for default)
            if (str.length > charLimit) {
              str = widget.enabled ? str.substring(0, charLimit) : str;
            }

            widget.onChanged(Cryptext.fromString(str, alphabet: widget.alphabet));
          }
        ),
      ],
    );
  }
}