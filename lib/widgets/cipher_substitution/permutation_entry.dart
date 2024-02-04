import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/functions/cipher_substitution.dart';
import 'package:veil/widgets/cipher_substitution/delimiter_entry.dart';
import 'package:veil/widgets/my_text_button.dart';
import 'package:veil/widgets/string_value_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class PermutationEntry extends StatefulWidget {
  final Alphabet alphabet;
  final Function(List<String>, String) setPerm;
  final List<String> perm;
  final String rawText;
  final String defaultStartDelimiter;
  final String defaultEndDelimiter;

  const PermutationEntry({
    super.key,
    required this.alphabet,
    required this.setPerm,
    this.perm = const [],
    this.rawText = "",
    this.defaultStartDelimiter = "(",
    this.defaultEndDelimiter = ")",
  });

  @override
  State<PermutationEntry> createState() => _PermutationEntry();
}

class _PermutationEntry extends State<PermutationEntry> {
  late String startDelimiter;
  late String endDelimiter;
  late String startDelimiterRaw;
  late String endDelimiterRaw;
  String? error;
  late String? delimError;

  @override
  void initState() {
    super.initState();
    startDelimiter = widget.defaultStartDelimiter;
    endDelimiter = widget.defaultEndDelimiter;
    startDelimiterRaw = startDelimiter;
    endDelimiterRaw = endDelimiter;
    delimError = findDelimError();
  }

  /// If there is an error in the delimiters, returns it. Otherwise, null.
  String? findDelimError() {
    if (startDelimiterRaw.length != 1 || endDelimiterRaw.length != 1) {
      return "* Error: Missing delimiters.";
    } else if (widget.alphabet.contains(startDelimiterRaw) || widget.alphabet.contains(endDelimiterRaw)) {
      return "* Error: Delimiters cannot be in alphabet.";
    } else if (startDelimiterRaw == endDelimiterRaw) {
      return "* Error: Start delimiter and end delimiter cannot be the same.";
    }
    return null;
  }

  /// Attempts to parse a permutation from raw and set it.
  void tryParsePerm(String raw) {
    List<String> newPerm = parseCycleNotation(raw, startDelimiter, endDelimiter);
    error = permParseError(raw, widget.alphabet, startDelimiter, endDelimiter);
    if (error == null) {
      widget.setPerm(newPerm + getSingleLengthCycles(newPerm, widget.alphabet), raw);
    } else {
      widget.setPerm(widget.perm, raw);
    }
  }

  @override
  Widget build(BuildContext context) {
    error = permParseError(widget.rawText, widget.alphabet, startDelimiter, endDelimiter);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StringValueEntry(
          title: 'Key (Permutation in cycle notation)',
          hintText: 'Enter permutation...',
          value: widget.rawText,
          showResetButton: true,
          errorText: error,
          onChanged: (String raw) {
            setState(() {
              tryParsePerm(raw);
            });
          },
        ),
        const SizedBox(height: 10),

        // Error about alphabet length vs ciphertext char amount
        delimError == null ? Container() : Text(
          delimError!,
          style: CustomStyle.bodyError,
        ),
        delimError == null ? Container() : const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Start Delimiter: ", style: CustomStyle.headers),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DelimiterEntry(
                      value: startDelimiterRaw,
                      onChanged: (String str) {
                        setState(() {
                          startDelimiterRaw = str;

                          delimError = findDelimError();
                          if (delimError == null) {
                            startDelimiter = str;
                            tryParsePerm(widget.rawText);
                          }
                        });
                      },
                    )
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("End Delimiter: ", style: CustomStyle.headers),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DelimiterEntry(
                      value: endDelimiterRaw,
                      onChanged: (String str) {
                        setState(() {
                          endDelimiterRaw = str;

                          delimError = findDelimError();
                          if (delimError == null) {
                            endDelimiter = str;
                            tryParsePerm(widget.rawText);
                          }
                        });
                      },
                    )
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),

            MyTextButton(
              text: 'Reset',
              onTap: () {
                setState(() {
                  startDelimiter = widget.defaultStartDelimiter;
                  endDelimiter = widget.defaultEndDelimiter;
                  startDelimiterRaw = widget.defaultStartDelimiter;
                  endDelimiterRaw = widget.defaultEndDelimiter;
                });
              }
            ),

          ],
        ),
      ],
    );
  }
}
