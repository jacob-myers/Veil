import 'package:flutter/material.dart';
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/functions/cipher_playfair.dart';
import 'package:veil/pages/page_cipher.dart';

import '../widgets/alphabet_editor.dart';
import '../widgets/disabled_text_display.dart';
import '../widgets/keyword_entry.dart';

class PageCipherPlayfair extends PageCipher {
  PageCipherPlayfair({
    required super.defaultAlphabet,
  });

  @override
  State<PageCipherPlayfair> createState() => _PageCipherPlayfair();
}

class _PageCipherPlayfair extends State<PageCipherPlayfair> {
  late Cryptext keyword;

  void callSetState() {
    setState(() {});
  }

  @override
  void initState() {
    keyword = Cryptext.fromString("", alphabet: widget.alphabet);
    super.initState();
    widget.initSetPlaintextThenCiphertext((Cryptext cryptext) => {
      setState(() {
        widget.plaintext = cryptext;
        widget.plaintext.alphabet = widget.alphabet;
        try {
          widget.ciphertext = playfairEncrypt(Cryptext(letters: widget.plaintext.lettersInAlphabet, alphabet: widget.alphabet), keyword);
        } catch (e) {
          //print("caught");
          print(e);
          print(widget.plaintext.alphabet);
          print(keyword.alphabet);
          widget.ciphertext = widget.plaintext;
        }
      })
    });
    widget.initSetCiphertextThenPlaintext((Cryptext cryptext) => {
      setState(() {
        widget.ciphertext = cryptext;
        widget.ciphertext.alphabet = widget.alphabet;
        try {
          widget.plaintext = playfairDecrypt(widget.ciphertext, keyword);
        } catch (e) {
          widget.plaintext = Cryptext();
        }
        widget.plaintext = playfairDecrypt(widget.ciphertext, keyword);
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.pageFromSections(
      context,
      callSetState: callSetState,
      encryptSection: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: KeywordEntry(
                keyword: keyword,
                alphabet: widget.alphabet,
                setKeyword: (Cryptext? cryptext) => {
                  setState(() {
                    keyword = cryptext ?? Cryptext(alphabet: widget.alphabet);
                    widget.setPlaintextThenCiphertext(widget.plaintext);
                    print('changed');
                  }),
                },
              ),
            ),

            SizedBox(width: 10),

            SizedBox(
              width: 150,
              child: DisabledTextDisplay(
                content: keyword.length.toString(),
                title: "Keyword Length",
              ),
            ),

            const VerticalDivider(
              width: 40,
              thickness: 2,
            ),

            // Right Column.
            Expanded(
                child: AlphabetEditor(
                  title: "Instance alphabet",
                  alphabet: widget.alphabet,
                  defaultAlphabet: widget.defaultAlphabet,
                  setAlphabet: widget.setAlphabet,
                  showResetButton: true,
                )
            ),

          ],
        ),
      ),
    );
  }
}