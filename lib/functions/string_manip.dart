import 'package:quiver/iterables.dart';

extension CipherExtension on String {
  /// Returns itself broken up into chunks of size numChunks as an Iterable.
  Iterable<String> chunks(int numChunks) {
    return partition(split(''), 2).map((e) => e.join());
  }
}