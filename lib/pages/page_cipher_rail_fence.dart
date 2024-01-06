import 'package:flutter/material.dart';

// Local
// Pages
import 'package:veil/pages/page_cipher.dart';

// Styles
import 'package:veil/styles/styles.dart';

// Data Structures
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/alphabet.dart';

// Functions
import 'package:veil/functions/cipher_rail_fence.dart';

// Widgets
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/cipher_rail_fence/num_rails_entry.dart';
import 'package:veil/widgets/cipher_rail_fence/offset_entry.dart';
import 'package:veil/widgets/disabled_text_display.dart';

class PageCipherRailFence extends PageCipher {
  PageCipherRailFence({
    super.key,
    super.title = "Rail Fence Cipher",
    required super.defaultAlphabet,
  });

  @override
  State<PageCipherRailFence> createState() => _PageCipherRailFence();
}

class _PageCipherRailFence extends State<PageCipherRailFence> {
  String visual = "";
  int numRails = 1;
  int offset = 0;

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
        widget.ciphertext = railFenceEncrypt(widget.plaintext, numRails, offset);
        visual = buildRailMatrixVisual(widget.plaintext, numRails, offset);
      })
    });
    widget.initSetCiphertextThenPlaintext((Cryptext cryptext) => {
      setState(() {
        cryptext.alphabet = widget.alphabet;
        widget.ciphertext = cryptext;
        widget.plaintext = railFenceDecrypt(widget.ciphertext, numRails, offset);
        visual = buildRailMatrixVisual(widget.plaintext, numRails, offset);
      })
    });

    widget.setBreakMethods([]);
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    visual = buildRailMatrixVisual(widget.plaintext, numRails, offset);
    
    return widget.pageFromSectionsDefaultBreakSectionCombinedED(
      callSetState: callSetState,
      cryptSection: IntrinsicHeight(
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
                          setNumRails: (int newNumRails) {
                            setState(() {
                              numRails = newNumRails;
                            });
                          },
                          numRails: numRails,
                        ),
                      ),

                      SizedBox(width: 20),

                      Expanded(
                        child: OffsetEntry(
                          alphabet: widget.alphabet,
                          setOffset: (int newOffset) {
                            setState(() {
                              offset = newOffset;
                            });
                          },
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