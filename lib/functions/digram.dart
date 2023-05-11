import 'package:veil/data_structures/cryptext.dart';

String digramTableLabels(Cryptext cryptext, List<String> characters) {
  String table = digramTable(cryptext, characters);
  List<String> lines = table.split('\n');
  for (int i = 0; i < lines.length - 1; i++) {
    lines[i] = "${characters[i]}${lines[i]}\n";
  }
  lines.insert(0, " ${characters.join()}\n");
  return lines.join();
}

String digramTable(Cryptext cryptext, List<String> characters, {bool showLabels = true}) {
  List<List<String>> table = List.generate(characters.length, (index) => []);

  var digramInstances = digramCounts(cryptext);
  for (int i = 0; i < characters.length; i++) {
    for (int j = i; j < characters.length; j++) {
      table[j].add((digramInstances["${characters[j]}${characters[i]}"] ?? 0).toString());
      j != i ? table[i].add((digramInstances["${characters[i]}${characters[j]}"] ?? 0).toString()) : null;
    }
  }

  // Find the number with the most digits.
  int mostDigits = 0;
  for (var line in table) {
    for (String num in line) {
      if (num.length > mostDigits) {
        mostDigits = num.length;
      }
    }
  }

  // Pad each entry with mostDigits.
  table = table.map((line) => line.map((entry) => " ${entry.padLeft(mostDigits)}").toList()).toList();

  // Add labels if showLabels.
  if (showLabels) {
    // Each row.
    for (int i = 0; i < table.length; i++) {
      table[i].insert(0, characters[i]);
    }
    // Header.
    table.insert(0, [' ', ...characters.map((char) => " ${char.padLeft(mostDigits)}")]);
  }

  return table.map((line) => '${line.join()}\n').join();
}

Map<String, int> digramCounts (Cryptext cryptext) {
  Map<String, int> counts = {};
  List<String> valid = cryptext.lettersInAlphabet;
  for (int i = 0; i < valid.length - 1; i++) {
    counts.putIfAbsent("${valid[i]}${valid[i+1]}", () => 0);
    counts.update("${valid[i]}${valid[i+1]}", (value) => value += 1);
  }
  return counts;
}

void main() {
  Cryptext text = Cryptext.fromString("THISISTEXT");
  print(digramTable(text, ["T", "H", "I"]));
  print(digramTable(text, ["T", "H", "I"]));

  String hardcodedCiphertext = 'EBDCCOMDTTYBOCWHLOHYWHVPEYBHMUOHRHLMRJNHUMEZHLPOWNDROYDYBOWHLMDTTHROOVNOKKHREZDLLHTEYELSXRCOMELYBONHABOUOEHRTDUYBOTEUKYYEROWDDFYDRJUEZBYHLMEKOOYBOBDWWJPDDMKEZLYBEKEKHWWKDNUHQJOGOUJADMJKOORKKDTHRDXKRJYXRRJKYXULELHLMERTOOWELFELMHBDROKENFYDDRXNBCUOKKXUOHLMERLOUGDXKYBHYKPBOLYBOYHVERHLYXULOMDLYBOUHMEDHLMHSHJQKDLZPHKDLHLMHSHJQKDLZPHKDLHLMHSHJQKDLZPHKDLKDECXYRJBHLMKXCYBOJUOCWHJELZRJKDLZYBOAXYYOUTWEOKTWJHPHJERLDMMELRJBOHMWEFOJOHBRDGELRJBECKWEFOJOHBEZDYRJBHLMKXCYBOJUOCWHJELRJKDLZEFLDPERZDLLHAODFJOHBEYKHCHUYJELYBOXKHENHLHWRDKYKOOEYYBHYMUOHRERMUOHRELZAXYYBOUOKHGDENOELKEMORJBOHMKHJELJDXWWLOGOUUOHNBEYOGOUJKYOCERYHFELOGOUJRDGOERHFOTOOWKWDKYPEYBLDMEUONYEDLRJTHEYBEKKBHFELAXYEEZDYYHFOOCYUJELZDYYHFOOCRJBOHMBOWMBEZBYBOUOKHWPHJKZDLLHAOHLDYBOURDXLYHELERHWPHJKZDLLHPHLLHRHFOEYRDGOHWPHJKZDLLHAOHLXCBEWWAHYYWOKDROYEROKERZDLLHBHGOYDWDKOHELYHADXYBDPTHKYEZOYYBOUOHELYHADXYPBHYKPHEYELDLYBODYBOUKEMOEYKYBONWERAYBOKYUXZZWOKERTHNELZYBONBHLNOKERYHFELZKDROYEROKREZBYFLDNFROMDPLAXYLDERLDYAUOHFELZERHJLDYFLDPEYAXYYBOKOHUOYBORDROLYKYBHYERZDLLHUORORAOURDKYJOHBSXKYZDYYHFOOCZDELHLMEEZDYYHAOKYUDLZSXKYFOOCCXKBELZDLPONWHPOMPONBHELOMDXUBOHUYKELGHELPOSXRCOMLOGOUHKFELZPBJPOFEKKOMETOWWXLMOUJDXUKCOWWHWDGOLDDLONDXWMMOLJMDLYJDXOGOUKHJESXKYPHWFOMHPHJEPEWWHWPHJKPHLYJDXENHLYWEGOHWEOUXLLELZTDURJWETOEPEWWHWPHJKPHLYJDXENHROELWEFOHPUONFELZAHWWELOGOUBEYKDBHUMELWDGOHWWEPHLYOMPHKYDAUOHFJDXUPHWWKHWWJDXOGOUMEMPHKPUONFROJOHBJDXJDXPUONFROECXYJDXBEZBXCELYBOKFJHLMLDPJDXUOLDYNDRELZMDPLEYKWDPWJYXULOMJDXWOYROAXULHLMLDPPOUOHKBOKDLYBOZUDXLMPOPOUOZDDMPOPOUOZDWMFELMHMUOHRYBHYNHLYAOKDWMPOPOUOUEZBYYEWWPOPOUOLYAXEWYHBDROHLMPHYNBOMEYAXULEMEMLYPHLLHWOHGOJDXEMEMLYPHLLHWEOKYHUYOMYDNUJAXYYBOLUORORAOUOMENHLAXJRJKOWTTWDPOUKPUEYORJLHROELYBOKHLMYHWFYDRJKOWTTDUBDXUKKHJYBELZKJDXMDLYXLMOUKYHLMENHLYHFORJKOWTMHLNELZHLMENHLBDWMRJDPLBHLMJOHBENHLWDGOROAOYYOUYBHLJDXNHL';
  text = Cryptext.fromString(hardcodedCiphertext);
  print(digramTable(text, ["O", "H", "L", "Y"]));
}