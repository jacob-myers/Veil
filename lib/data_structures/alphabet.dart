import 'package:collection/equality.dart';

// Class containing an alphabet. Default is all uppercase english letters.

class Alphabet {
  List<String> _letters = [];

  // Constructor.
  Alphabet(
      {
        List<String>? letters,
      })
      : _letters = letters ?? ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

  /// Builds the alphabet from the characters provided in the string.
  /// Duplicates are removed.
  factory Alphabet.fromString({required String letters}) {
    return Alphabet(
      letters : letters.split('').toSet().toList()
    );
  }

  /// True if all characters are valid together as an alphabet.
  static bool strIsValidAlphabet(String str) {
    return Alphabet.fromString(letters: str).length == str.length;
  }

  /// Get the list of letters (as strings).
  List<String> get letters {
    return _letters;
  }

  /// Get all characters in the alphabet as one string.
  String get lettersAsString {
    return letters.join();
  }

  /// Numeralizes the given letter based on it's position in the alphabet.
  int numeralizeLetter(String letter) {
    return letters.indexOf(letter);
  }

  /// Returns the corresponding letter from a number based on it's position in the alphabet
  String letterizeNumber(int number) {
    return letters[number];
  }

  /// Get the list of letters (as ints).
  List<int> get lettersAsInts {
    List<int> myLettersAsInts = [];
    for (int i = 0; i < letters.length; i++) {
      myLettersAsInts.add(i);
    }
    return myLettersAsInts;
  }

  /// True if given letter is in the alphabet.
  bool contains(String letter) {
    if (letter.length != 1) {
      throw Exception("Letters may only be one character.");
    }

    if (letters.contains(letter)) {
      return true;
    }
    return false;
  }

  /// How many characters are in the alphabet.
  int get length {
    return letters.length;
  }

  /// The index of the letter in the alphabet.
  int indexOf(String element) {
    return letters.indexOf(element);
  }

  /// Mods the int value to put it in the alphabet's space
  int mod(int c) {
    return c % length;
  }

  /// Returns a deep copy of self.
  Alphabet deepCopy() {
    return Alphabet(letters: letters.toList());
  }

  @override
  String toString() {
    // Uses the get letters getter.
    return lettersAsString;
  }

  @override
  bool operator ==(Object o) {
    if (o is! Alphabet) {
      return false;
    }
    if (!IterableEquality().equals(o.letters, letters)) {
      return false;
    }
    return true;
  }
}

/// Testing function to see if properties of Alphabet worked as intended.
void main () {
  Alphabet defaultAlphabet = Alphabet.fromString(letters : 'ABCD');
  print(defaultAlphabet.lettersAsString);

  // Not equal.
  var a1 = Alphabet.fromString(letters: "ABC");
  var a2 = Alphabet.fromString(letters: "ABCD");
  print(a1 == a2);

  // Not equal.
  a1 = Alphabet.fromString(letters: "ABCD");
  a2 = Alphabet.fromString(letters: "BCDA");
  print(a1 == a2);
}