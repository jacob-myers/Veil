import 'package:tuple/tuple.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/functions/euclidean_alg.dart';
import 'package:veil/functions/mod_inv.dart';

/// The a in an affine cipher must be relatively prime with the length of the
/// alphabet. Returns true if valid, false otherwise.
bool isValidAffineParams(Cryptext input, int a) {
  int n = input.alphabet.length;
  return euclidAlg(a, n) == 1;
}

bool isValidAffineParamsWithMod(int a, int n) {
  return euclidAlg(a, n) == 1;
}

/// Encrypt input with an affine cipher with k = a, b. Where C(p) = ap + b
Cryptext affineEncrypt(Cryptext input, int a, int b) {
  if (!isValidAffineParams(input, a)) {
    throw Exception("AffineParametersError: $a in ${input.alphabet.length}");
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

  return Cryptext.fromIntList(intVecFinal, alphabet: input.alphabet);
}

/// Finds a and b from a known plaintext and ciphertext.
/// Throws an error if there are no valid pairs.
Tuple2<int, int> findAB(Cryptext p, Cryptext c) {
  for (int i = 0; i < p.length; i++) {
    for (int j = i; j < p.length; j++) {
      int p1 = p.numeralized[i];
      int p2 = p.numeralized[j];
      int c1 = c.numeralized[i];
      int c2 = c.numeralized[j];
      if (euclidAlg(p1 - p2, p.alphabet.length) == 1) {
        int a = p.alphabet.mod(modInv(p1 - p2, p.alphabet.length) * (c1 - c2));
        int b = p.alphabet.mod((c1 - (p1 * a)));
        return Tuple2(a, b);
      }
    }
  }
  throw Exception('NoValidPair');
}

void main () {
  Cryptext p = Cryptext.fromString('MY TEXT');
  Cryptext c = affineEncrypt(p, 5, 14);
  Cryptext p_decrypted = affineDecrypt(c, 5, 14);

  print(p);
  print(c);
  print(p_decrypted);

  print(affineEncrypt(Cryptext.fromString('UNCHANGED'), 1, 0));
}