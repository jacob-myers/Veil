import 'package:veil/data_structures/cryptext.dart';

Cryptext viginereEncrypt(Cryptext input, Cryptext key) {
  List<int> intKey = key.numeralized;
  List<int> intVecInitial = input.numeralized;
  List<int> intVecFinal = <int>[];

  for (int i = 0; i < intVecInitial.length; i++) {
    int keyIndex = i % key.length;
    int nextLetter = input.alphabet.mod(intVecInitial[i] + intKey[keyIndex]);
    intVecFinal.add(nextLetter);
  }

  return Cryptext.fromIntList(intVecFinal);
}

/// Test code.
void main() {
  Cryptext plaintext = Cryptext.fromString("MELVIN");
  Cryptext key = Cryptext.fromString("BLUE");
  Cryptext ciphertext = viginereEncrypt(plaintext, key);
  print(ciphertext); //NPFZJY
}