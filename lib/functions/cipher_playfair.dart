import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:tuple/tuple.dart';

/*

Rules:

Alphabet rules:
  Must have 25 characters
  Check if standard english, upper or lower. if so, remove, i, replace with j

If there are repeated letters, ie "LETTERS", insert X between them; 'TT' into 'TX' and 'TE'
  'TTTTTB' -> 'TX' 'TX' 'TX' 'TX' 'TB'
  'XXV' -> 'X-' 'XV'

Inputs:   Padding character. Default second to last letter.
          Padding character padding character. Default last letter.
*/

Cryptext playfairEncrypt(Cryptext input, Cryptext keyword, [String padChar = '', String padCharPadChar = '']) {

  Alphabet a = input.alphabet;

  if (a != keyword.alphabet) {
    throw Exception("PlayfairParametersError: input and keyword have different alphabets.");
  }

  if (a.length != 25) {
    throw Exception("PlayfairParametersError: Alphabet must be 25 characters long.");
  }

  // Checking validity of padding characters.
  if (padChar == '') {
    padChar = a.letters[a.length - 3]; // Third to last letter in alphabet (SE 'X').
  } else if (!a.contains(padChar)) {
    throw Exception("PlayfairParametersError: Padding character not in alphabet: $padChar.");
  } else if (padChar.length != 1) {
    throw Exception("PlayfairParametersError: Padding character is not one character: $padChar.");
  }

  if (padCharPadChar == '') {
    padCharPadChar = input.alphabet.letters[input.alphabet.length - 1]; // Last Letter (SE 'Z').
  } else if (!a.contains(padCharPadChar)) {
    throw Exception("PlayfairParametersError: Padding character *2 not in alphabet: $padCharPadChar.");
  } else if (padCharPadChar.length != 1) {
    throw Exception("PlayfairParametersError: Padding character *2 is not one character: $padCharPadChar.");
  }

  // Build the keyarray and reversed keyarray.
  Map<String, Tuple2<int, int>> keyarray = <String, Tuple2<int, int>>{};
  Set<String> keywordSet = keyword.letters.toSet();
  Set<String> remainingAlpha = a.letters.toSet().difference(keywordSet);
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      if (keywordSet.isNotEmpty){
        keyarray[keywordSet.first] = Tuple2(i, j);
        keywordSet.remove(keywordSet.first);
      } else {
        keyarray[remainingAlpha.first] = Tuple2(i, j);
        remainingAlpha.remove(remainingAlpha.first);
      }
    }
  }
  Map<Tuple2<int, int>, String> keyarrayRev = Map.fromEntries(keyarray.entries.map((e) => MapEntry(e.value, e.key)));
  //print(keyarray);

  // Build the list of letter pairs.
  List<String> inputOnlyValid = input.lettersInAlphabet;
  List<String> inputOnlyValidPairs = [];
  while (inputOnlyValid.isNotEmpty) {
    String nextPair;
    String i1 = inputOnlyValid[0];
    String i2 = inputOnlyValid.length > 1 ? inputOnlyValid[1] : padChar;
    if (i1 == i2 && i1 == padChar) {
      nextPair = "$padChar$padCharPadChar";
      inputOnlyValid.removeAt(0);
    } else if (i1 == i2) {
      nextPair = "$i1$padChar";
      inputOnlyValid.removeAt(0);
    } else {
      nextPair = "$i1$i2";
      inputOnlyValid.removeRange(0, inputOnlyValid.length > 1 ? 2 : 1);
    }
    inputOnlyValidPairs.add(nextPair);
  }
  //print(inputOnlyValidPairs);

  List<String> output = [];
  for (int i = 0; i < inputOnlyValidPairs.length; i++) {
    String pair = inputOnlyValidPairs[i];
    Tuple2<int, int> l1rowcol = keyarray[pair[0]]!;
    Tuple2<int, int> l2rowcol = keyarray[pair[1]]!;

    String cPair = "";
    if (l1rowcol.item1 == l2rowcol.item1) { // Same Row.
      cPair += keyarrayRev[Tuple2(l1rowcol.item1, (l1rowcol.item2 + 1) % 5)]!;
      cPair += keyarrayRev[Tuple2(l2rowcol.item1, (l2rowcol.item2 + 1) % 5)]!;
    } else if (l1rowcol.item2 == l2rowcol.item2) { // Same Col.
      cPair += keyarrayRev[Tuple2((l1rowcol.item1 + 1) % 5, l1rowcol.item2)]!;
      cPair += keyarrayRev[Tuple2((l2rowcol.item1 + 1) % 5, l2rowcol.item2)]!;
    } else {
      cPair += keyarrayRev[Tuple2(l1rowcol.item1, l2rowcol.item2)]!;
      cPair += keyarrayRev[Tuple2(l2rowcol.item1, l1rowcol.item2)]!;
    }
    output.add(cPair);
  }

  return Cryptext.fromString(output.join(" "));
}

void main() {
  Alphabet a = Alphabet.fromString(letters: "ABCDEFGHIKLMNOPQRSTUVWXYZ");
  Cryptext plaintext = Cryptext.fromString("WILLARRIVETODAYXXXXV", alphabet: a);
  Cryptext keyword = Cryptext.fromString("PLAYFAIR", alphabet: a);
  Cryptext ciphertext = playfairEncrypt(plaintext, keyword);
  print(ciphertext);
}