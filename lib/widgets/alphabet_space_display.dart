import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';

// Styles
import 'package:veil/styles/styles.dart';

class AlphabetSpaceDisplay extends StatefulWidget {
  final Alphabet alphabet;

  const AlphabetSpaceDisplay({
    super.key,
    required this.alphabet,
  });


  @override
  State<AlphabetSpaceDisplay> createState() => _AlphabetSpaceDisplay();
}

class _AlphabetSpaceDisplay extends State<AlphabetSpaceDisplay> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Alphabet space', style: CustomStyle.headers),

          SizedBox(height: 10),

          IntrinsicHeight(
            child: TextField(
              style: CustomStyle.disabledTextEntry,
              controller: TextEditingController(text: widget.alphabet.length.toString()),
              enabled: false,

              // Styling.
              cursorColor: CustomStyle.pageScheme.onPrimary,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: CustomStyle.disabledTextEntryBorderColor, width: 1)
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
