import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/widgets/crypt_io/crypt_io_text.dart';
import 'package:veil/widgets/crypt_io/crypt_io_toolbar_input.dart';
import 'package:veil/widgets/crypt_io/crypt_io_toolbar_output.dart';

// Styles
import 'package:veil/styles/styles.dart';


class CryptIO extends StatefulWidget {
  /// Indicates if the CryptIO is used for encryption or decryption.
  /// true: encryption, false: decryption.
  bool encrypt;
  Alphabet alphabet;
  Cryptext myPlaintext;
  Cryptext myCiphertext;
  final Function(Cryptext) setPlaintext;
  final Function(Cryptext) setCiphertext;

  CryptIO({
    super.key,
    required this.encrypt,
    required this.alphabet,
    required this.setPlaintext,
    required this.setCiphertext,
    Cryptext? plaintext,
    Cryptext? ciphertext,
  })
  : myPlaintext = plaintext ?? Cryptext(alphabet: alphabet),
    myCiphertext = ciphertext ?? Cryptext(alphabet: alphabet);

  @override
  State<CryptIO> createState() => _CryptIO();
}

class _CryptIO extends State<CryptIO> {

  void _setInput(Cryptext cryptext) {
    widget.encrypt ? widget.setPlaintext(cryptext) : widget.setCiphertext(cryptext);
  }

  Cryptext _getInput() {
    return widget.encrypt ? widget.myPlaintext : widget.myCiphertext;
  }

  Cryptext _getOutput() {
    return widget.encrypt ? widget.myCiphertext : widget.myPlaintext;
  }

  @override
  Widget build(BuildContext context) {
    double contextWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            children: [

              Expanded(
                child: CryptIOText(
                  key: Key('my input'),
                  title: widget.encrypt ? 'Plaintext' : 'Ciphertext',
                  alphabet: widget.alphabet,
                  hintText: widget.encrypt ? 'Enter plaintext here...' : 'Enter ciphertext here...',
                  cryptext: widget.encrypt ? widget.myPlaintext : widget.myCiphertext,
                  onChanged: widget.encrypt ? widget.setPlaintext : widget.setCiphertext,
                ),
              ),

              Container(
                width: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                        Icons.arrow_forward
                    ),
                    SizedBox(height: 10),
                    Icon(
                        widget.encrypt ? Icons.lock : Icons.lock_open
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.encrypt ? 'Encrypting' : 'Decrypting',
                      style: CustomStyle.content,
                    )
                  ],
                ),
              ),

              Expanded(
                child: CryptIOText(
                  title: widget.encrypt ? 'Ciphertext' : 'Plaintext',
                  alphabet: widget.alphabet,
                  cryptext: widget.encrypt ? widget.myCiphertext : widget.myPlaintext,
                  enabled: false,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: CryptIOToolbarInput(
                getInput: _getInput,
                setInput: _setInput,
                alphabet: widget.alphabet,
              ),
            ),

            SizedBox(width: 120),

            Expanded(
              child: CryptIOToolbarOutput(
                getOutput: _getOutput,
              )
            ),
          ],
        )
      ],
    );
  }
}