import 'dart:io';
import 'package:flutter/material.dart';
import 'package:practice/Screens/homepage/widget/DisplayPictureWiget.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  bool _isImageUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              InkWell(
                child: DisplayPictureWiget(
                  OnPictureChanged: _onPictureChangedEventHandler,
                  isLoading: _isImageUploading,
                  height: 115,
                  width: 115,
                  defaultimage:
                      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPictureChangedEventHandler(File? image) {
    print("image changed ${image!.path}");
    setState(() {
      _isImageUploading = true;
    });
    // futrure delayed for 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isImageUploading = false;
      });
    });
  }
}
