import 'package:tuple/tuple.dart';
import 'package:veil/functions/euclid_alg_ext.dart';

/// Finds the inverse of the number within the alphabet space. Used for
/// balancing equations. num must be relatively prime with n.
///
/// Ex/ 5 * c = p - 2 (mod 26).
/// Finding modInv(5) can be multiplied on each side to isolate c.
int modInv(int num, int n) {
  Tuple3 ret = euclidAlgExt(n, num);

  if (ret.item1 != 1) {
    throw Exception("NotRelativelyPrime");
  }

  return euclidAlgExt(n, num).item3;
}

void main() {
  print(modInv(3, 26));
}