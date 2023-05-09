import 'package:flutter/material.dart';
import 'package:veil/functions/cipher_substitution.dart';

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
import 'package:veil/widgets/partial_text_display.dart';
import 'package:veil/widgets/ciphertext_plaintext_pair_entry.dart';
import 'package:veil/widgets/cipher_shift/shift_amount_entry.dart';
import 'package:veil/widgets/disabled_text_display.dart';

// Styles
import 'package:veil/styles/styles.dart';
import 'package:veil/widgets/string_value_entry.dart';

class PageCipherSubstitution extends StatefulWidget {
  Alphabet defaultAlphabet;
  Alphabet alphabet;
  Cryptext plaintext;
  Cryptext ciphertext;
  String mode;

  PageCipherSubstitution({
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
  State<PageCipherSubstitution> createState() => _PageCipherSubstitution();
}

class _PageCipherSubstitution extends State<PageCipherSubstitution> implements CipherPageState {
  late List<String> permutation;
  String permutationInput = '';
  String visual = '';

  @override
  initState() {
    super.initState();
    permutation = widget.alphabet.letters;
    setPerm(permutationInput);
  }

  @override
  void setPlaintextThenCiphertext(Cryptext cryptext) {
    setState(() {
      cryptext.alphabet = widget.alphabet;
      widget.plaintext = cryptext;
      try {
        widget.ciphertext = substitutionEncrypt(widget.plaintext, permutation);
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
        widget.plaintext = substitutionDecrypt(widget.ciphertext, permutation);
      } catch(e) {
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
      setPerm(permutationInput);
    });
  }

  void setPerm(String raw) {
    setState(() {
      // TODO if permutation is within alphabet
      List<String> newPerm = parseCycleNotation(raw);
      List<String> permChars = newPerm.join().split('');
      if (permutationIsInAlphabet(newPerm, widget.alphabet) && permutationIsUnique(newPerm)) {
        for (String char in widget.alphabet.letters) {
          if (!permChars.contains(char)) {
            newPerm.add(char);
          }
        }
        permutation = newPerm;
        visual = buildPermutationVisual(permutation, widget.alphabet);
      }
      permutationInput = raw;
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
          title: 'Substitution Cipher',
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
    ScrollController controller = ScrollController();

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
              // Left Column.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    IntrinsicHeight(
                      child: StringValueEntry(
                        title: 'Key (Permutation in cycle notation)',
                        value: permutationInput,
                        onChanged: setPerm,
                        showResetButton: true,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text("Tabular Notation", style: CustomStyle.headers),
                    SizedBox(height: 10),

                    Scrollbar(
                      controller: controller,
                      isAlwaysShown: true,
                      child: SingleChildScrollView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        // HORIZONTAL SCROLLS HAVE TO BE IN A ROW FOR SOME REASON.
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  visual,
                                  style: CustomStyle.bodyLargeTextMono,
                                ),
                                SizedBox(height: 10),
                              ],
                            )
                          ],
                        )
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
                    setAlphabet: setAlphabet,
                    showResetButton: true,
                  )
              ),
            ],
          ),
        )

      ],
    );
  }

}