import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class listtile_widget extends StatefulWidget {
  //these are the parameters that are passed into the widget
  final onClickAction;
  final String tiletext;
  final IconData icon;
  const listtile_widget({
    Key? key,
    required this.onClickAction,
    required this.tiletext,
    required this.icon,
  }) : super(key: key);

  @override
  State<listtile_widget> createState() => _listtile_widgetState();
}

class _listtile_widgetState extends State<listtile_widget> {
  @override
  Widget build(BuildContext context) {
    //this is the widget that is returned
    return ListTile(
        leading: Icon(
          widget.icon,
          color: Color(0xff9D9FAE),
        ),
        title: Text(
          widget.tiletext,
          style: TextStyle(
            fontSize: 10.sp,
            color: Color(0xff969696),
          ),
        ),
        onTap: () {
          widget.onClickAction();
        });
  }
}
