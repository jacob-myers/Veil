import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';

// Styles
import 'package:veil/styles/styles.dart';

/// Necessary for stupid bullshit constructor rules.
void defaultOnChanged (Cryptext p, Cryptext c) { }

class CiphertextPlaintextPairEntry extends StatefulWidget {
  final Function(Cryptext, Cryptext) onChanged;
  Alphabet alphabet;

  CiphertextPlaintextPairEntry({
    super.key,
    Function(Cryptext, Cryptext)? onChanged,
    required this.alphabet,
  })
      :onChanged = onChanged ?? defaultOnChanged;

  @override
  State<CiphertextPlaintextPairEntry> createState() => _CiphertextPlaintextPairEntry();
}

class _CiphertextPlaintextPairEntry extends State<CiphertextPlaintextPairEntry> {
  Cryptext myKnownPlaintext = Cryptext();
  Cryptext myKnownCiphertext = Cryptext();

  void onKnownPlaintextChange(String str) {
    myKnownPlaintext = Cryptext.fromString(str, alphabet: widget.alphabet);
    widget.onChanged(myKnownPlaintext, myKnownCiphertext);
  }

  void onKnownCiphertextChange(String str) {
    myKnownCiphertext = Cryptext.fromString(str, alphabet: widget.alphabet);
    widget.onChanged(myKnownPlaintext, myKnownCiphertext);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              child: Text(
                'P = ',
                style: CustomStyle.headers,
              ),
            ),

            SizedBox(width: 10),
            Expanded(
              child: TextField(
                style: CustomStyle.textFieldEntry,
                keyboardType: TextInputType.text,
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
                  hintText: 'Enter known plaintext...',
                ),
                onChanged: (String str) { onKnownPlaintextChange(str); }
              ),
            )
          ],
        ),

        SizedBox(height: 5),

        Row(
          children: [
            Container(
              width: 40,
              child: Text(
                'C = ',
                style: CustomStyle.headers,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                  style: CustomStyle.textFieldEntry,
                  keyboardType: TextInputType.text,
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
                    hintText: 'Enter known ciphertext...',
                  ),
                  onChanged: (String str) { onKnownCiphertextChange(str); }
              ),
            )
          ],
        )
      ],
    );
  }
}