import 'dart:io';
import 'package:cam/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: PickImageVideo(),
    );
  }
}

class PickImageVideo extends StatefulWidget {
  const PickImageVideo({Key? key}) : super(key: key);

  @override
  State<PickImageVideo> createState() => _PickImageVideoState();
}

class _PickImageVideoState extends State<PickImageVideo> {
  var _image;
  var _video;
  var imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

//Selecting multiple images from Gallery
  List<XFile>? imageFileList = [];
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  void pickImageFromGallery() async {
    XFile image = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    setState(() {
      _image = File(image.path);
    });
  }

  void pickImageFromCamera() async {
    XFile image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      _image = File(image.path);
    });
  }

  void pickVideoFromGallery() async {
    XFile _video = await imagePicker.pickVideo(source: ImageSource.gallery);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => VideoPlayerFromFile(
          videopath: _video.path,
        ),
      ),
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Image"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 237, 192, 143),
              onPressed: () {
                pickImageFromGallery();
              },
              child: Text('FROM GALLERY'),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 237, 192, 143),
              onPressed: () {
                pickImageFromCamera();
              },
              child: Text('FROM CAMERA'),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 237, 192, 143),
              onPressed: () {
                pickVideoFromGallery();
              },
              child: Text("Select video from Gallery"),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Color.fromARGB(255, 237, 192, 143),
              onPressed: () {
                selectImages();
              },
              child: Text('Select Multiple Images'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: _image != null
                  ? Image.file(
                      _image,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.fitHeight,
                    )
                  : Text("             Pick an image from gallery or click"),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: imageFileList!.length,
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        File(imageFileList![index].path),
                        height: 200,
                        width: 200,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
