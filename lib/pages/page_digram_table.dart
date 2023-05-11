import 'package:flutter/material.dart';
import 'package:veil/functions/cipher_substitution.dart';
import 'package:veil/functions/digram.dart';
import 'package:veil/functions/frequency.dart';

// Local
import 'package:veil/pages/cipher_page_state.dart';
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/break_method.dart';
import 'package:veil/functions/cipher_shift.dart';
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/appbar_cipher_page.dart';
import 'package:veil/widgets/break_method_list.dart';
import 'package:veil/widgets/crypt_io/crypt_io.dart';
import 'package:veil/widgets/my_text_button.dart';
import 'package:veil/widgets/partial_text_display.dart';
import 'package:veil/widgets/ciphertext_plaintext_pair_entry.dart';
import 'package:veil/widgets/cipher_shift/shift_amount_entry.dart';
import 'package:veil/widgets/disabled_text_display.dart';
import 'package:veil/widgets/cipher_substitution/permutation_entry.dart';
import 'package:veil/widgets/string_value_entry.dart';
import 'package:veil/widgets/my_horizontal_scrollable.dart';
import 'package:veil/widgets/cipher_substitution/digram_table_size_entry.dart';

// Styles
import 'package:veil/styles/styles.dart';

class PageDigramTable extends StatefulWidget {
  Cryptext text;

  PageDigramTable({
    super.key,
    required this.text,
  });

  @override
  State<PageDigramTable> createState() => _PageDigramTable();
}

class _PageDigramTable extends State<PageDigramTable>{
  bool showCommon = true;

  @override
  Widget build(BuildContext context) {
    var freq = frequency(widget.text);

    var freqSorted = freq.entries.toList();
    if (showCommon) {
      // Most common individual chars first.
      freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char2.value.compareTo(char1.value));
    } else {
      // Least common individual chars first.
      freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char1.value.compareTo(char2.value));
    }

    String digramTableString = digramTable(widget.text, freqSorted.take(widget.text.alphabet.length).map((entry) => entry.key).toList());

    return Scaffold(
      appBar: AppBar(
        title: Text("Digram Table"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: Column(
                children: [
                  MyTextButton(
                      text: 'Common',
                      onTap: () {
                        setState(() {
                          showCommon = true;
                        });
                      }
                  ),
                  SizedBox(height: 10),
                  MyTextButton(
                      text: 'Uncommon',
                      onTap: () {
                        setState(() {
                          showCommon = false;
                        });
                      }
                  ),
                ],
              ),
            ),

            SizedBox(width: 25),
            Expanded(
              child: MyHorizontalScrollable(
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        Text(
                          digramTableString,
                          style: CustomStyle.bodyLargeTextMono,
                        ),
                        SizedBox(width: 20),
                      ],
                    )
                  ),
                )
              ),
            ),
          ],
        ),
      )
    );
  }
}