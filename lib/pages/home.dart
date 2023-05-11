import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/pages/page_cipher_affine.dart';
import 'package:veil/pages/page_cipher_rail_fence.dart';
import 'package:veil/pages/page_cipher_substitution.dart';
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/cipher_selection_button.dart';
import 'package:veil/pages/page_cipher_shift.dart';

// Styles
import 'package:veil/styles/styles.dart';
import 'package:veil/widgets/my_text_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late Alphabet myDefaultAlphabet;

  void setAlphabet([Alphabet? alphabet]) {
    setState(() {
      myDefaultAlphabet = alphabet ?? Alphabet();
    });
  }

  @override
  void initState() {
    setAlphabet();
  }

  @override
  Widget build(BuildContext context) {
    // Width and height of app.
    double outerPadding = 20;
    double contextWidth = MediaQuery.of(context).size.width - 2*outerPadding;
    double contextHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [

            // Cipher list.
            SizedBox(
              width: contextWidth/3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text('Select a cipher', style: CustomStyle.headers),
                  ),

                  SizedBox(height: 10),
                  Divider(),

                  Expanded(
                    child: ListView(
                      children: [
                        // Shift cipher button
                        CipherSelectionButton(
                          text: 'Shift Cipher',
                          targetPage: () => PageCipherShift(defaultAlphabet: myDefaultAlphabet),
                        ),
                        Divider(),

                        CipherSelectionButton(
                          text: 'Rail Fence Cipher',
                          targetPage: () => PageCipherRailFence(defaultAlphabet: myDefaultAlphabet),
                        ),
                        Divider(),

                        CipherSelectionButton(
                          text: 'Affine Cipher',
                          targetPage: () => PageCipherAffine(defaultAlphabet: myDefaultAlphabet),
                        ),
                        Divider(),

                        CipherSelectionButton(
                          text: 'Substitution Cipher',
                          targetPage: () => PageCipherSubstitution(defaultAlphabet: myDefaultAlphabet),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),

            VerticalDivider(width: 40, thickness: 2,),

            Expanded(
              //width: contextWidth/3*2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Settings', style: CustomStyle.headers),
                  SizedBox(height: 10),
                  Divider(),

                  AlphabetEditor(
                    title: 'Default alphabet (Order and case matter)',
                    alphabet: myDefaultAlphabet,
                    setAlphabet: setAlphabet,
                    showDefaultButtons: true,
                  ),
                  Divider(height: 25, thickness: 2),

                  // Open's link to repo; https://github.com/jacob-myers/Veil
                  MyTextButton(
                    text: "Open Github Code",
                    width: 190,
                    onTap: () async {
                      var url = Uri.parse("https://github.com/jacob-myers/Veil");

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }
                  )

                ],
              ),
            ),

          ],
        )
      )
    );
  }
}