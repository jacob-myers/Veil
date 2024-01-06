import 'package:flutter/material.dart';

// Local
// Pages
import 'package:veil/pages/page_cipher.dart';

// Styles
import 'package:veil/styles/styles.dart';

// Data Structures
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/break_method.dart';

// Functions
import 'package:veil/functions/cipher_shift.dart';

// Widgets
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/cipher_shift/shift_amount_entry.dart';
import 'package:veil/widgets/ciphertext_plaintext_pair_entry.dart';
import 'package:veil/widgets/disabled_text_display.dart';
import 'package:veil/widgets/partial_text_display.dart';

class PageCipherShift extends PageCipher {
  PageCipherShift({
    super.key,
    super.title = "Shift Cipher",
    required super.defaultAlphabet,
  });

  @override
  State<PageCipherShift> createState() => _PageCipherShift();
}

class _PageCipherShift extends State<PageCipherShift> {
  int shift = 0;
  int breakShift = 0;
  bool breakShiftError = false;

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
        widget.ciphertext = cryptShift(widget.plaintext, shift);
      })
    });
    widget.initSetCiphertextThenPlaintext((Cryptext cryptext) => {
      setState(() {
        cryptext.alphabet = widget.alphabet;
        widget.ciphertext = cryptext;
        widget.plaintext = cryptShift(widget.ciphertext, -shift);
      })
    });

    widget.setBreakMethods([
      BreakMethod(
          tag: 'brute_force',
          title: 'Brute Force',
          description: "Brute force is viable for a shift cipher because the keyspace is only as long as the alphabet. It's the only method possible for short messages. The previews on the right are the messages decrypted if they had been encrypted with the indicated k.",
          build: () {
            return Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.ciphertext.alphabet.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Row(
                              children: [
                                Text(
                                  'k = $index',
                                  style: CustomStyle.headers,
                                ),
                                SizedBox(width: 10),
                                PartialTextDisplay(
                                  cryptext: cryptShift(widget.ciphertext, -index),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              shift = index;
                            });
                          }
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    )
                  ),
                ],
              ),
            );
          }
      ),
      BreakMethod(
          tag: 'known_plaintext',
          title: 'Known Plaintext',
          description: "Known plaintext is when the plaintext of some corresponding ciphertext is known. In the case of a shift cipher, this only needs 1 plaintext/ciphertext letter pair.",
          build: () {
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CiphertextPlaintextPairEntry(
                    alphabet: widget.alphabet,
                    onChanged: (Cryptext p, Cryptext c) {
                      setState(() {
                        if (isValidShiftPair(p, c)) {
                          breakShiftError = false;
                          breakShift = p.alphabet.mod(c.numeralized[0] - p.numeralized[0]);
                        } else {
                          breakShiftError = true;
                          breakShift = 0;
                        }
                      });
                    },
                  ),

                  Divider(height: 30,),

                  // Key calculated from input.
                  GestureDetector(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        breakShiftError ? "Invalid input." : 'k = $breakShift',
                        style: CustomStyle.headers,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        shift = breakShift;
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
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ShiftAmountEntry(
                            alphabet: widget.alphabet,
                            setShift: (int? newShift) {
                              setState(() {
                                shift = newShift ?? shift;
                              });
                            },
                            shift: shift
                        ),
                      ),

                      SizedBox(width: 20),

                      Expanded(
                        child: DisabledTextDisplay(
                            title: "Alphabet Space",
                            content: widget.alphabet.length.toString()
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Mathematical Algorithm: C(p) = p + k (mod(n))",
                    style: CustomStyle.bodyLargeText,
                  ),

                ],
              ),
            ),

            VerticalDivider(
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