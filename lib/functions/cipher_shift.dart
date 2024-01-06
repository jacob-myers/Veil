import 'package:veil/data_structures/cryptext.dart';

/// Performs a shift of shift on the given cryptext.
Cryptext cryptShift(Cryptext cryptext, int shift) {
  List<int> intVecInitial = cryptext.numeralized;
  List<int> intVecFinal = intVecInitial.map((x) => (x + shift) % cryptext.alphabet.length).toList();
  return Cryptext.fromIntList(intVecFinal, alphabet : cryptext.alphabet);
}

/// Given two pieces of Cryptext, determines if there is a shift that can turn
/// p into c by applying the shift cipher.
bool isValidShiftPair(Cryptext p, Cryptext c) {
  if (p.length == 0 || c.length == 0) {
    return false;
  }
  if (p.length != c.length) {
    return false;
  }
  if (!p.isExclusiveToAlphabet || !c.isExclusiveToAlphabet) {
    return false;
  }

  int shift = p.alphabet.mod(c.numeralized[0] - p.numeralized[0]);
  for (int i = 0; i < p.length; i++) {
    if (p.alphabet.mod(c.numeralized[i] - p.numeralized[i]) != shift) {
      return false;
    }
  }
  return true;
}

/// Testing function to see if the shift cipher worked.
void main() {
  Cryptext plaintext = Cryptext.fromString('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  print(cryptShift(plaintext, 1));
}