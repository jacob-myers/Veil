import 'dart:convert';
import 'dart:io';
import 'package:universal_html/html.dart' as webFile;
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

  // Apparently, ya just can't read from a file any other way on web.
  if (kIsWeb) {
    if (result != null) {
      String contents = utf8.decode(result.files.first.bytes!);
      return Cryptext.fromString(contents, alphabet: a);
    }
  // Windows way.
  } else if (result != null) {
    try {
      File file = File(result.files.first.path!);
      String contents = await file.readAsString();
      return Cryptext.fromString(contents, alphabet: a);
    } catch (e) {
      // If there is an error reading the file.
      print(e);
      return Cryptext(alphabet: a);
    }
  }

  // If no file is selected.
  return Cryptext(alphabet: a);
}