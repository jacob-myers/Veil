import 'package:flutter/material.dart';

// Styles
import 'package:veil/styles/styles.dart';

class CryptIOButton extends StatefulWidget {
  final Icon icon;
  final Function() onTap;

  CryptIOButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  State<CryptIOButton> createState() => _CryptIOButton();
}

class _CryptIOButton extends State<CryptIOButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: 40,
        height: 40,
        child: widget.icon,
      ),
      onTap: () {
        widget.onTap();
      },
    );
  }
}