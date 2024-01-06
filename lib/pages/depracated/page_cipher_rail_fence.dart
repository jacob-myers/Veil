import 'package:flutter/material.dart';
import 'package:veil/functions/cipher_rail_fence.dart';

// Local
import 'package:veil/pages/cipher_page_state.dart';
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/break_method.dart';
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/appbar_cipher_page.dart';
import 'package:veil/widgets/crypt_io/crypt_io.dart';
import 'package:veil/widgets/cipher_rail_fence/offset_entry.dart';
import 'package:veil/widgets/cipher_rail_fence/num_rails_entry.dart';
import 'package:veil/widgets/disabled_text_display.dart';

// Styles
import 'package:veil/styles/styles.dart';

class PageCipherRailFence extends StatefulWidget {
  Alphabet defaultAlphabet;
  Alphabet alphabet;
  Cryptext plaintext;
  Cryptext ciphertext;
  String mode;

  PageCipherRailFence({
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
  State<PageCipherRailFence> createState() => _PageCipherShift();
}

class _PageCipherShift extends State<PageCipherRailFence> implements CipherPageState {
  String visual = "";
  int numRails = 1;
  int offset = 0;

  @override
  void setBreakMethod(BreakMethod method) {
    // TODO: implement setBreakMethod
  }

  @override
  void setPlaintextThenCiphertext(Cryptext cryptext) {
    setState(() {
      cryptext.alphabet = widget.alphabet;
      widget.plaintext = cryptext;
      widget.ciphertext = railFenceEncrypt(widget.plaintext, numRails, offset);
      visual = buildRailMatrixVisual(widget.plaintext, numRails, offset);
    });
  }

  @override
  void setCiphertextThenPlaintext(Cryptext cryptext) {
    setState(() {
      cryptext.alphabet = widget.alphabet;
      widget.ciphertext = cryptext;
      widget.plaintext = railFenceDecrypt(widget.ciphertext, numRails, offset);
      visual = buildRailMatrixVisual(widget.plaintext, numRails, offset);
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

  void setNumRails (int rails) {
    setState(() {
      numRails = rails;
    });
  }

  void setOffset (int offset) {
    setState(() {
      this.offset = offset;
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
          title: 'Rail Fence Cipher',
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: NumRailsEntry(
                            alphabet: widget.alphabet,
                            setNumRails: setNumRails,
                            numRails: numRails,
                          ),
                        ),

                        SizedBox(width: 20),

                        Expanded(
                          child: OffsetEntry(
                            alphabet: widget.alphabet,
                            setOffset: setOffset,
                            offset: offset,
                          ),
                        ),

                        SizedBox(width: 20),

                        Expanded(
                          child: DisabledTextDisplay(
                            title: "Offset Space",
                            content: getOffsetSpace(numRails).toString()
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Text("Layout Visual", style: CustomStyle.headers),
                    SizedBox(height: 10),

                    Scrollbar(
                      controller: controller,
                      thumbVisibility: true,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
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
                                SizedBox(height: 15),
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
        ),

        //widget.mode == 'break' ? getBreakSection() : Container(),

      ],
    );
  }

}