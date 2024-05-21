import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:intl/intl.dart';

class experiencepage extends StatefulWidget {
  const experiencepage({Key? key}) : super(key: key);

  @override
  State<experiencepage> createState() => _experiencepageState();
}

class _experiencepageState extends State<experiencepage> {
  TextEditingController _review = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _gameName = TextEditingController();
  late ImagePicker _imagePicker;
  File? _image;
  CollectionReference _reference =
      FirebaseFirestore.instance.collection("experience");

  String imageUrl = '';
  final int maxWords = 500;
  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _pickImage() async {
    final pickedImage1 =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage1?.path != null) {
      setState(() {
        _image = File(pickedImage1!.path);
      });
    }
  }

  Future<void> addImageToFirebase() async {
    //creating uniq name for image
    if (_image == null) return;
    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

//Get a Reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFilename);
    try {
//Store the file
      await referenceImageToUpload.putFile(_image!);
      //get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();

      if (_gameName.text != "" &&
          _date.text != "" &&
          _review.text != "" &&
          _image != null) {
        Map<String, dynamic> dataToSave = {
          "gamename": _gameName.text,
          "date": _date.text,
          "review": _review.text,
          "image": imageUrl,
        };
        await FirebaseFirestore.instance
            .collection('experience')
            .add(dataToSave);
        _gameName.clear();
        _date.clear();
        _review.clear();
        setState(() {
          _image = null;
        });
      }
      // _reference.add(dataToSave);
    } catch (error) {
      print("errorr");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.black, title: Text("Community")),
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            child: Column(children: [
              _topPart(),
              _middlePart(),
            ]),
          ),
        ),
      ),
    );
  }

  Container _topPart() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/hometop.jpg"),
              fit: BoxFit.cover)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  height: MediaQuery.of(context).size.height / 9,
                  width: MediaQuery.of(context).size.width / 5,
                  child:
                      ClipOval(child: Image.asset("assets/images/logo.png"))),
            ),
            Text(
              "CONNECT AND DISCUSS",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 8,
            ),
            Text("WITH COMMUNITIES",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(
              height: 30,
            )
          ]),
    );
  }

  Container _middlePart() {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 50, // <-- SEE HERE
            ),
            Text("Community Activity",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50, // <-- SEE HERE
            ),
            if (_image != null)
              buildDashedBorder(
                  child: Container(
                width: MediaQuery.of(context).size.width / 5 * 2,
                height: MediaQuery.of(context).size.height / 5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.upload_file_outlined, size: 50.0),
                  color: Color.fromARGB(255, 92, 85, 85),
                  onPressed: () {
                    _pickImage();
                  },
                ),
              ))
            else
              buildDashedBorder(
                  child: Container(
                width: MediaQuery.of(context).size.width / 5 * 2,
                height: MediaQuery.of(context).size.height / 5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/imgpickerbg.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.upload_file_outlined, size: 50.0),
                  color: Color.fromARGB(255, 92, 85, 85),
                  onPressed: () {
                    _pickImage();
                  },
                ),
              )),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 80,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 17,
                  child: TextFormField(
                    controller: _gameName,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.games),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "GAME NAME",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 1,
                    validator: (text) {
                      if (text?.isEmpty ?? true) {
                        return 'Game name cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 80,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 17,
                  child: TextFormField(
                    controller: _date,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "DATE",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    readOnly: true,
                    maxLines: 1,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('MM/dd/yy').format(pickedDate);
                        setState(() {
                          _date.text = formattedDate;
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    // validator: (text) {
                    //   if (text?.isEmpty ?? true) {
                    //     return 'Email cannot be empty';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height / 80, // <-- SEE HERE
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height / 10,
                  child: TextFormField(
                    controller: _review,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "REVIEW",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 3,
                    onTap: () {},
                    validator: (text) {
                      if (text?.isEmpty ?? true) {
                        return 'Review cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 80, // <-- SEE HERE
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 14,
              child: ElevatedButton(
                onPressed: () {
                  addImageToFirebase();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 77, 83, 87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 12.0,
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                child:
                    const Text('Post', style: TextStyle(color: Colors.black)),
              ),
            ),
          ]),
    );
  }

  Widget buildDashedBorder({required Widget child}) => DottedBorder(
      color: Color.fromARGB(255, 100, 100, 94),
      dashPattern: [20, 4],
      strokeWidth: 4,
      radius: Radius.circular(50),
      child: child);
}
