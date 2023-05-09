import 'package:flutter/material.dart';

// Styles
import 'package:veil/styles/styles.dart';

class MyTextButton extends StatefulWidget {
  final String text;
  final Function() onTap;
  final int? height;
  final int? width;

  MyTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height,
    this.width,
  });

  @override
  State<MyTextButton> createState() => _MyTextButton();
}

class _MyTextButton extends State<MyTextButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: widget.width?.toDouble(),
        height: widget.height?.toDouble(),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: CustomStyle.pageScheme.onSecondary),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 7, 10, 10),
              child: Text(
                widget.text,
                style: CustomStyle.darkButton,
              ),
            ),
          )
        ),
      ),

      onTap: () {
        widget.onTap();
      },
    );
  }
}