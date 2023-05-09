import 'package:veil/data_structures/cryptext.dart';

/// Performs a shift of shift on the given cryptext.
Cryptext cryptShift(Cryptext cryptext, int shift) {
  List<int> intVecInitial = cryptext.numeralized;
  List<int> intVecFinal = intVecInitial.map((x) => (x + shift) % cryptext.alphabet.length).toList();
  return Cryptext.fromIntList(intVecFinal, alphabet : cryptext.alphabet);
}

/// Testing function to see if the shift cipher worked.
void testCryptShift() {
  Cryptext plaintext = Cryptext.fromString('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  print(cryptShift(plaintext, 1));
}