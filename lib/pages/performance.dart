import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Performance extends StatefulWidget {
  const Performance({Key? key}) : super(key: key);

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  File? _image;
  String imgpath = "";
  late ImagePicker _imagePicker;

  int numClasses = 10;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage1 =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage1?.path != null) {
      setState(() {
        _image = File(pickedImage1!.path);
        imgpath = pickedImage1!.path;
      });
    }
  }

  var postsJson = [];
  String lapTime = "";
  String gear = "";
  String acceleration = "";
  bool isLapTimeLoading = false;
  bool isGeerLoading = false;
  bool isAcceLading = false;

  Future<void> _fetchGameAnalyseDataa() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://18.176.54.27:8000/predict'));
      request.files.add(await http.MultipartFile.fromPath('file', imgpath));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = jsonDecode(await response.stream.bytesToString());

        setState(() {
          if (data['lapTime'] != null) {
            lapTime = data['lapTime'];
            isLapTimeLoading = true;
          }
          if (data['gear'] != null) {
            gear = data['gear'];
            isGeerLoading = true;
          }
          if (data['acceleration'] != null) {
            acceleration = data['acceleration'];
            isAcceLading = true;
          }
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Performance"),
        ),
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
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "ANALYSE YOUR",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("GAME PLAY SKILLS",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
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
      height: MediaQuery.of(context).size.height / 1.575,
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 50, // <-- SEE HERE
        ),
        Text("Gameplay analysis",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Padding(
          padding: EdgeInsets.only(left: 15, bottom: 0, right: 20, top: 0),
          child: Text("ANALYSE YOUR GAMEPLAY PERFORMANCE",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 50, // <-- SEE HERE
        ),
        if (_image != null)
          buildDashedBorder(
              child: Container(
            width: MediaQuery.of(context).size.width / 5 * 3,
            height: MediaQuery.of(context).size.height / 4,
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
            width: MediaQuery.of(context).size.width / 5 * 3,
            height: MediaQuery.of(context).size.height / 4,
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
        SizedBox(
          height: MediaQuery.of(context).size.height / 50, // <-- SEE HERE
        ),
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 185, 180, 165),
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width / 3 * 1.9,
          height: MediaQuery.of(context).size.height / 6,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Lap Time",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 12,
                      ),
                      Text(
                        "-",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 17,
                      ),
                      Text(
                        lapTime.toString(),
                        style: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Gear",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 5.6,
                      ),
                      Text(
                        "-",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 18,
                      ),
                      Text(
                        gear.toString(),
                        style: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Acceleration",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "-",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 20,
                      ),
                      Text(
                        acceleration.toString(),
                        style: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 70, // <-- SEE HERE
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 14,
          child: ElevatedButton(
            onPressed: () {
              _fetchGameAnalyseDataa();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 77, 83, 87),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 12.0,
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            child: const Text('Analyse', style: TextStyle(color: Colors.black)),
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
