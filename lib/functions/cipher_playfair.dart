import 'dart:math';

import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:tuple/tuple.dart';

/*
Rules:

Alphabet rules (must be applied OUTSIDE of playfair functions):
  Must have 25 characters
  Check if standard english, upper or lower. if so, remove, i, replace with j

If there are repeated letters, ie "LETTERS", insert a padding character between them; 'TTE' becomes 'TX' and 'TE'
  'TTTTTB' -> 'TX' 'TX' 'TX' 'TX' 'TB'

  In SE, padding character is 'X', padding character^2 is 'Z'
  'XXV' -> 'XZ' 'XV'

Inputs:   Padding character. Default third to last letter.
          Padding character padding character. Default last letter.
*/

/// Builds the key array from the keyword and the alphabet.
/// Checks validity of alphabet.
Map<String, Tuple2<int, int>> buildKeyarray(Alphabet a, Cryptext keyword) {
  // Checks if alphabet is valid.
  if (a != keyword.alphabet) {
    throw Exception("PlayfairParametersError: input and keyword have different alphabets.");
  }
  if (a.length != 25) {
    throw Exception("PlayfairParametersError: Alphabet must be 25 characters long.");
  }

  Map<String, Tuple2<int, int>> keyarray = <String, Tuple2<int, int>>{};

  Set<String> keywordSet = keyword.letters.toSet();
  // Remove keyword letters from alphabet set.
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
  return keyarray;
}

/// Reverses the given keyarray. Pulled up for simplicity.
Map<Tuple2<int, int>, String> buildKeyArrayRev(Map<String, Tuple2<int, int>> keyarray) {
  return Map.fromEntries(keyarray.entries.map((e) => MapEntry(e.value, e.key)));
}

/// Formats the plaintext as letter pairs, using the padding characters where needed.
/// Checks validity of adding characters.
List<String> buildPlaintextPairs(Cryptext plaintext, String padChar, String padCharPadChar) {
  // Checking validity of padding characters.
  if (!plaintext.alphabet.contains(padChar)) {
    throw Exception("PlayfairParametersError: Padding character not in alphabet: $padChar.");
  } else if (padChar.length != 1) {
    throw Exception("PlayfairParametersError: Padding character is not one character: $padChar.");
  }

  if (!plaintext.alphabet.contains(padCharPadChar)) {
    throw Exception("PlayfairParametersError: Padding character *2 not in alphabet: $padCharPadChar.");
  } else if (padCharPadChar.length != 1) {
    throw Exception("PlayfairParametersError: Padding character *2 is not one character: $padCharPadChar.");
  }

  if (!plaintext.isExclusiveToAlphabet) {
    throw Exception("PlayfairParametersError: Input includes characters that are not in the provided alphabet.");
  }

  List<String> letters = plaintext.letters.toList();
  List<String> pairs = [];

  while (letters.isNotEmpty) {
    // If only one character is left.
    if (letters.length == 1) {
      pairs.add(letters[0] + padChar);
      break;
    }

    // Checks next two characters to see how to format the next pair.
    // Repeat characters that are also padding characters; 'XX'.
    if (letters[0] == letters[1] && letters[0] == padChar) {
      pairs.add(padChar + padCharPadChar);
      letters.removeAt(0);
    // Repeat characters; 'EE'.
    } else if (letters[0] == letters[1]) {
      pairs.add(letters[0] + padChar);
      letters.removeAt(0);
    // Non-repeated characters.
    } else {
      pairs.add(letters[0] + letters[1]);
      letters.removeRange(0, 2);
    }
  }
  return pairs;
}

String cryptPair(Map<String, Tuple2<int, int>> keyarray, Map<Tuple2<int, int>, String> keyarrayRev,
    Tuple2<int, int> l1rowcol, Tuple2<int, int> l2rowcol, {bool encrypt = true}) {

  // If encrypting shift right, if decrypting, shift left.
  int sameRowShift = encrypt ? 1 : -1;
  // If encrypting, shift down, if decrypting, shift up.
  int sameColShift = encrypt ? 1 : -1;

  // Same row; Take letters immediately left of each.
  if (l1rowcol.item1 == l2rowcol.item1) {
    return keyarrayRev[Tuple2(l1rowcol.item1, (l1rowcol.item2 + sameRowShift) % 5)]! +
        keyarrayRev[Tuple2(l2rowcol.item1, (l2rowcol.item2 + sameRowShift) % 5)]!;
    // Same col; Take letters immediately below each.
  } else if (l1rowcol.item2 == l2rowcol.item2) {
    return keyarrayRev[Tuple2((l1rowcol.item1 + sameColShift) % 5, l1rowcol.item2)]! +
        keyarrayRev[Tuple2((l2rowcol.item1 + sameColShift) % 5, l2rowcol.item2)]!;
    // Use rectangle method in array to use the row of each item and col of the other item.
  } else {
    return keyarrayRev[Tuple2(l1rowcol.item1, l2rowcol.item2)]! +
        keyarrayRev[Tuple2(l2rowcol.item1, l1rowcol.item2)]!;
  }
}

/// Encrypts an input with the Playfair cipher using a given keyword.
/// The alphabet is derived from the input and must be the same as the keyword's.
///
/// padChar is the character used for padding the plaintext pairs in the
/// case of repeat letters. padCharPadChar is used for repeats of the padChar
/// letter (pairs cannot be the same letter).
Cryptext playfairEncrypt(Cryptext plaintext, Cryptext keyword, [String padChar = '', String padCharPadChar = '']) {
  /*
  padChar is 'X' in the traditional Playfair algorithm. This uses the 3rd to last
  letter in the alphabet. Which in default english is X. padCharPadChar is set to
  the final letter in the alphabet.
  */

  Alphabet a = plaintext.alphabet;

  // Third to last letter in alphabet (SE 'X').
  if (padChar == '') { padChar = a.letters[a.length - 3]; }
  // Last Letter (SE 'Z').
  if (padCharPadChar == '') { padCharPadChar = a.letters[a.length - 1]; }

  // Build the keyarray and reversed keyarray.
  Map<String, Tuple2<int, int>> keyarray = buildKeyarray(a, keyword);
  Map<Tuple2<int, int>, String> keyarrayRev = buildKeyArrayRev(keyarray);

  // Build the list of letter pairs.
  List<String> plaintextPairs = buildPlaintextPairs(plaintext, padChar, padCharPadChar);

  // Encrypt the plaintext pairs using the keyarray.
  List<String> output = [];
  for (int i = 0; i < plaintextPairs.length; i++) {
    String pair = plaintextPairs[i];
    Tuple2<int, int> l1rowcol = keyarray[pair[0]]!;
    Tuple2<int, int> l2rowcol = keyarray[pair[1]]!;

    output.add(cryptPair(keyarray, keyarrayRev, l1rowcol, l2rowcol, encrypt: true));
  }
  return Cryptext.fromString(output.join(""), alphabet: plaintext.alphabet);
}

/// Decrypts a ciphertext that has been encrypted with the Playfair cipher,
/// using a a given keyword. Does not remove padding characters.
Cryptext playfairDecrypt(Cryptext ciphertext, Cryptext keyword) {

  if (!ciphertext.isExclusiveToAlphabet) {
    throw Exception("PlayfairParametersError: Input includes characters that are not in the provided alphabet.");
  }

  // Keyarray and reverse maps.
  Map<String, Tuple2<int, int>> keyarray = buildKeyarray(ciphertext.alphabet, keyword);
  Map<Tuple2<int, int>, String> keyarrayRev = Map.fromEntries(
      keyarray.entries.map((e) => MapEntry(e.value, e.key)));

  // Decrypts them two at a time using cryptPair.
  List<String> output = [];
  for (int i = 0; i < ciphertext.letters.length; i += 2) {
    Tuple2<int, int> l1rowcol = keyarray[ciphertext.letters[i]]!;
    Tuple2<int, int> l2rowcol = keyarray[ciphertext.letters[i + 1]]!;
    output.add(cryptPair(keyarray, keyarrayRev, l1rowcol, l2rowcol, encrypt: false));
  }
  return Cryptext.fromString(output.join(""), alphabet: ciphertext.alphabet);
}

/// Builds a visual of the keyarray matrix, returns as a String.
String buildPlayfairMatrixVisual(Cryptext keyword) {
  var revKeyArray = buildKeyArrayRev(buildKeyarray(keyword.alphabet, keyword));
  int sideLen = sqrt(revKeyArray.keys.length).floor(); // Will always be whole because square matrix.

  String matrix = "";
  for (int i = 0; i < sideLen; i++) {
    for (int j = 0; j < sideLen; j++) {
      matrix += "${revKeyArray[Tuple2(i, j)]!} ";
    }
    matrix += "\n";
  }

  return matrix;
}



void main() {
  Alphabet a = Alphabet.fromString(letters: "ABCDEFGHIKLMNOPQRSTUVWXYZ");
  Cryptext plaintext = Cryptext.fromString("WILLARRIVETODAY", alphabet: a);
  Cryptext keyword = Cryptext.fromString("PLAYFAIR", alphabet: a);
  Cryptext ciphertext = playfairEncrypt(plaintext, keyword);
  print(ciphertext);

  Cryptext plaintextFromCiphertext = playfairDecrypt(ciphertext, keyword);
  print(plaintextFromCiphertext);

  print(buildPlayfairMatrixVisual(keyword));
}