import 'package:tuple/tuple.dart';
import 'package:veil/data_structures/cryptext.dart';
import 'package:veil/data_structures/alphabet.dart';

String hardcodedCiphertext = 'EBDCCOMDTTYBOCWHLOHYWHVPEYBHMUOHRHLMRJNHUMEZHLPOWNDROYDYBOWHLMDTTHROOVNOKKHREZDLLHTEYELSXRCOMELYBONHABOUOEHRTDUYBOTEUKYYEROWDDFYDRJUEZBYHLMEKOOYBOBDWWJPDDMKEZLYBEKEKHWWKDNUHQJOGOUJADMJKOORKKDTHRDXKRJYXRRJKYXULELHLMERTOOWELFELMHBDROKENFYDDRXNBCUOKKXUOHLMERLOUGDXKYBHYKPBOLYBOYHVERHLYXULOMDLYBOUHMEDHLMHSHJQKDLZPHKDLHLMHSHJQKDLZPHKDLHLMHSHJQKDLZPHKDLKDECXYRJBHLMKXCYBOJUOCWHJELZRJKDLZYBOAXYYOUTWEOKTWJHPHJERLDMMELRJBOHMWEFOJOHBRDGELRJBECKWEFOJOHBEZDYRJBHLMKXCYBOJUOCWHJELRJKDLZEFLDPERZDLLHAODFJOHBEYKHCHUYJELYBOXKHENHLHWRDKYKOOEYYBHYMUOHRERMUOHRELZAXYYBOUOKHGDENOELKEMORJBOHMKHJELJDXWWLOGOUUOHNBEYOGOUJKYOCERYHFELOGOUJRDGOERHFOTOOWKWDKYPEYBLDMEUONYEDLRJTHEYBEKKBHFELAXYEEZDYYHFOOCYUJELZDYYHFOOCRJBOHMBOWMBEZBYBOUOKHWPHJKZDLLHAOHLDYBOURDXLYHELERHWPHJKZDLLHPHLLHRHFOEYRDGOHWPHJKZDLLHAOHLXCBEWWAHYYWOKDROYEROKERZDLLHBHGOYDWDKOHELYHADXYBDPTHKYEZOYYBOUOHELYHADXYPBHYKPHEYELDLYBODYBOUKEMOEYKYBONWERAYBOKYUXZZWOKERTHNELZYBONBHLNOKERYHFELZKDROYEROKREZBYFLDNFROMDPLAXYLDERLDYAUOHFELZERHJLDYFLDPEYAXYYBOKOHUOYBORDROLYKYBHYERZDLLHUORORAOURDKYJOHBSXKYZDYYHFOOCZDELHLMEEZDYYHAOKYUDLZSXKYFOOCCXKBELZDLPONWHPOMPONBHELOMDXUBOHUYKELGHELPOSXRCOMLOGOUHKFELZPBJPOFEKKOMETOWWXLMOUJDXUKCOWWHWDGOLDDLONDXWMMOLJMDLYJDXOGOUKHJESXKYPHWFOMHPHJEPEWWHWPHJKPHLYJDXENHLYWEGOHWEOUXLLELZTDURJWETOEPEWWHWPHJKPHLYJDXENHROELWEFOHPUONFELZAHWWELOGOUBEYKDBHUMELWDGOHWWEPHLYOMPHKYDAUOHFJDXUPHWWKHWWJDXOGOUMEMPHKPUONFROJOHBJDXJDXPUONFROECXYJDXBEZBXCELYBOKFJHLMLDPJDXUOLDYNDRELZMDPLEYKWDPWJYXULOMJDXWOYROAXULHLMLDPPOUOHKBOKDLYBOZUDXLMPOPOUOZDDMPOPOUOZDWMFELMHMUOHRYBHYNHLYAOKDWMPOPOUOUEZBYYEWWPOPOUOLYAXEWYHBDROHLMPHYNBOMEYAXULEMEMLYPHLLHWOHGOJDXEMEMLYPHLLHWEOKYHUYOMYDNUJAXYYBOLUORORAOUOMENHLAXJRJKOWTTWDPOUKPUEYORJLHROELYBOKHLMYHWFYDRJKOWTTDUBDXUKKHJYBELZKJDXMDLYXLMOUKYHLMENHLYHFORJKOWTMHLNELZHLMENHLBDWMRJDPLBHLMJOHBENHLWDGOROAOYYOUYBHLJDXNHL';

/// Encrypts the input with a substitution cipher. cycleK is the key to do
/// this encryption, where cycleK is a permutation in cycle notation.
Cryptext substitutionEncrypt(Cryptext input, List<String> cycleK) {
  if (!permutationIsWholeAlphabet(cycleK, input.alphabet)) {
    throw Exception("GivenPermutationIsNotValidForAlphabet");
  }

  var tabPerm = tabularNotationFromCycle(cycleK);
  List<String> tabInput = tabPerm.item1;
  List<String> tabOutput = tabPerm.item2;

  List<String> inputOnlyValid = input.lettersInAlphabet;
  List<String> output = [];
  for (int i = 0; i < inputOnlyValid.length; i++) {
    output.add(tabOutput[tabInput.indexOf(inputOnlyValid[i])]);
  }

  return Cryptext(letters: output, alphabet: input.alphabet);
}

/// Decrypts the input that was encrypted with the given permutation. cycleK is
/// the key from encryption that is a permutation in cycle notation.
Cryptext substitutionDecrypt(Cryptext input, List<String> cycleK) {
  if (!permutationIsWholeAlphabet(cycleK, input.alphabet)) {
    throw Exception("GivenPermutationIsNotValidForAlphabet");
  }

  return substitutionEncrypt(input, cycleNotationInverse(cycleK));
}

/// Converts the tabular notation of a permutation into cycle notation. Takes
/// two lists of characters, the input and output of the permutation.
List<String> cycleNotationFromTabular(List<String> input, List<String> output) {
  if (input.toSet().length != input.length || output.toSet().length != output.length) {
    throw Exception("PermutationHasRepeatingCharacters");
  }
  if (input.toSet().length != output.toSet().length) {
    throw Exception("PermutationsHaveMismatchedLengths");
  }
  for (String char in input) {
    if (!output.contains(char)) {
      throw Exception("PermutationsHaveDifferingCharacters");
    }
  }

  List<String> usedChars = [];
  List<String> cycles = [];
  for (int i = 0; i < input.length; i++) {
    String nextChar = input[i];
    while (!usedChars.contains(nextChar)) {
      usedChars.add(nextChar);
      // First element of a cycle? Has to add a new string to cycles. Otherwise append.
      nextChar == input[i] ? cycles.add(nextChar) : cycles.last += nextChar;
      nextChar = output[input.indexOf(nextChar)];
    }
  }
  return cycles;
}

/// Finds the inverse of a given permutation in cycle notation.
List<String> cycleNotationInverse(List<String> cycles) {
  return cycles.where((cycle) => cycle.length > 1).map((cycle) {
    return cycle[0] + cycle.substring(1, cycle.length).split("").reversed.join();
  }).toList() + cycles.where((cycle) => cycle.length == 1).toList();
}

/// Converts a permutation in cycle notation to the tabular notation. Takes the
/// cycle notation. Returns the input and output for long notation.
Tuple2<List<String>, List<String>> tabularNotationFromCycle(List<String> cycles) {
  List<String> input = [];
  List<String> output = [];
  for (String cycle in cycles) {
    for (int i = 0; i < cycle.length; i++) {
      input.add(cycle[i]);
      output.add(cycle[cycle.length > 1 ? (i + 1) % (cycle.length) : i]);
    }
  }
  return Tuple2(input, output);
}

/// If permutation is exclusive to the alphabet and contains all letters.
bool permutationIsWholeAlphabet(List<String> cyclePerm, Alphabet alphabet) {
  if (alphabet.length != cyclePerm.join().length) {
    return false;
  }
  return permutationIsInAlphabet(cyclePerm, alphabet);
}

/// If permutation is completely contained within the alphabet.
bool permutationIsInAlphabet(List<String> cyclePerm, Alphabet alphabet) {
  for (String char in cyclePerm.join().split('')) {
    if (!alphabet.letters.contains(char)) {
      return false;
    }
  }
  return true;
}

/// Returns true if all characters in the permutation are unique (no repeats).
bool permutationIsUnique(List<String> cyclePerm) {
  List<String> chars = cyclePerm.join().split('');
  return chars.length == chars.toSet().length;
}


List<String> parseCycleNotation(String raw, {String startDelimiter = "(", String endDelimiter = ")"}) {
  // Build raw string for regex.
  // https://stackoverflow.com/questions/3697644/regex-match-text-in-between-delimiters
  String pattern = r'';
  pattern += '\[$startDelimiter\](.*?)\[$endDelimiter\]';
  //pattern += '\\$startDelimeter.+?\\$endDelimeter';
  //pattern += "| *?[^ \\$startDelimeter\\$endDelimeter]+? +?";
  RegExp cycleMatcher = RegExp(pattern);

  // Matches all cases of delimeters to remove them (cycles must be preserved).
  List<String> cycles = cycleMatcher.allMatches(raw).map((e) => e.group(0)!).toList();
  String delimeterPattern = r'' + '\\$endDelimiter*\\$startDelimiter*';
  RegExp delimeterMatcher = RegExp(delimeterPattern);
  cycles = cycles.map((cycle) => cycle = cycle.replaceAll(delimeterMatcher, "")).toList();

  // Remove all blank matches (had opening and closing delimeter and no content).
  cycles.removeWhere((element) => element == "");
  return cycles;
}

/// Returns an error if current raw doesn't work in parsing a permutation.
/// Returns null if there is no error.
String? permParseError(String raw, Alphabet alphabet, String startDelimiter, String endDelimiter) {
  List<String> newPerm = parseCycleNotation(raw);
  
  // Gets all the raw characters in and outside of the delimeters.
  var inputChars = raw.split('').where((e) => e != startDelimiter && e != endDelimiter && e != ' ').toList();
  if (newPerm.join().split('').contains(' ')) {
    inputChars.add(' ');
  }

  if (!permutationIsInAlphabet(newPerm, alphabet)) {
    return 'Input includes characters not in alphabet.';
  }
  else if (!permutationIsUnique(newPerm)) {
    return 'Input includes repeat characters.';
  }
  else if (inputChars.length != newPerm.join().length) {
    return 'Input includes characters outside delimiters.';
  }
  else {
    // Valid (includes an empty input).
    return null;
  }
}

/// Fills remaining cycles (the ones that go to themselves).
List<String> getSingleLengthCycles(List<String> cycles, Alphabet alphabet) {
  List<String> permChars = cycles.join().split('');
  List<String> remainingSingleLengthCycles = [];
  for (String char in alphabet.letters) {
    if (!permChars.contains(char)) {
      remainingSingleLengthCycles.add(char);
    }
  }
  return remainingSingleLengthCycles;
}

String buildTabularPermutationVisual(List<String> cyclePerm, Alphabet alphabet) {
  if (!permutationIsWholeAlphabet(cyclePerm, alphabet)) {
    throw Exception("BuildVisualOfIncompleteAlphabet");
  }

  var tab = tabularNotationFromCycle(cyclePerm);
  tab = tabularNotationAlphabetical(tab, alphabet);

  String inputLine = tab.item1.map((char) => "$char ").join();
  String outputLine = tab.item2.map((char) => "$char ").join();

  inputLine = inputLine.substring(0, inputLine.length - 1);
  outputLine = outputLine.substring(0, outputLine.length - 1);

  return '$inputLine\n$outputLine';
}

String buildCyclePermutationVisual(List<String> cyclePerm, Alphabet alphabet) {
  if (!permutationIsWholeAlphabet(cyclePerm, alphabet)) {
    throw Exception("BuildVisualOfIncompleteAlphabet");
  }

  // First sorts by alphabetical. Has an effect if alphabet changes.
  cyclePerm.sort((a, b) => alphabet.indexOf(a[0]).compareTo(alphabet.indexOf(b[0])));
  // Sorts by length of cycle piece. Larger cycle pieces are put first.
  cyclePerm.sort((a, b) => -a.length.compareTo(b.length));
  return cyclePerm.map((cycle) => "($cycle)").join();
}

Tuple2<List<String>, List<String>> tabularNotationAlphabetical(Tuple2<List<String>, List<String>> tabPerm, Alphabet alphabet) {
  List<String> input = [];
  List<String> output = [];
  for (int i = 0; i < alphabet.length; i++) {
    int indexOfI = tabPerm.item1.indexOf(alphabet.letters[i]);
    input.add(tabPerm.item1[indexOfI]);
    output.add(tabPerm.item2[indexOfI]);
  }
  return Tuple2(input, output);
}

void main() {
  print(cycleNotationFromTabular("ABCD".split(''), "ADBC".split('')));
  print(cycleNotationFromTabular("ABCD".split(''), "ABCD".split('')));

  print(tabularNotationFromCycle(['A', 'BDC']));
  
  List<String> key = ['AHB', 'CNLWP', 'DMRUXVGZQIEO', 'FTYJSK'];
  print(key);
  print(cycleNotationInverse(key));

  Cryptext p = Cryptext.fromString('IHOPPEDOFFTHEPLANEATLAX');
  Cryptext c = substitutionEncrypt(p, key);
  Cryptext p_decrypted = substitutionDecrypt(c, key);

  print(c);
  print(p_decrypted);

  print(parseCycleNotation("   (ABCD)    EFG  () ()"));

  //String raw = r'';
  //raw += "HI";
  //print(raw);
  //print(r'\(.+?\)| +?[^ \(\)]+? +?');
}