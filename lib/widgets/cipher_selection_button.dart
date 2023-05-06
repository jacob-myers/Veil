import 'package:flutter/material.dart';

// Styles
import 'package:veil/styles/styles.dart';

class CipherSelectionButton extends StatefulWidget {
  final String text;
  final TextStyle _style;
  final Function() targetPage;

  CipherSelectionButton({
    super.key,
    required this.text,
    required this.targetPage,
    TextStyle? style,
  })
  : _style = style ?? CustomStyle.cipherSelectionButton;

  @override
  State<CipherSelectionButton> createState() => _CipherSelectionButton();
}

class _CipherSelectionButton extends State<CipherSelectionButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 100,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text(widget.text, style: widget._style),
        ),
      ),

      onTap: () => {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => widget.targetPage(),
            transitionDuration: Duration(milliseconds: 100),
            reverseTransitionDuration: Duration(milliseconds: 100),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          )
        )
      }
    );
  }
}