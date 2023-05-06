import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/functions/euclidean_alg.dart';
import 'package:veil/functions/mod_inv.dart';

/// The a in an affine cipher must be relatively prime with the length of the
/// alphabet. Returns true if valid, false otherwise.
bool isValidAffineParams(Cryptext input, int a) {
  int n = input.alphabet.length;
  return euclidAlg(a, n) == 1;
}

/// Encrypt input with an affine cipher with k = a, b. Where C(p) = ap + b
Cryptext affineEncrypt(Cryptext input, int a, int b) {
  if (!isValidAffineParams(input, a)) {
    throw Exception("AffineParametersError");
  }

  List<int> intVecFinal = input.numeralized.map((x) {
    return (x * a + b) % input.alphabet.length;
  }).toList();

  return Cryptext.fromIntList(intVecFinal, alphabet: input.alphabet);
}

/// Decrypt input with an affine cipher with k = a, b. Where C(p) = ap + b
/// Meaning, input was encrypted with that cipher.
Cryptext affineDecrypt(Cryptext input, int a, int b) {
  if (!isValidAffineParams(input, a)) {
    throw Exception("AffineParametersError");
  }

  int a_inv = modInv(a, input.alphabet.length);

  List<int> intVecFinal = input.numeralized.map((x) {
    return ((x - b) * a_inv) % input.alphabet.length;
  }).toList();

  return Cryptext.fromIntList(intVecFinal);
}

void main () {
  Cryptext p = Cryptext.fromString('MY TEXT');
  Cryptext c = affineEncrypt(p, 5, 14);
  Cryptext p_decrypted = affineDecrypt(c, 5, 14);

  print(p);
  print(c);
  print(p_decrypted);
}