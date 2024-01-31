import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/widgets/disabled_text_display.dart';
import 'package:veil/widgets/my_text_button.dart';

// Styles
import 'package:veil/styles/styles.dart';
import 'package:veil/widgets/string_value_entry.dart';

class AlphabetEditor extends StatefulWidget {
  Alphabet alphabet;
  Alphabet defaultAlphabet;
  final void Function(Alphabet) setAlphabet;
  final String? title;
  final bool showDefaultButtons;
  final bool showResetButton;
  final bool showAlphabetLength;

  AlphabetEditor({
    super.key,
    required this.alphabet,
    Alphabet? defaultAlphabet,
    required this.setAlphabet,
    this.title,
    this.showDefaultButtons = false,
    this.showResetButton = false,
    this.showAlphabetLength = true,
  })
  : defaultAlphabet = defaultAlphabet ?? alphabet;

  @override
  State<AlphabetEditor> createState() => _AlphabetEditor();
}

class _AlphabetEditor extends State<AlphabetEditor> {
  int? oldOffsetFromEnd;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StringValueEntry(
                  title: widget.title,
                  value: widget.alphabet.lettersAsString,
                  hintText: "Enter an alphabet...",
                  onChanged: (String str) {
                    if (Alphabet.strIsValidAlphabet(str)) {
                      // Changes are valid, set alphabet and update.
                      widget.setAlphabet(Alphabet.fromString(letters: str));
                    } else {
                      // Deletes changes, resets to alphabet because changes were invalid.
                      setState(() {
                        return;
                      });
                    }
                  },
                ),
              ),

              !widget.showAlphabetLength ? Container() : const SizedBox(width: 10),
              !widget.showAlphabetLength ? Container() : SizedBox(
                width: 70,
                child: DisabledTextDisplay(
                  title: "Length",
                  content: widget.alphabet.length.toString(),
                ),
              ),

            ],
          ),
        ),

        Column(
          children: [
            hasButtons() ? const SizedBox(height: 10) : Container(),

            Row(
              children: [
                !widget.showResetButton ? Container() : MyTextButton(
                    text: 'Reset to my default',
                    onTap: () {
                      widget.setAlphabet(widget.defaultAlphabet);
                    }
                ),
                !widget.showResetButton ? Container() : const SizedBox(width: 10),

                !widget.showDefaultButtons ? Container() : MyTextButton(
                    text: 'Uppercase English',
                    onTap: () {
                      widget.setAlphabet(Alphabet());
                    }
                ),
                !widget.showDefaultButtons ? Container() : const SizedBox(width: 10),

                !widget.showDefaultButtons ? Container() : MyTextButton(
                    text: 'Lowercase English',
                    onTap: () {
                      widget.setAlphabet(Alphabet.fromString(letters: 'abcdefghijklmnopqrstuvwxyz'));
                    }
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  bool hasButtons() {
    return widget.showDefaultButtons || widget.showResetButton;
  }
}