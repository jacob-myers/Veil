import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Local
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/widgets/crypt_io/crypt_io_button.dart';
import 'package:veil/widgets/crypt_io/crypt_io_toolbar.dart';

// Styles
import 'package:veil/styles/styles.dart';

class CryptIOToolbarInput extends StatefulWidget {
  final Cryptext Function() getInput;
  final Function(Cryptext) setInput;
  final Alphabet alphabet;

  CryptIOToolbarInput({
    super.key,
    required this.getInput,
    required this.setInput,
    required this.alphabet,
  });

  @override
  State<CryptIOToolbarInput> createState() => _CryptIOToolbarInput();
}

class _CryptIOToolbarInput extends State<CryptIOToolbarInput> {
  @override
  Widget build(BuildContext context) {
    return CryptIOToolbar(
      buttons: [
        CryptIOButton(
          icon: Icon(Icons.arrow_upward),
          onTap: () {
            setState(() {
              widget.setInput(Cryptext(
                  letters : widget.getInput().upper,
                  alphabet: widget.alphabet));
            });
          },
        ),

        CryptIOButton(
          icon: Icon(Icons.arrow_downward),
          onTap: () {
            setState(() {
              widget.setInput(Cryptext(
                  letters : widget.getInput().lower,
                  alphabet: widget.alphabet));
            });
          },
        ),

        CryptIOButton(
          icon: Icon(Icons.file_upload_outlined),
          onTap: () {
            setState(() {
              // TODO Upload txt file.
            });
          },
        ),

        CryptIOButton(
          icon: Icon(Icons.file_download_outlined),
          onTap: () {
            setState(() {
              // TODO Download as a txt file.
            });
          },
        ),

        CryptIOButton(
          icon: Icon(Icons.copy),
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: widget.getInput().lettersAsString));
          },
        ),

        CryptIOButton(
          icon: Icon(Icons.paste),
          onTap: () async {
            Clipboard.getData(Clipboard.kTextPlain).then((data){
              setState(() {
                if (data?.text != '') {
                  widget.setInput(
                      Cryptext.fromString(
                          data?.text ?? widget.getInput().lettersAsString,
                          alphabet: widget.alphabet));
                }
              });
            });
          },
        ),

        CryptIOButton(
          icon: Icon(Icons.delete),
          onTap: () {
            setState(() {
              widget.setInput(Cryptext(alphabet: widget.alphabet));
            });
          },
        ),

      ],
    );
  }
}