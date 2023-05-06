import 'package:flutter/material.dart';

// Local
import 'package:veil/widgets/crypt_io/crypt_io_button.dart';

// Styles
import 'package:veil/styles/styles.dart';

class CryptIOToolbar extends StatefulWidget {
  final List<CryptIOButton> buttons;

  CryptIOToolbar({
    super.key,
    required this.buttons,
  });

  @override
  State<CryptIOToolbar> createState() => _CryptIOToolbarInput();
}

class _CryptIOToolbarInput extends State<CryptIOToolbar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.buttons
    );
  }
}