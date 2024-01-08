import 'package:quiver/iterables.dart';

extension CipherExtension on String {
  List<String> chunks(int numChunks) {
    return partition(split(''), 2).map((e) => e.join()).toList();
  }
}