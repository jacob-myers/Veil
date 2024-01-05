import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/break_method.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/widgets/appbar_cipher_page.dart';
import 'package:veil/widgets/break_method_list.dart';
import 'package:veil/widgets/crypt_io/crypt_io.dart';

class PageCipher extends StatefulWidget {
  Alphabet defaultAlphabet;
  Alphabet alphabet;
  Cryptext plaintext;
  Cryptext ciphertext;
  String mode;
  String title;
  BreakMethod? breakMethod;
  List<BreakMethod> breakMethods = [];
  bool breakError = false;
  Function(Cryptext cryptext) setPlaintextThenCiphertext = (Cryptext cryptext) => {};
  Function(Cryptext cryptext) setCiphertextThenPlaintext = (Cryptext cryptext) => {};

  PageCipher({
    super.key,
    required this.defaultAlphabet,
    Cryptext? plaintext,
    Cryptext? ciphertext,
    this.mode = 'encrypt',
    this.title = 'Title',
  })
  : alphabet = defaultAlphabet,
    plaintext = plaintext ?? Cryptext(alphabet: defaultAlphabet),
    ciphertext = ciphertext ?? Cryptext(alphabet: defaultAlphabet);

  void setBreakMethods(List<BreakMethod> breakMethods) {
    /// Initialize the cipher breaking methods from parameter.
    breakMethods = breakMethods;
    try {
      breakMethod = breakMethods[0];
    } on RangeError {
      breakMethod = null;
    }
  }

  void initSetPlaintextThenCiphertext(Function(Cryptext) setPlaintextThenCiphertext) {
    this.setPlaintextThenCiphertext = setPlaintextThenCiphertext;
  }

  void initSetCiphertextThenPlaintext(Function(Cryptext) setCiphertextThenPlaintext) {
    this.setCiphertextThenPlaintext = setCiphertextThenPlaintext;
  }

  void updateMode() {
    // Initializes ciphertext from plaintext if encrypting.
    if (mode == 'encrypt') {
      setPlaintextThenCiphertext(plaintext);
    }
    // Initializes plaintext from ciphertext if decrypting or breaking.
    else if (mode == 'decrypt') {
      setCiphertextThenPlaintext(ciphertext);
    }
    else if (mode == 'break') {
      setCiphertextThenPlaintext(ciphertext);
    }
  }

  /// Builds the page given the whole body.
  Widget pageFromBody({ required Widget body, required Function() callSetState }) {
    updateMode();

    return Scaffold(
      appBar: AppbarCipherPage(
        title: title,
        mode: mode,
        onModeButtonPress: (String newMode) { mode = newMode; callSetState(); },
      ),

      body: body,
    );
  }

  /// Builds the default break section using the breakMethods list.
  Widget defaultBreakSection({required Function() callSetState}) {
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
                setBreakMethod: (BreakMethod newBreakMethod) {
                  breakMethod = newBreakMethod;
                  callSetState();
                },
                selectedMethod: breakMethod,
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

  /// Builds the page from the encrypt and decrypt sections, using the default
  /// break section.
  Widget pageFromSectionsDefaultBreakSection({ required Widget encryptSection, required Widget decryptSection, required Function() callSetState}) {
    return pageFromSections(
      callSetState: callSetState,
      encryptSection: encryptSection,
      decryptSection: decryptSection,
      breakSection: defaultBreakSection(callSetState: callSetState),
    );
  }

  /// Builds the page from the encrypt/decrypt and break sections. Use this if
  /// encrypt and decrypt sections are the same.
  Widget pageFromSectionsCombinedED({ required Widget cryptSection, required Widget breakSection, required Function() callSetState }) {
    return pageFromSections(
      callSetState: callSetState,
      encryptSection: cryptSection,
      decryptSection: cryptSection,
      breakSection: breakSection,
    );
  }

  /// Builds the page from the encrypt/decrypt section. Use this if encrypt and
  /// decrypt are the same and want to use the default break section.
  Widget pageFromSectionsDefaultBreakSectionCombinedED({ required Widget cryptSection, required Function() callSetState }) {
    return pageFromSections(
      callSetState: callSetState,
      encryptSection: cryptSection,
      decryptSection: cryptSection,
      breakSection: defaultBreakSection(callSetState: callSetState),
    );
  }

  /// Builds the page given each part.
  Widget pageFromSections({ required Widget encryptSection, required Widget decryptSection, required Widget breakSection, required Function() callSetState}) {
    bool buildEncrypt = mode == 'encrypt';
    bool buildDecrypt = mode == 'decrypt' || mode == 'break';
    bool buildBreak = mode == 'break';

    updateMode();

    double outerPadding = 20;
    return Scaffold(
      appBar: AppbarCipherPage(
        title: title,
        mode: mode,
        onModeButtonPress: (String newMode) { mode = newMode; callSetState(); },
        disableBreakButton: breakMethods.isEmpty ? true : false,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(outerPadding),
          child: Column(
            children: [
              CryptIO(
                encrypt: mode == 'encrypt',
                alphabet: alphabet,
                setPlaintext: setPlaintextThenCiphertext,
                setCiphertext: setCiphertextThenPlaintext,
                plaintext: plaintext,
                ciphertext: ciphertext,
              ),

              Divider(height: 30),

              buildEncrypt ? encryptSection : Container(),
              buildDecrypt ? decryptSection : Container(),
              buildBreak ? breakSection : Container(),
            ],
          )
        ),
      )
    );
  }

  @override
  State<PageCipher> createState() => _PageCipher();
}

class _PageCipher extends State<PageCipher> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}