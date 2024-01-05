import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veil/data/cipher_pages.dart';

// Local
import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/widgets/alphabet_editor.dart';
import 'package:veil/widgets/cipher_selection_button.dart';

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

    Map<String, Widget> cipherPages = getCipherPages(myDefaultAlphabet);

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
                    child: ListView.separated(
                      itemCount: cipherPages.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                      itemBuilder: (BuildContext context, int i) {
                        return CipherSelectionButton(
                          text: cipherPages.keys.toList()[i],
                          targetPage: () => cipherPages[cipherPages.keys.toList()[i]]!
                        );
                      },
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
                    text: "Github Code",
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