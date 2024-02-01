import 'dart:convert';
import 'dart:io';
import 'package:universal_html/html.dart' as webFile; // My bu
// tt "Find a different library for your needs."
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:veil/data_structures/alphabet.dart';

// Local
import 'package:veil/data_structures/cryptext.dart';

void saveToFile(Cryptext cryptext) async {
  // What to do if it's a web app.
  // https://stackoverflow.com/questions/57182634/how-can-i-read-and-write-files-in-flutter-web
  if(kIsWeb) {
    var blob = webFile.Blob([cryptext.toString()], 'text/plain', 'native');

    webFile.AnchorElement(
      href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
    )..setAttribute('download', 'download.txt')..click();
  }

  // What to do if it's a native desktop app.
  else {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'content.txt',
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (outputFile != null) {
        File saveFile = File(outputFile);
        saveFile.writeAsString(cryptext.toString());
      }
    } catch (e) {
      // Unanticipated errors.
      print(e);
    }
  }
}

Future<Cryptext> loadFromFile(Alphabet a) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['txt'],
  );

  if (result != null) {
    String contents = utf8.decode(result.files.first.bytes!);
    //String fileName = result.files.first.name;

    return Cryptext.fromString(contents, alphabet: a);
  }

  return Cryptext(alphabet: a);
}