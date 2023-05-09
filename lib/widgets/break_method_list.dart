import 'package:flutter/material.dart';

// Local
import 'package:veil/data_structures/break_method.dart';

// Styles
import 'package:veil/styles/styles.dart';

class BreakMethodList extends StatefulWidget {
  final List<BreakMethod> methods;
  final BreakMethod selectedMethod;
  final Function(BreakMethod) setBreakMethod;
  final TextStyle _style;

  const BreakMethodList({
    super.key,
    required this.methods,
    required this.selectedMethod,
    required this.setBreakMethod,
    TextStyle? style,
  })
  : _style = style ?? CustomStyle.cipherSelectionButton;

  @override
  State<BreakMethodList> createState() => _BreakMethodList();
}

class _BreakMethodList extends State<BreakMethodList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                // Wrapping Listview in an Expanded -> Column -> Expanded will
                // make it appear on the top of the container (expanded).
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title.
                      Text('Select a cracking method', style: CustomStyle.headers),
                      SizedBox(height: 10),
                      Divider(),

                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: widget.methods.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Container(
                                height: 60,
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 6),
                                  child: Text(widget.methods[index].title, style: widget._style),
                                ),
                              ),

                              onTap: () {
                                widget.setBreakMethod(widget.methods[index]);
                              }
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        ),
                      )
                    ],
                  ),
                ),

                //SizedBox(width: 20),
                const VerticalDivider(width: 40, thickness: 2),

                // Descriptions.
                //Spacer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.selectedMethod.title, style: CustomStyle.headers),
                      const SizedBox(height: 10),
                      const Divider(),

                      Expanded(
                        child: Text(
                          widget.selectedMethod.description,
                          style: CustomStyle.content,
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}