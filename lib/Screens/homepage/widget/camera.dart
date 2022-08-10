import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice/widggets/divider_widget.dart';
import 'package:practice/widggets/liosttile_widget.dart';
import 'package:sizer/sizer.dart';

class DisplayPictureWiget extends StatefulWidget {
  final String? defaultimage;
  const DisplayPictureWiget({
    Key? key,
    this.defaultimage = "", // optional with a default value,
  }) : super(key: key);
  @override
  State<DisplayPictureWiget> createState() => DisplayPictureWidgetState();
}

class DisplayPictureWidgetState extends State<DisplayPictureWiget> {
  late final VoidCallback Selected;
  File? profileimage;
  File? croppedProfile;
  File? Profile;
  File? CroppedFile;

  var img;

  /// Get image from source
  Future pickImage(ImageSource source) async {
    final profileimage = await ImagePicker().pickImage(source: source);

    if (profileimage == null) {
      return;
    } else {
      _cropImage(profileimage.path);
      setState(() {
        Profile = File(profileimage.path);
        print(Profile);
      });
    }
  }

  /// Crop Image
  Future<void> _cropImage(imge) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: imge.toString(),
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      croppedProfile = File(croppedImage.path);
      setState(() {});
    } else {
      croppedProfile = Profile;
      setState(() {});
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
        child: widget.defaultimage!.isNotEmpty
            ? InkWell(
                onTap: () {
                  _onButtonPressed(
                    context,
                    35.h,
                    dividerWidget(),
                    listtile_widget(
                      onClickAction: () {
                        setState(() {
                          croppedProfile = null;
                          imageCache?.clear();
                          imageCache?.clearLiveImages();
                        });
                      },
                      tiletext: 'Remove Image',
                      icon: Icons.delete,
                    ),
                  );
                },
                // Image with ClipOval to make it circular
                child: ClipOval(
                    child: Image.network(
                  widget.defaultimage!,
                  height: 10.h,
                  width: 20.w,
                  fit: BoxFit.cover,
                )),
              )
            // if we don't have a default image, and we have a cropped image,
            // show it, otherwise show a camera icon
            : croppedProfile != null
                ? InkWell(
                    onTap: () {
                      _onButtonPressed(
                        context,
                        35.h,
                        dividerWidget(),
                        listtile_widget(
                          onClickAction: () {
                            setState(() {
                              croppedProfile = null;
                              imageCache?.clear();
                              imageCache?.clearLiveImages();
                            });
                          },
                          tiletext: 'Remove Image',
                          icon: Icons.delete,
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Image.file(
                            croppedProfile!,
                            height: 10.h,
                            width: 20.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 45, top: 40),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                : InkWell(
                    onTap: () {
                      //  Navigator.of(context).pop();
                      _onButtonPressed(context, 35.h, SizedBox(), SizedBox());
                    },
                    child: Container(
                      height: 12.h,
                      width: 24.w,
                      child: Icon(
                        Icons.camera_alt,
                        color: Color(0xff8A8D9F),
                        size: 30.sp,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffECECEC),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    )));
  }

  _onButtonPressed(
    BuildContext context,
    hght,
    dvd,
    rmv_img,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: hght,
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffFEFEFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upload Vehicle Photos',
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
                    dividerWidget(),
                    listtile_widget(
                      onClickAction: () {
                        // callback(showCamera)
                        pickImage(ImageSource.camera);
                      },
                      tiletext: 'Take Photo From Camera',
                      icon: Icons.camera_alt,
                    ),
                    dividerWidget(),
                    listtile_widget(
                      onClickAction: () {
                        pickImage(ImageSource.gallery);
                      },
                      tiletext: 'Choose Photos from phone gallery',
                      icon: Icons.photo_library,
                    ),
                    dvd,
                    rmv_img,
                  ],
                ),
              ),
            ),
          );
        });
  }

  // show image selection action options
  // _showImageSelectionOptions(
  //     BuildContext context, SelectionType selectionType) {
  //   // show selection option Camera | Gallery
  //   // show selection option Camera | Gallery | Remove Image
  //   // now this function shoulw be responsible for showing the bottom sheet based on the selection type
  //   switch (selectionType) {
  //     case SelectionType.cameraAndGallery:
  //       // return bottom sheet with camera and gallery menu

  //       break;
  //     case SelectionType.cameraGalleryAndRemovePhoto:
  //       // return bottom sheet with camera gallery and remove photo options

  //       break;
  //     default:
  //   }
  // }
}

// enum SelectionType {
//   cameraAndGallery,
//   cameraGalleryAndRemovePhoto,
// }