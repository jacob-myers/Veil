import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

// Local
import 'package:veil/pages/cipher_page_state.dart';
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/break_method.dart';
import 'package:veil/widgets/appbar_cipher_page.dart';
import 'package:veil/widgets/crypt_io/crypt_io.dart';
import 'package:veil/widgets/break_method_list.dart';
import 'package:veil/functions/cipher_viginere.dart';
import 'package:veil/widgets/disabled_text_display.dart';
import 'package:veil/widgets/keyword_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

import '../../widgets/alphabet_editor.dart';

class PageCipherViginere extends StatefulWidget {
  Alphabet defaultAlphabet;
  Alphabet alphabet;
  Cryptext plaintext;
  Cryptext ciphertext;
  String mode;

  PageCipherViginere({
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
  State<PageCipherViginere> createState() => _PageCipherViginere();
}

class _PageCipherViginere extends State<PageCipherViginere> implements CipherPageState {
  Cryptext keyword = Cryptext();
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
    breakMethods = [];
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
        widget.ciphertext = viginereEncrypt(widget.plaintext, keyword);
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
        widget.plaintext = viginereDecrypt(widget.ciphertext, keyword);
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

  void setKeyword([Cryptext? keyword]) {
    setState(() {
      this.keyword = keyword ?? this.keyword;
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
          title: 'Viginere Cipher',
          mode: widget.mode,
          onModeButtonPress: onModeButtonPress,
          disableBreakButton: true,
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

        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: KeywordEntry(
                  keyword: keyword,
                  alphabet: widget.alphabet,
                  setKeyword: setKeyword,
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
                  setAlphabet: setAlphabet,
                  showResetButton: true,
                )
              ),

            ],
          ),
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
        const SizedBox(height: 10),
        const Divider(height: 30),

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
              const VerticalDivider(width: 40, thickness: 2),

              breakMethod!.build(),
            ],
          ),
        ),
      ],
    );
  }

}