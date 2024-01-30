import 'package:flutter/material.dart';

// Local
// Pages
import 'package:veil/pages/page_cipher.dart';

// Data Structures
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/widgets/grid_editable.dart';
import 'package:veil/widgets/string_value_entry.dart';

import '../data_structures/alphabet.dart';
import '../widgets/alphabet_editor.dart';

class PageCipherADFGVX extends PageCipher {
  PageCipherADFGVX({
    super.key,
    super.title = "ADFGVX Cipher",
    required super.defaultAlphabet,
  });

  @override
  State<PageCipherADFGVX> createState() => _PageCipherADFGVX();
}

class _PageCipherADFGVX extends State<PageCipherADFGVX> {
  int cipherTextCharactersMax = 10;
  List<String> ciphertextChars = ['A', 'D', 'F', 'G', 'V', 'X'];
  List<String> defaultChars = ['A', 'D', 'F', 'G', 'V', 'X'];
  late List<List<String?>> keyarray;

  void callSetState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.initSetPlaintextThenCiphertext((Cryptext cryptext) => {

    });
    widget.initSetCiphertextThenPlaintext((Cryptext cryptext) => {

    });

    widget.setBreakMethods([

    ]);

    keyarray = List.generate(ciphertextChars.length, (index) => List.generate(ciphertextChars.length, (index) => null));
  }

  void setCiphertextChars(List<String> newChars) {
    setState(() {
      ciphertextChars = newChars;
      // Grows or shrinks the existing keyarray as to not reset data each time.
      while (keyarray.length > ciphertextChars.length) {
        keyarray.removeLast();
        for (var element in keyarray) {
          element.removeLast();
        }
      }
      while (keyarray.length < ciphertextChars.length) {
        keyarray.add(List.generate(keyarray.length, (index) => null));
        for (var element in keyarray) {
          element.add(null);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.pageFromSectionsDefaultBreakSectionCombinedED(
      callSetState: callSetState,
      cryptSection: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  StringValueEntry(
                    onChanged: (String str) {
                      if (str.length > cipherTextCharactersMax) {
                        setCiphertextChars(str.substring(0, cipherTextCharactersMax).split(""));
                      } else {
                        setCiphertextChars(str.split(""));
                      }
                    },
                    value: ciphertextChars.join(),
                    defaultValue: defaultChars.join(),
                    showResetButton: true,
                  ),

                  SizedBox( height: 15 ),

                  GridEditable(
                    rowTitles: ciphertextChars,
                    colTitles: ciphertextChars,
                    values: keyarray,
                    onValueChange: (String str) { setState(() {}); },
                  ),

                ],
              ),
            ),

            VerticalDivider(
              width: 40,
              thickness: 2,
            ),

            Expanded(
              child: AlphabetEditor(
                title: "Instance alphabet",
                alphabet: widget.alphabet,
                defaultAlphabet: widget.defaultAlphabet,
                setAlphabet: (Alphabet newAlphabet) {
                  setState(() {
                    widget.alphabet = newAlphabet;
                  });
                },
                showResetButton: true,
              )
            ),
          ],
        ),
      ),
    );
  }
}