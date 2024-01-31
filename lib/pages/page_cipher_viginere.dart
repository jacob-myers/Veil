import 'package:flutter/material.dart';

// Local
// Pages
import 'package:veil/pages/page_cipher.dart';

// Data Structures
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/alphabet.dart';

// Functions
import 'package:veil/functions/cipher_viginere.dart';

// Widgets
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/disabled_text_display.dart';
import 'package:veil/widgets/keyword_entry.dart';

class PageCipherViginere extends PageCipher {
  PageCipherViginere({
    super.key,
    super.title = "Viginere Cipher",
    required super.defaultAlphabet,
  });

  @override
  State<PageCipherViginere> createState() => _PageCipherViginere();
}

class _PageCipherViginere extends State<PageCipherViginere> {
  late Cryptext keyword;

  void callSetState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    keyword = Cryptext(alphabet: widget.alphabet);

    widget.initSetPlaintextThenCiphertext((Cryptext cryptext) => {
      setState(() {
        cryptext.alphabet = widget.alphabet;
        widget.plaintext = cryptext;
        try {
          widget.ciphertext = viginereEncrypt(widget.plaintext, keyword);
        } catch(e) {
          widget.ciphertext = Cryptext(letters: widget.plaintext.lettersInAlphabet);
        }
      })
    });
    widget.initSetCiphertextThenPlaintext((Cryptext cryptext) => {
      setState(() {
        cryptext.alphabet = widget.alphabet;
        widget.ciphertext = cryptext;
        try {
          widget.plaintext = viginereDecrypt(widget.ciphertext, keyword);
        } catch (e) {
          widget.plaintext = Cryptext(letters: widget.ciphertext.lettersInAlphabet);
        }
      })
    });

    widget.setBreakMethods([]);
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
              child: KeywordEntry(
                keyword: keyword,
                alphabet: widget.alphabet,
                setKeyword: (Cryptext? newKeyword) {
                  setState(() {
                    keyword = newKeyword ?? keyword;
                  });
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
                  setAlphabet: (Alphabet newAlphabet) {
                    setState(() { widget.alphabet = newAlphabet; });
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