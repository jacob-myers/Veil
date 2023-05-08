import 'package:flutter/material.dart';

// Styles
import 'package:veil/styles/styles.dart';

//https://stackoverflow.com/questions/53411890/how-can-i-have-my-appbar-in-a-separate-file-in-flutter-while-still-having-the-wi

class AppbarCipherPage extends StatefulWidget implements PreferredSizeWidget{
  final String title;
  final Function(String) onModeButtonPress;
  AppBar appBar = AppBar(); // To get size from
  String mode;

  AppbarCipherPage({
    super.key,
    required this.title,
    required this.mode,
    required this.onModeButtonPress,
  });

  @override
  State<AppbarCipherPage> createState() => _AppbarCipherPage();

  @override
  Size get preferredSize  => new Size.fromHeight(appBar.preferredSize.height);
}

class _AppbarCipherPage extends State<AppbarCipherPage> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      actions: [
        IconButton(
          // Without '() =>', it will attempt to call the function, rather than set as member.
          onPressed: () => widget.onModeButtonPress('encrypt'),
          color: widget.mode == 'encrypt' ? Colors.white : CustomStyle.appBarTheme.foregroundColor,
          icon: Icon( Icons.lock ),
          tooltip: "Encrypt",
        ),
        SizedBox(width: 10),
        IconButton(
          onPressed: () => widget.onModeButtonPress('decrypt'),
          color: widget.mode == 'decrypt' ? Colors.white : CustomStyle.appBarTheme.foregroundColor,
          icon: Icon( Icons.lock_open ),
          tooltip: "Decrypt",
        ),
        SizedBox(width: 10),
        IconButton(
          onPressed: () => widget.onModeButtonPress('break'),
          color: widget.mode == 'break' ? Colors.white : CustomStyle.appBarTheme.foregroundColor,
          icon: Icon( Icons.diamond ),
          tooltip: "Break Tools",
        ),
        SizedBox(width: 20),
      ],
    );
  }
}