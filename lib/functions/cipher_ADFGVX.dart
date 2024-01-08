import 'package:veil/data_structures/alphabet.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/functions/string_manip.dart';

/// Encrypt using standard ADFGVX.
Cryptext adfgvxEncrypt(Cryptext plaintext, List<List<String>> keyarray, Cryptext keyword) {
  return adfgvxnEncrypt(plaintext, keyarray, keyword, Cryptext.fromString('ADFGVX'));
}

/// Decrypt using standard ADFGVX.
Cryptext adfgvxDecrypt(Cryptext ciphertext, List<List<String>> keyarray, Cryptext keyword) {
  return adfgvxnDecrypt(ciphertext, keyarray, keyword, Cryptext.fromString('ADFGVX'));
}

/// Build a map mapping the letters in the keyarray to their ciphertext pair.
Map<String, String> buildConversionMap(List<List<String>> keyarray, Cryptext ciphertextChars) {
  Map<String, String> conversionArray = {};
  for (int i = 0; i < ciphertextChars.length; i++) {
    for (int j = 0; j < ciphertextChars.length; j++) {
      conversionArray[keyarray[i][j]] = ciphertextChars.letters[i] + ciphertextChars.letters[j];
    }
  }
  return conversionArray;
}

/// Sorts the keyword alphabetically.
/// Deep copy preserves original keyword if necessary.
Cryptext alphabeticalKeyword(Cryptext keyword, Alphabet alphabet) {
  var sortedKeyword = keyword.deepCopy();
  sortedKeyword.letters.sort((a, b) {
    return alphabet.indexOf(a).compareTo(alphabet.indexOf(b));
  });
  return sortedKeyword;
}

/// Encrypt using the ADFGVX algorithm with a variable keyarray size and corresponding
/// ciphertext characters. For instance this function works with ADFGVX and ADFGX.
Cryptext adfgvxnEncrypt(Cryptext plaintext, List<List<String>> keyarray, Cryptext keyword, Cryptext ciphertextChars) {

  // Check if array is square and the correct size for the provided ciphertextChars.
  if (keyarray.where((element) => element.length != ciphertextChars.length).isNotEmpty || keyarray.length != ciphertextChars.length) {
    throw Exception("ADFGVXParametersError: keyarray is not a square array lined up with ciphertextChars.");
  }

  // Check if the provided array contains only letters of the alphabet and no repeats.
  Cryptext keyarrayAsCryptext = Cryptext(letters: keyarray.expand((element) => element).toSet().toList(), alphabet: plaintext.alphabet);
  if (!keyarrayAsCryptext.isExclusiveToAlphabet) {
    throw Exception("ADFGVXParametersError: keyarray is not exclusive to plaintext alphabet.");
  } else if (keyarrayAsCryptext.length != keyarrayAsCryptext.alphabet.length) {
    throw Exception("ADFGVXParametersError: Unique characters in plaintext alphabet and key array do not match.");
  }

  // Creates a conversion map and uses it to map the plaintext into the ADFGVX pairs.
  Map<String, String> conversionMap = buildConversionMap(keyarray, ciphertextChars);
  Cryptext convertedPlaintext = Cryptext.fromString(plaintext.letters.map((e) => conversionMap[e] ?? '').join());

  // Formats the ADFGVX text into columns, aligned with the keyword.
  Map<String, List<String>> arrayedPlaintext = {};
  for (var e in keyword.letters) { arrayedPlaintext[e] = []; }

  for (int i = 0; i < convertedPlaintext.length; i++) {
    arrayedPlaintext[keyword.letters[i % keyword.length]]!.add(convertedPlaintext.letters[i]);
  }

  // Selects the columns in alphabetical order and concatenates them.
  var sortedKeyword = alphabeticalKeyword(keyword, plaintext.alphabet);
  String transposedCiphertext = '';
  for (var e in sortedKeyword.letters) { transposedCiphertext += arrayedPlaintext[e]!.join(); }

  return Cryptext.fromString(transposedCiphertext, alphabet: plaintext.alphabet);
}

/// Decrypt using the ADFGVX algorithm with a variable keyarray size and corresponding
/// ciphertext characters. For instance this function works with ADFGVX and ADFGX.
Cryptext adfgvxnDecrypt(Cryptext ciphertext, List<List<String>> keyarray, Cryptext keyword, Cryptext ciphertextChars) {
  int columnHeight = (ciphertext.length / keyword.length).floor();
  int numLongColumns = ciphertext.length % keyword.length;

  // Sorts the keyword alphabetically. Deep copy preserves original keyword if necessary.
  var sortedKeyword = alphabeticalKeyword(keyword, ciphertext.alphabet);

  // Sorts the ciphertext back into it's keyword columns.
  Map<String, List<String>> arrayedCiphertext = {};
  for (var e in keyword.letters) { arrayedCiphertext[e] = []; }

  var ciphertextLetters = ciphertext.letters.toList();
  for (int i = 0; i < sortedKeyword.length; i++) {
    // Initializes the list in the map.
    arrayedCiphertext[sortedKeyword.letters[i]] = [];
    // Decides whether it should be a long or short column and loops through the
    // corresponding number of letters.
    for (int j = 0; j < ((keyword.letters.indexOf(sortedKeyword.letters[i]) < numLongColumns) ? columnHeight + 1 : columnHeight); j++) {
      arrayedCiphertext[sortedKeyword.letters[i]]!.add(ciphertextLetters.first);
      ciphertextLetters.removeAt(0);
    }
  }

  // Appends all the values in the map together. They are already in keyword
  // order because they were initialized that way.
  String convertedPlaintext = '';
  for (int i = 0; i < ciphertext.length; i++) {
    convertedPlaintext += arrayedCiphertext.values.toList()[i % keyword.length][(i/keyword.length).floor()];
  }

  // Build a reversed conversion map for converting ADFGVX pairs into plaintext.
  Map<String, String> revConversionMap = Map.fromEntries(buildConversionMap(keyarray, ciphertextChars).entries.map((e) => MapEntry(e.value, e.key)));

  return Cryptext.fromString(
    // Maps each pair to a plaintext letter.
    convertedPlaintext.chunks(2).map((e) => revConversionMap[e]!).join(),
    alphabet: ciphertext.alphabet
  );
}

void main() {
  Cryptext plaintext = Cryptext.fromString("ALLQUIET", alphabet: Alphabet.fromString(letters: "ABCDEFGHIKLMNOPQRSTUVWXYZ"));
  List<List<String>> keyarray = [ ['P', 'G', 'C', 'E', 'N'], ['B', 'Q', 'O', 'Z', 'R'], ['S', 'L', 'A', 'F', 'T'], ['M', 'D', 'V', 'I', 'W'], ['K', 'U', 'Y', 'X', 'H']];
  Cryptext ciphertextChars = Cryptext.fromString("ADFGX");
  Cryptext keyword = Cryptext.fromString("GERMAN");
  print(plaintext);
  Cryptext ciphertext = adfgvxnEncrypt(plaintext, keyarray, keyword, ciphertextChars);
  print(ciphertext);

  Cryptext plaintextFromCiphertext = adfgvxnDecrypt(ciphertext, keyarray, keyword, ciphertextChars);
  print(plaintextFromCiphertext);
}