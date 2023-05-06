import 'package:flutter/material.dart';

// Styles
import 'package:veil/styles/styles.dart';

class MyTextButton extends StatefulWidget {
  final String text;
  final Function() onTap;

  MyTextButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<MyTextButton> createState() => _MyTextButton();
}

class _MyTextButton extends State<MyTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: CustomStyle.pageScheme.onSecondary),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 7, 10, 10),
          child: Text(
            widget.text,
            style: CustomStyle.darkButton,
          ),
        ),
      ),

      onTap: () {
        widget.onTap();
      },
    );
  }
}