import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/functions/cipher_substitution.dart';
import 'package:veil/widgets/string_value_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

// On lose/gain focus: https://stackoverflow.com/questions/47965141/how-to-listen-focus-change-in-flutter

class PermutationEntry extends StatefulWidget {
  final Alphabet alphabet;
  final Function(List<String>, String) setPerm;
  final List<String> perm;
  final String rawText;

  const PermutationEntry({
    super.key,
    required this.alphabet,
    required this.setPerm,
    this.perm = const [],
    this.rawText = "",
  });

  @override
  State<PermutationEntry> createState() => _PermutationEntry();
}

class _PermutationEntry extends State<PermutationEntry> {
  String? error;

  @override
  Widget build(BuildContext context) {
    return StringValueEntry(
      title: 'Key (Permutation in cycle notation)',
      hintText: 'Enter permutation...',
      value: widget.rawText,
      showResetButton: true,
      errorText: error,
      onChanged: (String raw) {
        setState(() {
          List<String> newPerm = parseCycleNotation(raw);

          if (!permutationIsInAlphabet(newPerm, widget.alphabet)) {
            error = 'Input includes characters not in alphabet.';
            widget.setPerm(widget.perm, raw);
          }
          else if (!permutationIsUnique(newPerm)) {
            error = 'Input includes repeat characters.';
            widget.setPerm(widget.perm, raw);
          }
          else {
            // Valid (includes an empty input).
            error = null;
            widget.setPerm(newPerm + getSingleLengthCycles(newPerm, widget.alphabet), raw);
          }
        });
      },
    );
  }
}
