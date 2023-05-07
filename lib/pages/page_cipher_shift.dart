import 'package:flutter/material.dart';

// Local
import 'package:veil/pages/cipher_page_state.dart';
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/break_method.dart';
import 'package:veil/functions/cipher_shift.dart';
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/appbar_cipher_page.dart';
import 'package:veil/widgets/break_method_list.dart';
import 'package:veil/widgets/crypt_io/crypt_io.dart';
import 'package:veil/widgets/alphabet_space_display.dart';
import 'package:veil/widgets/partial_text_display.dart';
import 'package:veil/widgets/ciphertext_plaintext_pair_entry.dart';
import 'package:veil/widgets/cipher_shift/shift_amount_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

class PageCipherShift extends StatefulWidget {
  Alphabet defaultAlphabet;
  Alphabet alphabet;
  Cryptext plaintext;
  Cryptext ciphertext;
  String mode;

  PageCipherShift({
    super.key,
    required this.defaultAlphabet,
    Cryptext? plaintext,
    Cryptext? ciphertext,
    this.mode = 'encrypt',
  })
  : alphabet = defaultAlphabet,
    plaintext = plaintext ?? Cryptext(alphabet: defaultAlphabet),
    ciphertext = ciphertext ?? Cryptext(alphabet: defaultAlphabet);

  @override
  State<PageCipherShift> createState() => _PageCipherShift();
}


class _PageCipherShift extends State<PageCipherShift> implements CipherPageState {
  int shift = 0;
  int breakShift = 0;
  bool breakShiftError = false;
  BreakMethod? breakMethod;
  static List<BreakMethod> breakMethods = [];

  @override
  initState() {
    super.initState();
    _initBreakMethods();
  }

  void _initBreakMethods() {
    /// Initialize the cipher breaking methods.
    breakMethods = [
      BreakMethod(
          tag: 'brute_force',
          title: 'Brute Force',
          description: "Brute force is viable for a shift cipher because the keyspace is only as long as the alphabet. It's the only method possible for short messages. The previews on the right are the messages decrypted if they had been encrypted with the indicated k.",
          build: bruteForceContent
      ),
      BreakMethod(
          tag: 'known_plaintext',
          title: 'Known Plaintext',
          description: "Known plaintext is when the plaintext of some corresponding ciphertext is known. In the case of a shift cipher, this only needs 1 plaintext/ciphertext letter pair.",
          build: knownPlaintextContent
      ),
    ];
    try {
      breakMethod = breakMethods[0];
    } on RangeError {
      breakMethod = null;
    }
  }

  @override
  void setPlaintextThenCiphertext(Cryptext cryptext) {
    setState(() {
      cryptext.alphabet = widget.alphabet;
      widget.plaintext = cryptext;
      widget.ciphertext = cryptShift(widget.plaintext, shift);
    });
  }

  @override
  void setCiphertextThenPlaintext(Cryptext cryptext) {
    setState(() {
      cryptext.alphabet = widget.alphabet;
      widget.ciphertext = cryptext;
      widget.plaintext = cryptShift(widget.ciphertext, -shift);
    });
  }

  @override
  void setBreakMethod(BreakMethod method) {
    setState(() {
      breakMethod = method;
    });
  }

  @override
  void onModeButtonPress(String mode) {
    setState(() {
      widget.mode = mode;
    });
  }

  void setAlphabet (Alphabet newAlphabet) {
    setState(() {
      widget.alphabet = newAlphabet;
    });
  }

  void setShift([int? shift]) {
    setState(() {
      this.shift = shift ?? this.shift;
    });
  }

  bool isValidShiftPair(Cryptext p, Cryptext c) {
    if (p.length == 0 || c.length == 0) {
      return false;
    }
    if (p.length != c.length) {
      return false;
    }
    if (!p.isExclusiveToAlphabet || !c.isExclusiveToAlphabet) {
      return false;
    }

    int shift = p.alphabet.mod(c.numeralized[0] - p.numeralized[0]);
    for (int i = 0; i < p.length; i++) {
      if (p.alphabet.mod(c.numeralized[i] - p.numeralized[i]) != shift) {
        return false;
      }
    }
    return true;
  }

  void onKnownPairChange(Cryptext p, Cryptext c) {
    setState(() {
      if (isValidShiftPair(p, c)) {
        breakShiftError = false;
        breakShift = p.alphabet.mod(c.numeralized[0] - p.numeralized[0]);
      } else {
        breakShiftError = true;
        breakShift = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double outerPadding = 20;

    if (widget.mode == 'encrypt'){
      // Initializes ciphertext from plaintext.
      setPlaintextThenCiphertext(widget.plaintext);
    }
    if (widget.mode == 'decrypt') {
      // Initializes plaintext from ciphertext.
      setCiphertextThenPlaintext(widget.ciphertext);
    }
    if (widget.mode == 'break') {
      // Initializes plaintext from ciphertext.
      setCiphertextThenPlaintext(widget.ciphertext);
    }

    return Scaffold(
      appBar: AppbarCipherPage(
        title: 'Shift Cipher',
        mode: widget.mode,
        onModeButtonPress: onModeButtonPress,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(outerPadding),
          child: getBody(context),
        ),
      )
    );
  }

  Widget getBody(BuildContext context) {
    return Column(
      children: [
        CryptIO(
          encrypt: widget.mode == 'encrypt',
          alphabet: widget.alphabet,
          setPlaintext: setPlaintextThenCiphertext,
          setCiphertext: setCiphertextThenPlaintext,
          plaintext: widget.plaintext,
          ciphertext: widget.ciphertext,
        ),

        Divider(height: 30),

        Row(
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
                      ShiftAmountEntry(
                          alphabet: widget.alphabet,
                          setShift: setShift,
                          shift: shift
                      ),

                      SizedBox(width: 20),

                      AlphabetSpaceDisplay(alphabet: widget.alphabet)
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

            SizedBox(width: 120),

            // Right Column.
            // TODO implement functionality.
            Expanded(
              child: AlphabetEditor(
                title: "Instance alphabet",
                alphabet: widget.alphabet,
                defaultAlphabet: widget.defaultAlphabet,
                setAlphabet: setAlphabet,
                showResetButton: true,
              )
            ),
          ],
        ),

        widget.mode == 'break' ? getBreakSection() : Container(),

      ],
    );
  }

  Widget getBreakSection() {
    if (breakMethod == null) {
      return Container();
    }

    return Column(
      children: [
        SizedBox(height: 10),
        Divider(height: 30),

        SizedBox(
          height: 300,
          child: Row(
            children: [
              BreakMethodList(
                methods: breakMethods,
                setBreakMethod: setBreakMethod,
                selectedMethod: breakMethod!,
              ),

              //SizedBox(width: 20),
              VerticalDivider(width: 40),

              breakMethod!.build(),
            ],
          ),
        ),
      ],
    );
  }

  Widget bruteForceContent() {
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
                      setShift(index);
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

  Widget knownPlaintextContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CiphertextPlaintextPairEntry(
            alphabet: widget.alphabet,
            onChanged: onKnownPairChange,
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
                setShift(breakShift);
              });
            },
          ),
        ],
      )
    );
  }
}