import 'package:veil/data_structures/cryptext.dart';

Map<String, int> frequency(Cryptext cryptext) {
  // Initialize as all 0.
  Map<String, int> count = Map.fromIterables(
      cryptext.alphabet.letters,
      List.generate(cryptext.alphabet.letters.length, (index) => 0));

  for (String char in cryptext.lettersInAlphabet) {
    count.update(char, (value) => value += 1);
  }
  return count;
}

void main() {
  Cryptext text = Cryptext.fromString("THISISTEXT");
  print(frequency(text));
}