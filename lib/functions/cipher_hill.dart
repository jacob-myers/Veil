import 'package:linalg/linalg.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/functions/mod_inv.dart';

//Matrix.map allows you to make a change to every element x, rather than each row or whatever.
//Matrix dimensions are in ROW x COL, ie 3x2 means 3 rows, 2 columns. 3 tall, 2 wide.

Cryptext hillEncrypt(Cryptext plaintext, Matrix key, {String padWith = "X"}) {
  List<Cryptext> pChunks = plaintext.chunks(key.n, padWith).map((chunk) => Cryptext.fromString(chunk)).toList();

  List<Cryptext> cChunks = pChunks.map((chunk) {
    // Turn the chunk into a numeralized vector.
    Vector pChunk = Vector.column(chunk.numeralized.map((e) => e.toDouble()).toList());
    // Multiply the key matrix by the chunk vector
    Vector translatedVector = (key * pChunk).toVector();
    // Mod each number in the translatedVector, and create a Cryptext from that list
    return Cryptext.fromIntList(translatedVector.toList().map((e) => plaintext.alphabet.mod(e.toInt())).toList());
  }).toList();

  return Cryptext.fromString(cChunks.join());
}

Cryptext hillDecrypt(Cryptext ciphertext, Matrix key) {
  Matrix invKey = key.coFactors().transpose() * modInv(key.det().toInt(), ciphertext.alphabet.length);
  return hillEncrypt(ciphertext, invKey);
}

void main () {
  Cryptext c = hillEncrypt(Cryptext.fromString("FEBRUARY"), Matrix([[1, 2, 3], [4, 5, 6], [11, 9, 8]]));
  print(c);

  Cryptext pFromE = hillDecrypt(c, Matrix([[1, 2, 3], [4, 5, 6], [11, 9, 8]]));
  print(pFromE);
}
