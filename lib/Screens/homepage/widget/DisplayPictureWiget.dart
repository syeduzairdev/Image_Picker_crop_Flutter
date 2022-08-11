import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice/widggets/Profile_Change_Icon.dart';
import 'package:practice/widggets/bottomSheet_Icons.dart';
import 'package:sizer/sizer.dart';

typedef void FileCallback(File? image);

class DisplayPictureWiget extends StatefulWidget {
  final FileCallback OnPictureChanged;
  final double height;
  final double width;
  final String defaultimage;
  final bool isLoading;
  // construcor
  const DisplayPictureWiget(
      {Key? key,
      this.defaultimage = "",
      required this.height,
      required this.width,
      required this.OnPictureChanged,
      required this.isLoading})
      : super(key: key);
  // create state
  @override
  State<DisplayPictureWiget> createState() => DisplayPictureWidgetState();
}

class DisplayPictureWidgetState extends State<DisplayPictureWiget> {
  File? profileimage;
  File? croppedProfile;
  File? Profile;
  File? CroppedFile;
  String?
      _defaultImage; // copy of parameter defaultImage so that we can change it

  @override
  void initState() {
    super.initState();
    // make copy of the default image so that we can change it
    _defaultImage = widget.defaultimage;
  }

  /// Get image from source
  Future pickImage(ImageSource source) async {
    final profileimage = await ImagePicker().pickImage(source: source);
    // image pick up has been cancelled
    if (profileimage == null) {
      return;
    } else {
      // image pickec up and passed to cropping
      _cropImage(profileimage.path);
      setState(() {
        Profile = File(profileimage.path);
        print(Profile);
      });
    }
  }

  /// Crop Image and set it to image
  Future<void> _cropImage(String filePath) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      // chosen croped image
      croppedProfile = File(croppedImage.path);
      setState(() {});
    } else {
      // chosen original image
      croppedProfile = Profile;
      setState(() {});
    }
    // pass this chosen image on callback so that parent widget can handle it
    widget.OnPictureChanged(croppedProfile);
  }

// initState

  @override
  Widget build(BuildContext context) {
    // _defaultImage = widget.defaultimage;
    return Stack(
      children: [
        // on child 0 goes - our image handling widget
        Center(
          //check if the image is null then show the default image
          // child: widget.defaultimage!.isNotEmpty
          child: _defaultImage!.isNotEmpty
              ? InkWell(
                  onTap: () {
                    _onButtonPressed(
                      context,
                      BottomSheetIcons(
                        onClickAction: () {
                          setState(
                            () {
                              _closeBottomSheet(context);
                              // widget.defaultimage == '';
                              _defaultImage = "";
                              croppedProfile = null;
                            },
                          );
                        },
                        tiletext: 'Remove',
                        icon: Icons.delete,
                      ),
                    );
                  },
                  // If default image is URL or Asset file
                  child: Stack(
                    children: [
                      ClipOval(
                          // child: widget.defaultimage!.startsWith('http')
                          child: _defaultImage!.startsWith('http')
                              ? ClipOval(
                                  child: Image.network(
                                    // widget.defaultimage!,
                                    _defaultImage!,
                                    height: widget.height,
                                    width: widget.width,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipOval(
                                  child: Image.asset(
                                    // widget.defaultimage!,
                                    _defaultImage!,
                                    height: widget.height,
                                    width: widget.width,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                      // Widget of camera icon to change image
                      ProfileChangeIcon(),
                    ],
                  ),
                )
              // below widget tree will render when user has chosen an image from gallery or camera or cropped
              : croppedProfile != null
                  ? InkWell(
                      onTap: () {
                        _onButtonPressed(
                          context,
                          BottomSheetIcons(
                            onClickAction: () {
                              setState(
                                () {
                                  _closeBottomSheet(context);
                                  // widget.defaultimage == '';
                                  _defaultImage = "";
                                  croppedProfile = null;
                                },
                              );
                            },
                            tiletext: 'Remove',
                            icon: Icons.delete,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          ClipOval(
                            // this is chosen image from camera or gallery or cropped image
                            child: Image.file(
                              croppedProfile!,
                              height: this.widget.height,
                              width: this.widget.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Widget of camera icon to change image
                          ProfileChangeIcon(),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        //  when no image is chosen the bottom sheet will be shown upon click of the widget
                        _onButtonPressed(
                          context,
                          SizedBox(),
                        );
                      },
                      child: Container(
                        height: this.widget.height,
                        width: this.widget.width,
                        child: Icon(
                          Icons.camera_alt,
                          color: Color(0xff8A8D9F),
                          size: 30.sp,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffECECEC),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
        ),
        // on child 1 goes - circular progress indicator
        (widget.isLoading)
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 15,
                          width: 18,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        padding: EdgeInsets.all(1.0),

                        // decoration with rounded corners
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Saving...",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(height: 0, width: 0),
      ],
    );
  }

  // bottom sheet to show the camera or gallery or remove options
  _onButtonPressed(BuildContext context, removeButtonIcon) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 26.h,
          color: Color(0xff737373),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xffFEFEFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upload Profile Photo',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff686868),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Color(0xff838382),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      BottomSheetIcons(
                        onClickAction: () {
                          // callback(showCamera)
                          pickImage(ImageSource.camera);
                          _closeBottomSheet(context);
                        },
                        tiletext: 'Camera',
                        icon: Icons.camera_alt,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      BottomSheetIcons(
                        onClickAction: () {
                          pickImage(ImageSource.gallery);
                          _closeBottomSheet(context);
                        },
                        tiletext: 'Gallery',
                        icon: Icons.photo_library,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      removeButtonIcon,
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // close the bottom sheet
  void _closeBottomSheet(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
