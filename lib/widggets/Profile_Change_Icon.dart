import 'package:flutter/material.dart';

class ProfileChangeIcon extends StatelessWidget {
  const ProfileChangeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 85, top: 80),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff5449F8),
        ),
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }
}
