import 'package:veil/data_structures/alphabet.dart';

class Cryptext {
  List<String> _letters = [];
  Alphabet alphabet = Alphabet();

  Cryptext (
      {
        List<String> letters = const [],
        Alphabet? alphabet,
      })
      : alphabet = alphabet ?? Alphabet(),
        _letters = letters
  {

    // Removes letters that are not in the alphabet.
    /*
    for (int i = 0; i < _letters.length; i++) {
      if (!alphabet!.letters.contains(_letters[i].toUpperCase())) {
        _letters.remove(_letters[i]);
      }
    }
    */

  }

  /// Builds the cryptext from the characters provided in the string.
  factory Cryptext.fromString(String letters, {Alphabet? alphabet}) {
    Alphabet myAlphabet = alphabet ?? Alphabet();
    return Cryptext(
        letters : letters.split(''),
        alphabet: myAlphabet
    );
  }

  /// Builds the cryptext from the characters corresponding with the numbers provided in the List<int>.
  factory Cryptext.fromIntList(List<int> numbers, {Alphabet? alphabet}) {
    Alphabet myAlphabet = alphabet ?? Alphabet();
    return Cryptext(
        letters: numbers.map((x) => myAlphabet.letterizeNumber(x)).toList(),
        alphabet: alphabet
    );
  }

  /// Assigns each letter with it's index in the alphabet (Only uses letters in alphabet).
  List<int> get numeralized {
    List<int> nums = lettersInAlphabet.map((x) => alphabet.numeralizeLetter(x)).toList();
    return nums;
  }

  /// Get the list of letters as a list.
  List<String> get letters {
    return _letters;
  }

  /*
  List<String> validLetters = [];
    for (int i = 0; i < _letters.length; i++) {
      if (_alphabet.letters.contains(_letters[i].toUpperCase())) {
        validLetters.add(_letters[i]);
      }
    }
    return validLetters;
  */

  /// Get the list of letters as a list.
  List<String> get upper {
    return letters.map((x) => x.toUpperCase()).toList();
  }

  /// Get the list of letters as a list.
  List<String> get lower {
    return letters.map((x) => x.toLowerCase()).toList();
  }

  /// Get the list of letters as one string.
  String get lettersAsString {
    return letters.join();
  }

  /*
  /// Get the list of letters as one string, all uppercase.
  String get lettersAsStringUpper {
    return lettersAsString.toUpperCase();
  }
  */

  /*
  /// Get the list of letters as one string, all lowercase.
  String get lettersAsStringLower {
    return lettersAsString.toLowerCase();
  }
  */

  /// Returns only letters that are in the alphabet.
  List<String> get lettersInAlphabet {
    return letters.where((x) => alphabet.contains(x)).toList();
  }

  /// True if all characters in the text are in the alphabet.
  bool get isExclusiveToAlphabet {
    return letters.length == lettersInAlphabet.length;
  }

  /// How many characters are in the text.
  int get length {
    return letters.length;
  }

  /// Gets invalid letters too.
  @override
  String toString() {
    // Uses the get letters getter.
    return lettersAsString;
  }
}

/// Testing function to see if properties of Cryptext worked as intended.
void testCryptext () {
  Cryptext myText = Cryptext.fromString('Hello');
  print(myText);
  print(myText.numeralized);

  Cryptext emptyText = Cryptext();
  print(emptyText.letters);

  Cryptext fromInts = Cryptext.fromIntList([2, 5, 1]);
  print(fromInts);
}