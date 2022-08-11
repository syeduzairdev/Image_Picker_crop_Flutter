import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice/widggets/divider_widget.dart';
import 'package:practice/widggets/liosttile_widget.dart';
import 'package:sizer/sizer.dart';

typedef void FileCallback(File val);

class DisplayPictureWiget extends StatefulWidget {
  //these all are the parameters that are passed into the widget
  final FileCallback? OnSuccessFile;
  final double? height;
  final double? width;
  final String? defaultimage;
  const DisplayPictureWiget({
    Key? key,
    this.defaultimage = "", // optional with a default value,
    this.height,
    this.width,
    this.OnSuccessFile,
  }) : super(key: key);
  @override
  State<DisplayPictureWiget> createState() => DisplayPictureWidgetState();
}

class DisplayPictureWidgetState extends State<DisplayPictureWiget> {
  //these all are the variables that are used in the widget
  late final FileCallback? OnSuccessFile;
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

  /// Crop Image and set it to image
  Future<void> _cropImage(imge) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: imge.toString(),
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedImage != null) {
      croppedProfile = File(croppedImage.path);
      print("This is Croper Image${croppedProfile}");
      // OnSuccessFile!(croppedProfile!);
      setState(() {});
    } else {
      croppedProfile = Profile;
      print("This is Image Picker Image${croppedProfile}");
      //  OnSuccessFile!(croppedProfile!);
      setState(() {});
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
        //check if the image is null then show the default image
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
                          widget.defaultimage == '';
                          croppedProfile = null;
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
                  height: this.widget.height,
                  width: this.widget.width,
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
                              widget.defaultimage == '';
                              croppedProfile = null;
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
                            height: this.widget.height,
                            width: this.widget.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 90, top: 80),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.green,
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
                    )));
  }

// this is the function that is called when the button is pressed and it opens the dialog
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
}
