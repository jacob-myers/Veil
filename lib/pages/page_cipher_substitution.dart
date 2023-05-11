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

class PageCipherSubstitution extends StatefulWidget {
  Alphabet defaultAlphabet;
  Alphabet alphabet;
  Cryptext plaintext;
  Cryptext ciphertext;
  String mode;

  PageCipherSubstitution({
    super.key,
    required this.defaultAlphabet,
    Cryptext? plaintext,
    Cryptext? ciphertext,
    this.mode = 'encrypt',
  })
      : alphabet = defaultAlphabet,
        plaintext = plaintext ?? Cryptext(alphabet: defaultAlphabet),
        ciphertext = ciphertext ?? Cryptext(alphabet: defaultAlphabet);

  @override
  State<PageCipherSubstitution> createState() => _PageCipherSubstitution();
}

class _PageCipherSubstitution extends State<PageCipherSubstitution> implements CipherPageState {
  late List<String> permutation;
  String permutationInput = '';
  String visualTabular = '';
  String visualCycle = '';

  BreakMethod? breakMethod;
  List<BreakMethod> breakMethods = [];
  bool breakCommon = true;

  @override
  initState() {
    super.initState();
    permutation = widget.alphabet.letters;
    setPerm(permutation, permutationInput);
    _initBreakMethods();
  }

  void _initBreakMethods() {
    /// Initialize the cipher breaking methods.
    breakMethods = [
      BreakMethod(
          tag: 'digram_table',
          title: 'Digram Table',
          description: "A digram table shows how many instances there are of many digrams in the ciphertext. A digram is a piece of text that is two letters long. The row indicates the first letter, the column indicates the second. For example Row 'C', Column 'A' with a value of 11 means the string 'CA' appeared in the text 11 times. This digram table shows the entries of the n most frequent letters.",
          build: digramTableContent
      ),
      BreakMethod(
          tag: 'frequency',
          title: 'Individual Frequency Analysis',
          description: "How many times does each letter in the alphabet appear in the ciphertext?",
          build: getFrequencyContent
      ),
    ];
    try {
      breakMethod = breakMethods[0];
    } on RangeError {
      breakMethod = null;
    }
  }

  @override
  void setPlaintextThenCiphertext(Cryptext cryptext) {
    setState(() {
      cryptext.alphabet = widget.alphabet;
      widget.plaintext = cryptext;
      try {
        widget.ciphertext = substitutionEncrypt(widget.plaintext, permutation);
      } catch(e) {
        widget.ciphertext = Cryptext(letters: widget.plaintext.lettersInAlphabet);
      }
    });
  }

  @override
  void setCiphertextThenPlaintext(Cryptext cryptext) {
    setState(() {
      cryptext.alphabet = widget.alphabet;
      widget.ciphertext = cryptext;
      try {
        widget.plaintext = substitutionDecrypt(widget.ciphertext, permutation);
      } catch(e) {
        widget.plaintext = Cryptext(letters: widget.ciphertext.lettersInAlphabet);
      }
    });
  }

  @override
  void setBreakMethod(BreakMethod method) {
    setState(() {
      method != breakMethod ? breakCommon = true : null;
      breakMethod = method;
    });
  }

  @override
  void onModeButtonPress(String mode) {
    setState(() {
      widget.mode = mode;
    });
  }

  void setAlphabet (Alphabet newAlphabet) {
    setState(() {
      widget.alphabet = newAlphabet;
      setPerm(permutation, permutationInput);
    });
  }

  void setPerm(List<String> perm, String raw) {
    setState(() {
      permutation = perm;
      permutationInput = raw;
      visualTabular = buildTabularPermutationVisual(permutation, widget.alphabet);
      visualCycle = buildCyclePermutationVisual(permutation, widget.alphabet);
    });
  }

  @override
  Widget build(BuildContext context) {
    double outerPadding = 20;

    if (widget.mode == 'encrypt'){
      // Initializes ciphertext from plaintext.
      setPlaintextThenCiphertext(widget.plaintext);
    }
    if (widget.mode == 'decrypt') {
      // Initializes plaintext from ciphertext.
      setCiphertextThenPlaintext(widget.ciphertext);
    }
    if (widget.mode == 'break') {
      // Initializes plaintext from ciphertext.
      setCiphertextThenPlaintext(widget.ciphertext);
    }

    return Scaffold(
        appBar: AppbarCipherPage(
          title: 'Substitution Cipher',
          mode: widget.mode,
          onModeButtonPress: onModeButtonPress,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(outerPadding),
            child: getBody(context),
          ),
        )
    );
  }

  Widget getBody(BuildContext context) {
    ScrollController controller = ScrollController();

    return Column(
      children: [
        CryptIO(
          encrypt: widget.mode == 'encrypt',
          alphabet: widget.alphabet,
          setPlaintext: setPlaintextThenCiphertext,
          setCiphertext: setCiphertextThenPlaintext,
          plaintext: widget.plaintext,
          ciphertext: widget.ciphertext,
        ),

        Divider(height: 30),

        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    IntrinsicHeight(
                      child: PermutationEntry(
                        alphabet: widget.alphabet,
                        setPerm: setPerm,
                        perm: permutation,
                        rawText: permutationInput,
                      )
                    ),

                    SizedBox(height: 10),

                    Text("Tabular Notation", style: CustomStyle.headers),
                    SizedBox(height: 10),

                    MyHorizontalScrollable(
                      child: Text(
                        visualTabular,
                        style: CustomStyle.bodyLargeTextMono,
                      ),
                    ),
                    SizedBox(height: 10),

                    Text("Cycle Notation", style: CustomStyle.headers),
                    SizedBox(height: 10),
                    MyHorizontalScrollable(
                      child: Text(
                        visualCycle,
                        style: CustomStyle.bodyLargeTextMono,
                      ),
                    ),

                  ],
                ),
              ),

              VerticalDivider(
                width: 40,
                thickness: 2,
              ),

              // Right Column.
              Expanded(
                  child: AlphabetEditor(
                    title: "Instance alphabet",
                    alphabet: widget.alphabet,
                    defaultAlphabet: widget.defaultAlphabet,
                    setAlphabet: setAlphabet,
                    showResetButton: true,
                  )
              ),
            ],
          ),
        ),

        widget.mode == 'break' ? getBreakSection() : Container(),

      ],
    );
  }

  Widget getBreakSection() {
    if (breakMethod == null) {
      return Container();
    }

    return Column(
      children: [
        SizedBox(height: 10),
        Divider(height: 30),

        SizedBox(
          height: 300,
          child: Row(
            children: [
              BreakMethodList(
                methods: breakMethods,
                setBreakMethod: setBreakMethod,
                selectedMethod: breakMethod!,
              ),

              const VerticalDivider(width: 40, thickness: 2),

              Expanded(
                child: breakMethod!.build(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget digramTableContent() {
    var freq = frequency(widget.ciphertext);
    var freqSorted = freq.entries.toList();
    if (breakCommon) {
      // Most common individual chars first.
      freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char2.value.compareTo(char1.value));
    } else {
      // Least common individual chars first.
      freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char1.value.compareTo(char2.value));
    }

    String digramTableString = digramTable(widget.ciphertext, freqSorted.take(10).map((entry) => entry.key).toList());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Column(
            children: [
              MyTextButton(
                text: 'Large View',
                onTap: () {
                  // TODO Page where a full digram table can be viewed.
                }
              ),
              SizedBox(height: 10),
              MyTextButton(
                text: 'Common',
                onTap: () {
                  setState(() {
                    breakCommon = true;
                  });
                }
              ),
              SizedBox(height: 10),
              MyTextButton(
                text: 'Uncommon',
                onTap: () {
                  setState(() {
                    breakCommon = false;
                  });
                }
              ),
            ],
          ),
        ),

        SizedBox(width: 25),
        Text(
          digramTableString,
          style: CustomStyle.bodyLargeTextMono,
        ),
      ],
    );
  }

  Widget getFrequencyContent() {
    var freq = frequency(widget.ciphertext);
    int mostDigits = 0;
    for (int num in freq.values) {
      mostDigits > (num ?? 0).toString().length ? mostDigits = (num ?? 0).toString().length : null;
    }

    var freqSorted = freq.entries.toList();
    freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char2.value.compareTo(char1.value));
    if (breakCommon) {
      // Most common individual chars first.
      freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char2.value.compareTo(char1.value));
    } else {
      // Least common individual chars first.
      freqSorted.sort((MapEntry<String, int> char1, MapEntry<String, int> char2) => char1.value.compareTo(char2.value));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Column(
            children: [
              SizedBox(height: 10),
              MyTextButton(
                  text: 'Common',
                  onTap: () {
                    setState(() {
                      breakCommon = true;
                    });
                  }
              ),
              SizedBox(height: 10),
              MyTextButton(
                  text: 'Uncommon',
                  onTap: () {
                    setState(() {
                      breakCommon = false;
                    });
                  }
              ),
            ],
          ),
        ),

        SizedBox(width: 20),

        SizedBox(
          width: 100,
          child: ListView.builder(
              itemCount: widget.alphabet.length,
              itemBuilder: (BuildContext context, int i) {
                return Text(
                  "${freqSorted[i].key} ${freqSorted[i].value.toString().padLeft(mostDigits)}",
                  style: CustomStyle.bodyLargeTextMono,
                );
              }
          ),
        ),

        Spacer()
      ],
    );
  }
}