import 'package:veil/data_structures/cryptext.dart';

/// Encrypts the input with a Viginere cipher. key is the keyword.
Cryptext viginereEncrypt(Cryptext input, Cryptext key) {
  // Creating int lists representing the key, plaintext, and ciphertext.
  List<int> intKey = key.numeralized;
  List<int> intVecInitial = input.numeralized;
  List<int> intVecFinal = <int>[];

  // Iterates through plaintext. Shifting an amount based on the keyword.
  for (int i = 0; i < intVecInitial.length; i++) {
    int keyIndex = i % key.length;
    int nextLetter = input.alphabet.mod(intVecInitial[i] + intKey[keyIndex]);
    intVecFinal.add(nextLetter);
  }

  return Cryptext.fromIntList(intVecFinal);
}

/// Decrypts the input that has been encrypted with a Viginere cipher
/// with key as the keyword.
Cryptext viginereDecrypt(Cryptext input, Cryptext key) {
  List<int> intKey = key.numeralized;
  // Inverts the key to a decryption value. For example, in SEUAS:
  // F > 5 > -5 > 21
  List<int> intKeyInv = intKey.map((x) => input.alphabet.mod(-x)).toList();
  // Builds the inverted keyword.
  Cryptext keyInv = Cryptext.fromIntList(intKeyInv);
  return viginereEncrypt(input, keyInv);
}

/// Test code.
void main() {
  Cryptext plaintext = Cryptext.fromString("MELVIN");
  Cryptext key = Cryptext.fromString("BLUE");
  Cryptext ciphertext = viginereEncrypt(plaintext, key);
  print(ciphertext); //NPFZJY

  Cryptext deciphered = viginereDecrypt(ciphertext, key);
  print(deciphered);
}