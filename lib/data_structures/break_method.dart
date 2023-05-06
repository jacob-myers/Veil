// Abstraction of data for a break method. To organize the tag, title, and description.

import 'package:flutter/cupertino.dart';

class BreakMethod {
  String tag;
  String title;
  String description;
  final Widget Function() build;

  BreakMethod({
    required this.tag,
    required this.title,
    this.description = '',
    required this.build,
  });
}