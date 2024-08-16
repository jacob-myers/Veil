import 'package:quiver/iterables.dart';

extension CipherExtension on String {
  /// Returns itself broken up into chunks of size chunkLen as an Iterable.
  List<String> chunks(int chunkLen, [String? padWith]) {
    List<String> cs = partition(split(''), chunkLen).map((e) => e.join()).toList();
    //if (cs.last.length < )
    if (padWith != null) {
      cs.last = cs.last + (padWith * (chunkLen - cs.last.length));
    }
    return cs;
  }
}