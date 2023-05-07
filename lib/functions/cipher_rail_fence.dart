import 'package:veil/data_structures/cryptext.dart';

/// Performs a rail fence encryption on given input with numRails number of
/// rails, and an offset of offset.
Cryptext railFenceEncrypt(Cryptext input, int numRails, int offset) {
  List<String> rails = List.generate(numRails, (index) => "");
  var inputOnlyValid = input.lettersInAlphabet;

  int line = getStartingRail(numRails, offset);
  for (int i = 0; i < inputOnlyValid.length; i++) {
    rails[line] += inputOnlyValid[i];
    if (((i+offset)/(numRails - 1)).floor() % 2 == 1) {
      line--;
    } else {
      line++;
    }
  }

  return Cryptext.fromString(rails.join());
}

/// Performs a rail fence decryption on a given input with numRails number of
/// rails, and an offset of offset.
/// Unlike the encryption method, this is done by constructing a rail fence
/// matrix.
Cryptext railFenceDecrypt(Cryptext input, int numRails, int offset) {
  var inputOnlyValid = input.lettersInAlphabet;
  var matrix = buildEmptyRailMatrix(inputOnlyValid.length, numRails, offset);
  int indexAt = 0;
  for (int i = 0; i < numRails; i++) {
    for (int j = 0; j < inputOnlyValid.length; j++) {
      if (matrix[i][j] == '-') {
        matrix[i][j] = inputOnlyValid[indexAt];
        indexAt++;
      }
    }
  }

  String plaintext = "";
  int line = getStartingRail(numRails, offset);
  for (int i = 0; i < inputOnlyValid.length; i++) {
    plaintext += matrix[line][i];
    if (((i+offset)/(numRails - 1)).floor() % 2 == 1) {
      line--;
    } else {
      line++;
    }
  }

  return Cryptext.fromString(plaintext);
}

/// Builds an empty rail matrix for the given key. Empty spaces are denoted by
/// " " and spaces for characters are denoted by "-".
List<List<String>> buildEmptyRailMatrix(int msgLength, int numRails, int offset) {
  List<List<String>> matrix = List.generate(numRails, (i) => List.generate(msgLength, (j) => " "), growable: false);

  int line = getStartingRail(numRails, offset);
  for (int i = 0; i < msgLength; i++) {
    matrix[line][i] = "-";
    if (((i+offset)/(numRails - 1)).floor() % 2 == 1) {
      line--;
    } else {
      line++;
    }
  }

  return matrix;
}

/// Finds the rail to start placing letters on with the given number of rails
/// and offset.
int getStartingRail(int numRails, int offset) {
  List<int> rail = List.generate(numRails * 2 - 2, (index) => index < numRails ? index : (numRails * 2 - 2) - index);
  return rail[offset % (numRails * 2 - 2)];
}

void main() {
  var p = Cryptext.fromString("MY TEXT LONGER");
  var c = railFenceEncrypt(p, 5, 65);
  var p_decrypted = railFenceDecrypt(c, 5, 65);
  
  print(c);
  print(p_decrypted);
}