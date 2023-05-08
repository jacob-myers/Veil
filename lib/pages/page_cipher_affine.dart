import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

// Local
import 'package:veil/pages/cipher_page_state.dart';
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/break_method.dart';
import 'package:veil/functions/cipher_affine.dart';
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/alphabet_space_display.dart';
import 'package:veil/widgets/appbar_cipher_page.dart';
import 'package:veil/widgets/crypt_io/crypt_io.dart';
import 'package:veil/widgets/cipher_affine/a_entry.dart';
import 'package:veil/widgets/cipher_affine/b_entry.dart';
import 'package:veil/widgets/break_method_list.dart';
import 'package:veil/widgets/ciphertext_plaintext_pair_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

class PageCipherAffine extends StatefulWidget {
  Alphabet defaultAlphabet;
  Alphabet alphabet;
  Cryptext plaintext;
  Cryptext ciphertext;
  String mode;

  PageCipherAffine({
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
  State<PageCipherAffine> createState() => _PageCipherAffine();
}

class _PageCipherAffine extends State<PageCipherAffine> implements CipherPageState {
  int a = 1;
  int b = 0;
  int breakA = 1;
  int breakB = 0;
  BreakMethod? breakMethod;
  List<BreakMethod> breakMethods = [];
  bool breakError = false;

  @override
  initState() {
    super.initState();
    _initBreakMethods();
  }

  void _initBreakMethods() {
    /// Initialize the cipher breaking methods.
    breakMethods = [
      BreakMethod(
        tag: 'known_plaintext',
        title: 'Known Plaintext',
        description: "Known plaintext is when the plaintext of some corresponding ciphertext is known. For an affine cipher, at least 2 pairs have to be known, and have to be a distance apart in the alphabet space(n) that is relatively prime with the alphabet space(n).",
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
      try {
        widget.ciphertext = affineEncrypt(widget.plaintext, a, b);
      } catch(e) {
        widget.ciphertext = Cryptext(letters: widget.plaintext.lettersInAlphabet);
      }
    });
  }

  @override
  void setCiphertextThenPlaintext(Cryptext cryptext) {
    setState(() {
      cryptext.alphabet = widget.alphabet;
      widget.ciphertext = cryptext;
      try {
        widget.plaintext = affineDecrypt(widget.ciphertext, a, b);
      } catch (e) {
        widget.plaintext = Cryptext(letters: widget.ciphertext.lettersInAlphabet);
      }
    });
  }

  @override
  void setBreakMethod(BreakMethod method) {
    // TODO: implement setBreakMethod
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

  void setA(int a) {
    setState(() {
      this.a = a;
    });
  }

  void setB(int b) {
    setState(() {
      this.b = b;
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
          title: 'Affine Cipher',
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AEntry(
                        alphabet: widget.alphabet,
                        setA: setA,
                        a: a,
                      ),
                      SizedBox(width: 20),
                      BEntry(
                        alphabet: widget.alphabet,
                        setB: setB,
                        b: b,
                      ),
                      SizedBox(width: 20),
                      AlphabetSpaceDisplay(alphabet: widget.alphabet),
                    ],
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Mathematical Algorithm: C(p) = ap + b (mod(n))",
                    style: CustomStyle.bodyLargeText,
                  ),

                ],
              )
            ),

            SizedBox(width: 120),

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
                  breakError ? "Invalid input." : 'a = $breakA      b = $breakB',
                  style: CustomStyle.headers,
                ),
              ),
              onTap: () {
                setState(() {
                  setA(breakA);
                  setB(breakB);
                });
              },
            ),
          ],
        )
    );
  }

  void onKnownPairChange(Cryptext p, Cryptext c) {
    setState(() {
      if (isValidAffinePair(p, c)) {
        breakError = false;
        if (isValidAffinePair(p, c)) {
          Tuple2 ab = findAB(p, c);
          breakA = ab.item1;
          breakB = ab.item2;
        }
      } else {
        breakError = true;
        breakA = 1;
        breakB = 0;
      }
    });
  }

  bool isValidAffinePair(Cryptext p, Cryptext c) {
    if (p.length == 0 || c.length == 0) {
      return false;
    }
    if (p.length != c.length) {
      return false;
    }
    if (!p.isExclusiveToAlphabet || !c.isExclusiveToAlphabet) {
      return false;
    }

    try {
      var ab = findAB(p, c);
      var a = ab.item1;
      var b = ab.item2;
      return c == affineEncrypt(p, a, b);
    } catch(e) {
      return false;
    }
  }
}