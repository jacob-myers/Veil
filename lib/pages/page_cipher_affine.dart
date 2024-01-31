import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

// Local
// Pages
import 'package:veil/pages/page_cipher.dart';

// Styles
import 'package:veil/styles/styles.dart';

// Data Structures
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/break_method.dart';
import 'package:veil/data_structures/cryptext.dart';

// Functions
import 'package:veil/functions/cipher_affine.dart';

// Widgets
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/cipher_affine/a_entry.dart';
import 'package:veil/widgets/cipher_affine/b_entry.dart';
import 'package:veil/widgets/ciphertext_plaintext_pair_entry.dart';
import 'package:veil/widgets/disabled_text_display.dart';

class PageCipherAffine extends PageCipher {
  PageCipherAffine({
    super.key,
    super.title = "Affine Cipher",
    required super.defaultAlphabet,
  });

  @override
  State<PageCipherAffine> createState() => _PageCipherAffine();
}

class _PageCipherAffine extends State<PageCipherAffine> {
  int a = 1;
  int b = 0;
  int breakA = 1;
  int breakB = 0;

  void callSetState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    widget.initSetPlaintextThenCiphertext((Cryptext cryptext) => {
      setState(() {
        cryptext.alphabet = widget.alphabet;
          widget.plaintext = cryptext;
        try {
          widget.ciphertext = affineEncrypt(widget.plaintext, a, b);
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
          widget.plaintext = affineDecrypt(widget.ciphertext, a, b);
        } catch (e) {
          widget.plaintext = Cryptext(letters: widget.ciphertext.lettersInAlphabet);
        }
      })
    });

    widget.setBreakMethods([
      BreakMethod(
        tag: 'known_plaintext',
        title: 'Known Plaintext',
        description: "Known plaintext is when the plaintext of some corresponding ciphertext is known. For an affine cipher, at least 2 pairs have to be known, and have to be a distance apart in the alphabet space(n) that is relatively prime with the alphabet space(n).",
        build: () {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CiphertextPlaintextPairEntry(
                  alphabet: widget.alphabet,
                  onChanged: (Cryptext p, Cryptext c) {
                    setState(() {
                      if (isValidAffinePair(p, c)) {
                        widget.breakError = false;
                        if (isValidAffinePair(p, c)) {
                          Tuple2 ab = findAB(p, c);
                          breakA = ab.item1;
                          breakB = ab.item2;
                        }
                      } else {
                        widget.breakError = true;
                        breakA = 1;
                        breakB = 0;
                      }
                    });
                  },
                ),

                const Divider(height: 30,),

                // Key calculated from input.
                GestureDetector(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      widget.breakError ? "Invalid input." : 'a = $breakA      b = $breakB',
                      style: CustomStyle.headers,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      a = breakA;
                      b = breakB;
                    });
                  },
                ),
              ],
            )
          );
        }
      ),
    ]);
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AEntry(
                            alphabet: widget.alphabet,
                            setA: (int newA) {
                              setState(() { a = newA; });
                            },
                            a: a,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: BEntry(
                            alphabet: widget.alphabet,
                            setB: (int newB) {
                              setState(() { b = newB; });
                            },
                            b: b,
                          ),
                        ),
                        const SizedBox(width: 20),

                        SizedBox(
                          width: 70,
                          child: DisabledTextDisplay(
                            title: "Range",
                            content: widget.alphabet.length.toString()
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Mathematical Algorithm: C(p) = ap + b (mod(n))",
                      style: CustomStyle.bodyLargeText,
                    ),

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