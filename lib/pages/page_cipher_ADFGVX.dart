import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Local
// Pages
import 'package:veil/pages/page_cipher.dart';

// Data Structures
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/styles/styles.dart';
import 'package:veil/widgets/grid_editable.dart';
import 'package:veil/widgets/my_text_button.dart';
import 'package:veil/widgets/string_value_entry.dart';

import '../data_structures/alphabet.dart';
import '../widgets/alphabet_editor.dart';

class PageCipherADFGVX extends PageCipher {
  PageCipherADFGVX({
    super.key,
    super.title = "ADFGVX Cipher",
    required super.defaultAlphabet,
  });

  @override
  State<PageCipherADFGVX> createState() => _PageCipherADFGVX();
}

class _PageCipherADFGVX extends State<PageCipherADFGVX> {
  int cipherTextCharactersMax = 10;
  List<String> ciphertextChars = ['A', 'D', 'F', 'G', 'V', 'X'];
  List<String> defaultChars = ['A', 'D', 'F', 'G', 'V', 'X'];
  late List<List<String?>> keyarray;
  bool alphabetLengthMatch = true;
  var random = Random();

  void callSetState() {
    setState(() {});
  }

  List<List<String?>> getEmptyKeyArray() {
    return List.generate(ciphertextChars.length, (index) => List.generate(ciphertextChars.length, (index) => null));
  }

  @override
  void initState() {
    super.initState();
    widget.initSetPlaintextThenCiphertext((Cryptext cryptext) => {

    });
    widget.initSetCiphertextThenPlaintext((Cryptext cryptext) => {

    });

    widget.setBreakMethods([

    ]);

    keyarray = getEmptyKeyArray();
  }

  void setCiphertextChars(List<String> newChars) {
    setState(() {
      ciphertextChars = newChars;
      // Grows or shrinks the existing keyarray as to not reset data each time.
      while (keyarray.length > ciphertextChars.length) {
        keyarray.removeLast();
        for (var element in keyarray) {
          element.removeLast();
        }
      }
      while (keyarray.length < ciphertextChars.length) {
        keyarray.add(List.generate(keyarray.length, (index) => null));
        for (var element in keyarray) {
          element.add(null);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    alphabetLengthMatch = pow(ciphertextChars.length, 2) == widget.alphabet.length;

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

                  // Error about alphabet length vs ciphertext char amount
                  alphabetLengthMatch ? Container() : Text(
                    "* Error: Alphabet Length: ${widget.alphabet.length}, Matrix Size: ${pow(ciphertextChars.length, 2)}",
                    style: CustomStyle.bodyError,
                  ),
                  alphabetLengthMatch ? Container() : SizedBox(height: 10),

                  StringValueEntry(
                    title: "Ciphertext Characters",
                    onChanged: (String str) {
                      if (str.length > cipherTextCharactersMax) {
                        setCiphertextChars(str.substring(0, cipherTextCharactersMax).split(""));
                      } else {
                        setCiphertextChars(str.split(""));
                      }
                    },
                    value: ciphertextChars.join(),
                    defaultValue: defaultChars.join(),
                    showResetButton: true,
                  ),

                  SizedBox( height: 10 ),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Key Matrix",
                          style: CustomStyle.headers,
                        ),
                      ),

                      Row(
                        children: [
                          MyTextButton(
                              text: "Copy",
                              onTap: () async {
                                await Clipboard.setData(ClipboardData(
                                  text: keyarray.map((e) {return e.join();}).join("\n")
                                ));
                              }
                          ),
                          SizedBox(width: 10),
                          MyTextButton(
                              text: "Paste",
                              onTap: () async {
                                Clipboard.getData(Clipboard.kTextPlain).then((data){
                                  setState(() {
                                    //print(data?.text?.split('\n').map((e) { return e.split(""); }).toList());
                                    //List<List<String>> importedKeyArray = [];
                                    var importedKeyArray = (data?.text?.split('\n').map((e) { return e.split(""); }).toList())!;
                                    // If the imported data forms a square key array of the correct size.
                                    if (importedKeyArray.where((element) => element.length != ciphertextChars.length).isEmpty && keyarray.length == ciphertextChars.length) {
                                      keyarray = importedKeyArray;
                                    }
                                  });
                                });
                              }
                          ),
                          SizedBox(width: 10),
                          MyTextButton(
                              text: "Randomize",
                              onTap: () {
                                // Randomizes the entries in the keyarray, if the sizes match.
                                setState(() {
                                  if (alphabetLengthMatch) {
                                    List<String> alpha = widget.alphabet.deepCopy().letters;
                                    for (int i = 0; i < keyarray.length; i++) {
                                      for (int j = 0; j < keyarray[i].length; j++) {
                                        var randomIndex = random.nextInt(alpha.length);
                                        keyarray[i][j] = alpha.elementAt(randomIndex);
                                        alpha.removeAt(randomIndex);
                                      }
                                    }
                                  }
                                });
                              }
                          ),
                          SizedBox(width: 10),
                          MyTextButton(
                            text: "Reset",
                            onTap: () {
                              setState(() {
                                keyarray = getEmptyKeyArray();
                              });
                            }
                          )
                        ],
                      ),

                    ],
                  ),

                  Divider(),

                  GridEditable(
                    rowTitles: ciphertextChars,
                    colTitles: ciphertextChars,
                    values: keyarray,
                    onValueChange: (String str) { setState(() {}); },
                    charLimit: 1,
                  ),

                ],
              ),
            ),

            VerticalDivider(
              width: 40,
              thickness: 2,
            ),

            Expanded(
              child: AlphabetEditor(
                title: "Instance alphabet",
                alphabet: widget.alphabet,
                defaultAlphabet: widget.defaultAlphabet,
                setAlphabet: (Alphabet newAlphabet) {
                  setState(() {
                    widget.alphabet = newAlphabet;
                  });
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