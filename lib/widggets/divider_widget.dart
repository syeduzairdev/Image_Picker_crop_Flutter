import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class dividerWidget extends StatelessWidget {
  const dividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.5.h,
      thickness: 0.3.sp,
      color: Color(0xff838382),
    );
  }
}
