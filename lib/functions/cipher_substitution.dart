import 'package:tuple/tuple.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/alphabet.dart';

/// Encrypts the input with a substitution cipher. cycleK is the key to do
/// this encryption, where cycleK is a permutation in cycle notation.
Cryptext substitutionEncrypt(Cryptext input, List<String> cycleK) {
  if (!permutationIsWholeAlphabet(cycleK, input.alphabet)) {
    throw Exception("GivenPermutationIsNotValidForAlphabet");
  }

  var tabPerm = tabularNotationFromCycle(cycleK);
  List<String> tabInput = tabPerm.item1;
  List<String> tabOutput = tabPerm.item2;

  List<String> inputOnlyValid = input.lettersInAlphabet;
  List<String> output = [];
  for (int i = 0; i < inputOnlyValid.length; i++) {
    output.add(tabOutput[tabInput.indexOf(inputOnlyValid[i])]);
  }

  return Cryptext(letters: output);
}

Cryptext substitutionDecrypt(Cryptext input, List<String> cycleK) {
  if (!permutationIsWholeAlphabet(cycleK, input.alphabet)) {
    throw Exception("GivenPermutationIsNotValidForAlphabet");
  }

  return substitutionEncrypt(input, cycleNotationInverse(cycleK));
}

/// Converts the tabular notation of a permutation into cycle notation. Takes
/// two lists of characters, the input and output of the permutation.
List<String> cycleNotationFromTabular(List<String> input, List<String> output) {
  if (input.toSet().length != input.length || output.toSet().length != output.length) {
    throw Exception("PermutationHasRepeatingCharacters");
  }
  if (input.toSet().length != output.toSet().length) {
    throw Exception("PermutationsHaveMismatchedLengths");
  }
  for (String char in input) {
    if (!output.contains(char)) {
      throw Exception("PermutationsHaveDifferingCharacters");
    }
  }

  List<String> usedChars = [];
  List<String> cycles = [];
  for (int i = 0; i < input.length; i++) {
    String nextChar = input[i];
    while (!usedChars.contains(nextChar)) {
      usedChars.add(nextChar);
      // First element of a cycle? Has to add a new string to cycles. Otherwise append.
      nextChar == input[i] ? cycles.add(nextChar) : cycles.last += nextChar;
      nextChar = output[input.indexOf(nextChar)];
    }
  }
  return cycles;
}

/// Finds the inverse of a given permutation in cycle notation.
List<String> cycleNotationInverse(List<String> cycles) {
  return cycles.where((cycle) => cycle.length > 1).map((cycle) {
    return cycle[0] + cycle.substring(1, cycle.length).split("").reversed.join();
  }).toList();
}

/// Converts a permutation in cycle notation to the tabular notation. Takes the
/// cycle notation. Returns the input and output for long notation.
Tuple2<List<String>, List<String>> tabularNotationFromCycle(List<String> cycles) {
  List<String> input = [];
  List<String> output = [];
  for (String cycle in cycles) {
    for (int i = 0; i < cycle.length; i++) {
      input.add(cycle[i]);
      output.add(cycle[cycle.length > 1 ? (i + 1) % (cycle.length) : i]);
    }
  }
  return Tuple2(input, output);
}

/// If permutation is exclusive to the alphabet and contains all letters.
bool permutationIsWholeAlphabet(List<String> cyclePerm, Alphabet alphabet) {
  if (alphabet.length != cyclePerm.join().length) {
    return false;
  }
  for (String char in cyclePerm.join().split('')) {
    if (!alphabet.letters.contains(char)) {
      return false;
    }
  }
  return true;
}

void main() {
  print(cycleNotationFromTabular("ABCD".split(''), "ADBC".split('')));
  print(cycleNotationFromTabular("ABCD".split(''), "ABCD".split('')));

  print(tabularNotationFromCycle(['A', 'BDC']));
  
  List<String> key = ['AHB', 'CNLWP', 'DMRUXVGZQIEO', 'FTYJSK'];
  print(key);
  print(cycleNotationInverse(key));

  Cryptext p = Cryptext.fromString('IHOPPEDOFFTHEPLANEATLAX');
  Cryptext c = substitutionEncrypt(p, key);
  Cryptext p_decrypted = substitutionDecrypt(c, key);

  print(c);
  print(p_decrypted);
}