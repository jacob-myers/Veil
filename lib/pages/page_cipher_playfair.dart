import 'package:flutter/material.dart';
import 'package:veil/data_structures/alphabet.dart';

// Local
// Pages
import 'package:veil/pages/page_cipher.dart';

// Styles
import 'package:veil/styles/styles.dart';

// Data Structures
import 'package:veil/data_structures/cryptext.dart';

// Functions
import 'package:veil/functions/cipher_playfair.dart';

// Widgets
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/disabled_text_display.dart';
import 'package:veil/widgets/keyword_entry.dart';

class PageCipherPlayfair extends PageCipher {
  PageCipherPlayfair({
    super.key,
    super.title = "Playfair Cipher",
    required super.defaultAlphabet,
  });

  @override
  State<PageCipherPlayfair> createState() => _PageCipherPlayfair();
}

class _PageCipherPlayfair extends State<PageCipherPlayfair> {
  String visual = "";
  late Cryptext keyword;

  void callSetState() {
    setState(() {});
  }

  @override
  void initState() {
    keyword = Cryptext(alphabet: widget.alphabet);
    super.initState();

    // The setText methods of the superclass are initialized here (PageCipher)
    widget.initSetPlaintextThenCiphertext((Cryptext cryptext) => {
      setState(() {
        widget.plaintext = cryptext;
        widget.plaintext.alphabet = widget.alphabet;
        keyword.alphabet = widget.alphabet;

        try {
          widget.ciphertext = playfairEncrypt(Cryptext(letters: widget.plaintext.lettersInAlphabet, alphabet: widget.alphabet), keyword);
        } catch (e) {
          //print(e);
          widget.ciphertext = widget.plaintext;
        }
      })
    });
    widget.initSetCiphertextThenPlaintext((Cryptext cryptext) => {
      setState(() {
        widget.ciphertext = cryptext;
        widget.ciphertext.alphabet = widget.alphabet;
        keyword.alphabet = widget.alphabet;

        List<String> lettersToUse = widget.ciphertext.lettersInAlphabet.toList();
        lettersToUse.length % 2 == 1 ? lettersToUse.removeLast() : null;

        try {
          widget.plaintext = playfairDecrypt(Cryptext(letters: lettersToUse, alphabet: widget.alphabet), keyword);
        } catch (e) {
          //print(e);
          widget.plaintext = widget.ciphertext;
        }
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    visual = buildPlayfairMatrixVisual(keyword);

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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child:KeywordEntry(
                          keyword: keyword,
                          alphabet: widget.alphabet,
                          setKeyword: (Cryptext? cryptext) => {
                            setState(() {
                              keyword = cryptext ?? Cryptext(alphabet: widget.alphabet);
                              widget.setPlaintextThenCiphertext(widget.plaintext);
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
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Key Matrix",
                            style: CustomStyle.headers,
                          ),
                          SizedBox(height: 10),
                          Text(
                            visual,
                            style: CustomStyle.bodyLargeTextMono,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
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