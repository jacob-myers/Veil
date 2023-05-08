import 'package:veil/data_structures/cryptext.dart';

/// Performs a rail fence encryption on given input with numRails number of
/// rails, and an offset of offset.
Cryptext railFenceEncrypt(Cryptext input, int numRails, int offset) {
  var inputOnlyValid = input.lettersInAlphabet;

  if (numRails == 1 || numRails == 0) {
    return Cryptext.fromString(inputOnlyValid.join(), alphabet: input.alphabet);
  }

  List<String> rails = List.generate(numRails, (index) => "");

  int line = getStartingRail(numRails, offset);
  for (int i = 0; i < inputOnlyValid.length; i++) {
    rails[line] += inputOnlyValid[i];
    if (((i+offset)/(numRails - 1)).floor() % 2 == 1) {
      line--;
    } else {
      line++;
    }
  }

  return Cryptext.fromString(rails.join(), alphabet: input.alphabet);
}

/// Performs a rail fence decryption on a given input with numRails number of
/// rails, and an offset of offset.
/// Unlike the encryption method, this is done by constructing a rail fence
/// matrix.
Cryptext railFenceDecrypt(Cryptext input, int numRails, int offset) {
  var inputOnlyValid = input.lettersInAlphabet;

  if (numRails == 1 || numRails == 0) {
    return Cryptext.fromString(inputOnlyValid.join(), alphabet: input.alphabet);
  }

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

  return Cryptext.fromString(plaintext, alphabet: input.alphabet);
}

/// Builds an empty rail matrix for the given key. Empty spaces are denoted by
/// " " and spaces for characters are denoted by "-".
List<List<String>> buildEmptyRailMatrix(int msgLength, int numRails, int offset) {
  if(numRails == 1 || numRails == 0) {
    return [List.generate(msgLength, (index) => '-')];
  }

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

String buildRailMatrixVisual(Cryptext input, int numRails, int offset) {
  var inputOnlyValid = input.lettersInAlphabet;

  if(numRails == 1) {
    return inputOnlyValid.join();
  }

  var matrix = buildEmptyRailMatrix(inputOnlyValid.length, numRails, offset);
  int indexAt = 0;
  List<String> result = List.generate(numRails, (index) => "");

  for (int i = 0; i < inputOnlyValid.length; i++) {
    for (int j = 0; j < numRails && j < inputOnlyValid.length; j++) {
      if (matrix[j][i] == '-') {
        result[j] += inputOnlyValid[indexAt];
        indexAt++;
      } else {
        result[j] += " ";
      }
    }
  }
  // Newlines on all rows.
  for(int i = 0 ; i < result.length; i++) {
    result[i] += '\n';
  }
  return result.join();
}

/// Finds the rail to start placing letters on with the given number of rails
/// and offset.
int getStartingRail(int numRails, int offset) {
  if (numRails <= 1) {
    return 0;
  }

  List<int> rail = List.generate(getOffsetSpace(numRails), (index) => index < numRails ? index : getOffsetSpace(numRails) - index);
  return rail[offset % getOffsetSpace(numRails)];
}

/// Finds the modulus that will be applied to the offset.
int getOffsetSpace(int numRails) {
  return numRails * 2 - 2;
}

void main() {
  var p = Cryptext.fromString("MY TEXT LONGER");
  var c = railFenceEncrypt(p, 5, 65);
  var p_decrypted = railFenceDecrypt(c, 5, 65);

  print(buildRailMatrixVisual(p, 5, 65));
  
  print(c);
  print(p_decrypted);
}