import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';

// Styles
import 'package:veil/styles/styles.dart';

class MyHorizontalScrollable extends StatefulWidget {
  Widget child;

  MyHorizontalScrollable({
    super.key,
    required this.child,
  });

  @override
  State<MyHorizontalScrollable> createState() => _MyHorizontalScrollable();
}

class _MyHorizontalScrollable extends State<MyHorizontalScrollable> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      child: SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          // HORIZONTAL SCROLLS HAVE TO BE IN A ROW FOR SOME REASON.
          child: Row(
            children: [
              Column(
                children: [
                  widget.child,
                  SizedBox(height: 15),
                ],
              )
            ],
          )
      ),
    );
  }
}
