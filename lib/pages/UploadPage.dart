import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:postme_app/models/user.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/widgets/PostWidget.dart';
import 'package:postme_app/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

DateTime timestampUpload;

class UploadPage extends StatefulWidget {

  @override
  _UploadPageState createState() => _UploadPageState();
}



class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage> {

  File file;
  bool uploading = false;
  String postID = Uuid().v4();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  captureImageWithCamera() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context){
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Color(0xff607dd9),
            child: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 340,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                    child: Column(
                      children: [
                        Text('How do you want to upload the image?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: 'MontserratBold', fontSize: 22),),
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            onTap: captureImageWithCamera,
                            child: AnimatedContainer(
                                alignment: Alignment.center,
                                duration: Duration(milliseconds: 300),
                                height: 45,
                                width: 260,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(35)),
                                child: Text("Capture image with camera", style: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratBold', fontSize: 15),
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            onTap: pickImageFromGallery,
                            child: AnimatedContainer(
                                alignment: Alignment.center,
                                duration: Duration(milliseconds: 300),
                                height: 45,
                                width: 260,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(35)),
                                child: Text("Select image from gallery", style: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratBold', fontSize: 15),
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: AnimatedContainer(
                                alignment: Alignment.center,
                                duration: Duration(milliseconds: 300),
                                height: 45,
                                width: 260,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(35)),
                                child: Text("Cancel", style: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratBold', fontSize: 15),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -40,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 40,
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 50,),
                    )
                ),
              ],
            )
        );
      },
    );
  }

  displayUploadScreen() {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 30.0, right: 30.0),
      child: ListView(
        children: <Widget>[
          Container(
            height: 110.0,
            width: 200.0,
            child: Stack(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: 215,
                    height: 68,
                    decoration: BoxDecoration(
                        color: Color(0xff607dd9),
                        borderRadius: BorderRadius.circular(33)),
                    child: Text('Upload',
                        style: TextStyle(
                            fontFamily: 'MontserratExtraBold',
                            fontSize: 45.0,
                            color: Colors.white
                        )
                    )
                ),
                Positioned(
                    top: 75.0,
                    left: 12,
                    child: Text(
                        'Your Favour',
                        style: TextStyle(
                            fontFamily: 'MontserratExtraBold',
                            fontSize: 34.0
                        )
                    )
                ),
                Positioned(
                    top: 100.0,
                    left: 227.0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff2949a9)
                      ),
                    )
                ),
              ],
            ),
          ),
          SizedBox(height: 65.0),
          Image.asset('assets/images/upload_image.png', scale: 0.75),
          SizedBox(height: 50.0),
          Container(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () => takeImage(context),
              child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 300),
                  height: 60,
                  width: 280,
                  decoration: BoxDecoration(
                      color: Color(0xff607dd9),
                      borderRadius: BorderRadius.circular(35)),
                  child: Text("Upload Image", style: TextStyle(color: Colors.white, fontFamily: 'MontserratBold', fontSize: 26),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearPostInfo() {
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      file = null;
    });
  }

  getUserCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMark[0];
    String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country}';
    String specificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
    locationTextEditingController.text = specificAddress;
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postID.jpg')..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 60));
    setState(() {
      file = compressedImageFile;
    });
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    await compressingPhoto();
    String downloadUrl = await uploadPhoto(file);
    savePostInfoToFireStore(url: downloadUrl, location: locationTextEditingController.text, description: descriptionTextEditingController.text);
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
      postID = Uuid().v4();
    });
  }

  savePostInfoToFireStore({String url, String location, String description}) {
    setState(() {
      timestampUpload = DateTime.now();
    });
    postReference.document(currentUser.id).collection("usersPosts").document(postID).setData({
      "postId": postID,
      "ownerId": currentUser.id,
      "timestamp": timestampUpload,
      "likes": {
      },
      "username": currentUser.username,
      "description": description,
      "location": location,
      "url": url
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mStorageUploadTask = storageReference.child("post_$postID.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot = await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Color(0xff607dd9)), onPressed: clearPostInfo),
        title: Text("New Favour", style: TextStyle(fontSize: 23.0, color: Color(0xff607dd9), fontFamily: 'MontserratBold')),
        centerTitle: true,
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
              onPressed: uploading ? null : () => controlUploadAndSave(),
              child: Text("Share",
                  style: TextStyle(
                    color: Color(0xff607dd9),
                    fontFamily: 'MontserratSemiBold',
                    fontSize: 18.0,
                  )
              )
          ),
        ],
      ),

      body: ListView(
        children: <Widget>[
          uploading ? LinearProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.lightBlue),
          ) : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                    decoration: BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.cover))
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 40.0)),
          ListTile(
            leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(currentUser.url)),
            title: Container(
              width: 300.0,
              child: TextField(
                style: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratMedium'),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                    hintText: "Say something about your image",
                    hintStyle: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratSemiBold'),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_pin_circle, color: Color(0xff607dd9), size: 36.0),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratMedium'),
                controller: locationTextEditingController,
                decoration: InputDecoration(
                    hintText: "Where was this image taken?",
                    hintStyle: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratSemiBold'),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Container(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: getUserCurrentLocation,
              child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 300),
                  height: 60,
                  width: 280,
                  decoration: BoxDecoration(
                      color: Color(0xff607dd9),
                      borderRadius: BorderRadius.circular(35.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 30,),
                      SizedBox(width: 3),
                      Text("Get my current location", style: TextStyle(color: Colors.white, fontFamily: 'MontserratBold', fontSize: 17),),
                      SizedBox(width: 5),
                    ],
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }


  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}

