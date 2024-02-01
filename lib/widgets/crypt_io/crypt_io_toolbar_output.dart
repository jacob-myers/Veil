import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Local
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/widgets/crypt_io/crypt_io_button.dart';
import 'package:veil/widgets/crypt_io/crypt_io_toolbar.dart';
import 'package:veil/functions/veil_io.dart';

// Styles
import 'package:veil/styles/styles.dart';

class CryptIOToolbarOutput extends StatefulWidget {
  final Cryptext output;

  CryptIOToolbarOutput({
    super.key,
    required this.output,
  });

  @override
  State<CryptIOToolbarOutput> createState() => _CryptIOToolbarOutput();
}

class _CryptIOToolbarOutput extends State<CryptIOToolbarOutput> {
  @override
  Widget build(BuildContext context) {
    return CryptIOToolbar(
      buttons: [
        CryptIOButton(
          icon: Icon(Icons.copy),
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: widget.output.lettersAsString));
          },
        ),

        CryptIOButton(
          icon: Icon(Icons.file_download_outlined),
          onTap: () {
            saveToFile(widget.output);
          },
        ),

      ],
    );
  }
}