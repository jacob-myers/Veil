import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/widgets/my_text_button.dart';

// Styles
import 'package:veil/styles/styles.dart';

class AlphabetEditor extends StatefulWidget {
  Alphabet alphabet;
  Alphabet defaultAlphabet;
  final void Function(Alphabet) setAlphabet;
  final String? title;
  final bool showDefaultButtons;
  final bool showResetButton;

  AlphabetEditor({
    super.key,
    required this.alphabet,
    Alphabet? defaultAlphabet,
    required this.setAlphabet,
    this.title,
    this.showDefaultButtons = false,
    this.showResetButton = false,
  })
  : defaultAlphabet = defaultAlphabet ?? alphabet;

  @override
  State<AlphabetEditor> createState() => _AlphabetEditor();
}

class _AlphabetEditor extends State<AlphabetEditor> {
  late TextEditingController controller;
  int? oldOffsetFromEnd;

  @override
  Widget build(BuildContext context) {
    controller = TextEditingController(text: widget.alphabet.lettersAsString);
    if (oldOffsetFromEnd != null) {
      controller.selection = TextSelection.collapsed(offset: controller.text.length - oldOffsetFromEnd!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        getTitle(),

        TextField(
          style: CustomStyle.textFieldEntry,
          controller: controller,

          keyboardType: TextInputType.text,

          textInputAction: TextInputAction.done,
          maxLines: null,

          // Styling.
          cursorColor: CustomStyle.pageScheme.onPrimary,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: CustomStyle.pageScheme.onPrimary, width: 1)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CustomStyle.pageScheme.onPrimary, width: 1)
            ),
            hintText: 'Enter an alphabet...',
          ),

          // When Enter is pressed.
          onSubmitted: (String str) {},

          // When the text is changed.
          onChanged: (String str) {
            oldOffsetFromEnd = controller.text.length - controller.selection.base.offset;
            if (Alphabet.strIsValidAlphabet(str)) {
              // Changes are valid, set alphabet and update.
              widget.setAlphabet(Alphabet.fromString(letters: str));
            } else {
              // Deletes changes, resets to alphabet because changes were invalid.
              setState(() {
                return;
              });
            }
          }
        ),

        getButtons(),

      ],
    );
  }

  Widget getTitle() {
    if (widget.title != null) {
      return Column(
        children: [
          Text(widget.title!, style: CustomStyle.headers),
          SizedBox(height: 10),
        ],
      );
    }
    return Container();
  }

  Widget getButtons() {
    List<Widget> children = [];
    children += getResetButton();
    children += getDefaultAlphabetButtons();

    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: children,
        )
      ],
    );
  }

  List<Widget> getResetButton() {
    if (widget.showResetButton) {
      return [
        MyTextButton(
          text: 'Reset to my default',
          onTap: () {
            widget.setAlphabet(widget.defaultAlphabet);
          }
        ),
      ];
    } else {
      return [Container()];
    }
  }

  List<Widget> getDefaultAlphabetButtons() {
    if (widget.showDefaultButtons) {
      return [
        MyTextButton(
            text: 'Uppercase English',
            onTap: () {
              widget.setAlphabet(Alphabet());
            }
        ),

        SizedBox(width: 10),

        MyTextButton(
            text: 'Lowercase English',
            onTap: () {
              widget.setAlphabet(Alphabet.fromString(letters: 'abcdefghijklmnopqrstuvwxyz'));
            }
        ),
      ];
    }
    return [Container()];
  }
}