import 'package:flutter/material.dart';
import 'package:veil/data_structures/alphabet.dart';

// Local
// Pages
import 'package:veil/pages/page_cipher.dart';
import 'package:veil/pages/page_digram_table.dart';

// Styles
import 'package:veil/styles/styles.dart';

// Data Structures
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/break_method.dart';

// Functions
import 'package:veil/functions/cipher_substitution.dart';
import 'package:veil/functions/digram.dart';
import 'package:veil/functions/frequency.dart';

// Widgets
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/cipher_substitution/permutation_entry.dart';
import 'package:veil/widgets/my_horizontal_scrollable.dart';
import 'package:veil/widgets/my_text_button.dart';

class PageCipherSubstitution extends PageCipher {
  PageCipherSubstitution({
    super.key,
    super.title = "Substitution Cipher",
    required super.defaultAlphabet,
  });

  @override
  State<PageCipherSubstitution> createState() => _PageCipherSubstitution();
}

class _PageCipherSubstitution extends State<PageCipherSubstitution> {
  late List<String> permutation;
  String permutationInput = '';
  String visualTabular = '';
  String visualCycle = '';
  bool breakCommonFirst = true;

  void callSetState() {
    setState(() {});
  }

  void setPerm(List<String> perm, String raw) {
    setState(() {
      permutation = perm;
      permutationInput = raw;
      visualTabular = buildTabularPermutationVisual(permutation, widget.alphabet);
      visualCycle = buildCyclePermutationVisual(permutation, widget.alphabet);
    });
  }

  @override
  void initState() {
    super.initState();
    permutation = widget.alphabet.letters;
    setPerm(permutation, permutationInput);
    widget.initSetPlaintextThenCiphertext((Cryptext cryptext) => {
      setState(() {
        cryptext.alphabet = widget.alphabet;
        widget.plaintext = cryptext;
        try {
          widget.ciphertext = substitutionEncrypt(widget.plaintext, permutation);
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
          widget.plaintext = substitutionDecrypt(widget.ciphertext, permutation);
        } catch(e) {
          widget.plaintext = Cryptext(letters: widget.ciphertext.lettersInAlphabet);
        }
      })
    });

    widget.setBreakMethods([
      BreakMethod(
        tag: 'digram_table',
        title: 'Digram Table',
        description: "A digram table shows how many instances there are of many digrams in the ciphertext. A digram is a piece of text that is two letters long. The row indicates the first letter, the column indicates the second. For example Row 'C', Column 'A' with a value of 11 means the string 'CA' appeared in the text 11 times. This digram table shows the entries of the n most frequent letters.",
        build: () {
          var freq = frequency(widget.ciphertext);
          var freqSorted = freq.entries.toList();
          if (breakCommonFirst) {
            // Most common individual chars first.
            freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char2.value.compareTo(char1.value));
          } else {
            // Least common individual chars first.
            freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char1.value.compareTo(char2.value));
          }

          String digramTableString = digramTable(widget.ciphertext, freqSorted.take(10).map((entry) => entry.key).toList());

          return Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 130,
                  child: Column(
                    children: [
                      MyTextButton(
                        text: 'Large View',
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => PageDigramTable(text: widget.ciphertext),
                              transitionDuration: Duration(milliseconds: 100),
                              reverseTransitionDuration: Duration(milliseconds: 100),
                              transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                            )
                          );
                        }
                      ),
                      SizedBox(height: 10),
                      MyTextButton(
                        text: 'Common',
                        onTap: () {
                          setState(() {
                            breakCommonFirst = true;
                          });
                        }
                      ),
                      SizedBox(height: 10),
                      MyTextButton(
                        text: 'Uncommon',
                        onTap: () {
                          setState(() {
                            breakCommonFirst = false;
                          });
                        }
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 25),
                Text(
                  digramTableString,
                  style: CustomStyle.bodyLargeTextMono,
                ),
              ],
            ),
          );
        }
      ),

      BreakMethod(
        tag: 'frequency',
        title: 'Individual Frequency Analysis',
        description: "How many times does each letter in the alphabet appear in the ciphertext?",
        build: () {
          var freq = frequency(widget.ciphertext);
          int mostDigits = 0;
          for (int num in freq.values) {
            mostDigits > (num ?? 0).toString().length ? mostDigits = (num ?? 0).toString().length : null;
          }

          var freqSorted = freq.entries.toList();
          freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char2.value.compareTo(char1.value));
          if (breakCommonFirst) {
            // Most common individual chars first.
            freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char2.value.compareTo(char1.value));
          } else {
            // Least common individual chars first.
            freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char1.value.compareTo(char2.value));
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    MyTextButton(
                      text: 'Common',
                      onTap: () {
                        setState(() {
                          breakCommonFirst = true;
                        });
                      }
                    ),
                    SizedBox(height: 10),
                    MyTextButton(
                      text: 'Uncommon',
                      onTap: () {
                        setState(() {
                          breakCommonFirst = false;
                        });
                      }
                    ),
                  ],
                ),
              ),

              SizedBox(width: 20),

              SingleChildScrollView(
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Count',
                            style: CustomStyle.headers,
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              widget.alphabet.length, (i) {
                                return Text(
                                  "${freqSorted[i].key} ${freqSorted[i].value.toString().padLeft(mostDigits)}",
                                  style: CustomStyle.bodyLargeTextMono,
                                );
                              }
                            ),
                          ),
                        ],
                      )
                    ),

                    SizedBox(width: 10),

                    SizedBox(
                      width: 110,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Percentage',
                            style: CustomStyle.headers,
                          ),
                          SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              widget.alphabet.length, (i) {
                                double divisor = widget.ciphertext.length == 0 ? 1 : widget.ciphertext.length.toDouble();
                                return Text(
                                  "${freqSorted[i].key} ${(freqSorted[i].value/divisor*100).toStringAsFixed(2).padLeft(mostDigits)}",
                                  style: CustomStyle.bodyLargeTextMono,
                                );
                              }
                            ),
                          ),
                        ],
                      )
                    ),

                    SizedBox(width: 20),

                  ],
                ),
              )
            ],
          );
        }
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return widget.pageFromSectionsDefaultBreakSectionCombinedED(
      defaultBreakHeight: 315,
      cryptSection: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  IntrinsicHeight(
                      child: PermutationEntry(
                        alphabet: widget.alphabet,
                        setPerm: setPerm,
                        perm: permutation,
                        rawText: permutationInput,
                      )
                  ),

                  SizedBox(height: 10),

                  Text("Tabular Notation", style: CustomStyle.headers),
                  SizedBox(height: 10),

                  MyHorizontalScrollable(
                    child: Text(
                      visualTabular,
                      style: CustomStyle.bodyLargeTextMono,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text("Cycle Notation", style: CustomStyle.headers),
                  SizedBox(height: 10),
                  MyHorizontalScrollable(
                    child: Text(
                      visualCycle,
                      style: CustomStyle.bodyLargeTextMono,
                    ),
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
                  setState(() {
                    // Finds which characters were added, and which were removed.
                    List<String> newChars = newAlphabet.letters.toSet().difference(widget.alphabet.letters.toSet()).toList();
                    List<String> removedChars = widget.alphabet.letters.toSet().difference(newAlphabet.letters.toSet()).toList();

                    // Adds new characters to the permutation as mapping to themselves.
                    permutation.addAll(newChars);

                    // Removes the removed characters from wherever they are in the current permutation.
                    permutation = permutation.map((e) => e = e.replaceAllMapped(RegExp('[${removedChars.join()}]'), (match) => "" )).toList();
                    permutation.remove('');

                    widget.alphabet = newAlphabet;
                    setPerm(permutation, permutationInput);
                  });
                },
                showResetButton: true,
              )
            ),
          ],
        ),
      ),
      callSetState: callSetState
    );
  }
}