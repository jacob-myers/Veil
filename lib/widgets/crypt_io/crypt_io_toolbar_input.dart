import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:veil/data/app_settings.dart';

// Local
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/widgets/crypt_io/crypt_io_button.dart';
import 'package:veil/widgets/crypt_io/crypt_io_toolbar.dart';
import 'package:veil/functions/veil_io.dart';

// Styles
import 'package:veil/styles/styles.dart';

class CryptIOToolbarInput extends StatefulWidget {
  final Cryptext input;
  final Function(Cryptext) setInput;
  final Alphabet alphabet;

  CryptIOToolbarInput({
    super.key,
    required this.input,
    required this.setInput,
    required this.alphabet,
  });

  @override
  State<CryptIOToolbarInput> createState() => _CryptIOToolbarInput();
}

class _CryptIOToolbarInput extends State<CryptIOToolbarInput> {
  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        CryptIOToolbar(
          buttons: [
            CryptIOButton(
              icon: Icon(Icons.arrow_upward),
              onTap: () {
                setState(() {
                  widget.setInput(Cryptext(
                      letters : widget.input.upper,
                      alphabet: widget.alphabet));
                });
              },
            ),

            CryptIOButton(
              icon: Icon(Icons.arrow_downward),
              onTap: () {
                setState(() {
                  widget.setInput(Cryptext(
                      letters : widget.input.lower,
                      alphabet: widget.alphabet));
                });
              },
            ),

            CryptIOButton(
              icon: Icon(Icons.file_upload_outlined),
              onTap: () async {
                widget.setInput(await loadFromFile(widget.alphabet));
                setState(() {});
              },
            ),

            CryptIOButton(
              icon: Icon(Icons.file_download_outlined),
              onTap: () {
                saveToFile(widget.input);
              },
            ),

            CryptIOButton(
              icon: Icon(Icons.copy),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: widget.input.lettersAsString));
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
                              data?.text ?? widget.input.lettersAsString,
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
        ),

        Spacer(),
        Text(
          "${widget.input.length}/${AppSettings.characterLimit}",
          style: CustomStyle.characterCounter,
        ),
        SizedBox(width: 5),
      ],
    );
  }
}