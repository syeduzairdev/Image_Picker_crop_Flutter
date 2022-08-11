import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//this is thee widget that will be used to display the bottom sheet of the chat message screen
class BottomSheetIcons extends StatefulWidget {
  final onClickAction;
  final String tiletext;
  final IconData icon;
  const BottomSheetIcons({
    Key? key,
    required this.onClickAction,
    required this.tiletext,
    required this.icon,
  }) : super(key: key);

  @override
  State<BottomSheetIcons> createState() => _BottomSheetIconsState();
}

class _BottomSheetIconsState extends State<BottomSheetIcons> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClickAction,
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              //border radius
              // borderRadius: BorderRadius.circular(7),
              //border color
              border: Border.all(color: Colors.grey, width: 1),
              shape: BoxShape.circle,
              color: Colors.white, // borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              widget.icon,
              color: Color(0xff5449F8),
              size: 25,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.tiletext,
            style: TextStyle(
                fontSize: 10.sp,
                color: Color(0xff8A8D9F),
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
