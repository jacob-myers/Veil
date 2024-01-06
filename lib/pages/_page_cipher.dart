import 'package:flutter/material.dart';

// Local
// Pages
import 'package:veil/pages/page_cipher.dart';

// Data Structures
import 'package:veil/data_structures/cryptext.dart';

class PAGECIPHERNAME extends PageCipher {
  PAGECIPHERNAME({
    super.key,
    super.title = "TITLE",
    required super.defaultAlphabet,
  });

  @override
  State<PAGECIPHERNAME> createState() => _PAGECIPHERNAME();
}

class _PAGECIPHERNAME extends State<PAGECIPHERNAME> {

  void callSetState() {
    setState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("Build section not implemented.");
  }
}