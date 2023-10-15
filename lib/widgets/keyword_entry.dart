import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/widgets/string_value_entry.dart';

class KeywordEntry extends StatefulWidget {
  final Alphabet alphabet;
  final Function(Cryptext?) setKeyword;
  Cryptext keyword;

  KeywordEntry({
    super.key,
    required this.alphabet,
    required this.setKeyword,
    Cryptext? keyword,
  })
  : keyword = keyword ?? Cryptext();

  @override
  State<KeywordEntry> createState() => _KeywordEntry();
}

class _KeywordEntry extends State<KeywordEntry> {
  String? keywordError;

  @override
  Widget build(BuildContext context) {
    return StringValueEntry(
      title: "Keyword",
      hintText: "Enter a keyword...",
      errorText: keywordError,
      value: widget.keyword.lettersAsString,
      onChanged: (String val) {
        setState(() {
          Cryptext newKeyWord = Cryptext.fromString(val);
          if (newKeyWord.lettersAsString == "") {
            // Empty
            keywordError = null;
            widget.setKeyword(newKeyWord);
          }
          else if (!newKeyWord.isExclusiveToAlphabet) {
            // Contains letters not in alphabet.
            keywordError = "Letter not in alphabet";
          }
          else {
            // Valid
            keywordError = null;
            widget.setKeyword(newKeyWord);
          }
        });
      }
    );
  }
}