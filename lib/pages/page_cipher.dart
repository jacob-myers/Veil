import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/break_method.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/widgets/appbar_cipher_page.dart';
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

  void setAlphabet (Alphabet newAlphabet) {
    alphabet = newAlphabet;
  }

  void setBreakMethod(BreakMethod method) {
    breakMethod = method;
  }

  void onModeButtonPress(String newMode) {
    mode = newMode;
  }

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
  Widget pageFromWidget(BuildContext context, { required Widget body }) {
    updateMode();

    return Scaffold(
      appBar: AppbarCipherPage(
        title: title,
        mode: mode,
        onModeButtonPress: onModeButtonPress,
      ),

      body: body,
    );
  }

  /// Builds the page given the different parts.
  Widget pageFromSections({ Widget? encryptSection, Widget? decryptSection, Widget? breakSection, required Function() callSetState, bool encryptDecryptCombined = false}) {
    decryptSection = encryptDecryptCombined && encryptSection != null ? encryptSection : decryptSection;

    bool buildEncrypt = mode == 'encrypt' && encryptSection != null;
    bool buildDecrypt = (mode == 'decrypt' || mode == 'break') && decryptSection != null;
    bool buildBreak = mode == 'break' && breakSection != null;

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