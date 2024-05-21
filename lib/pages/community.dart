import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:racingr/pages/experience.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class communitypage extends StatefulWidget {
  const communitypage({Key? key}) : super(key: key);

  @override
  State<communitypage> createState() => _communitypageState();
}

class _communitypageState extends State<communitypage> {
  bool isThumbupSelected = false;
  String des = "";
  String dat = "";
  final _useStream =
      FirebaseFirestore.instance.collection("experience").snapshots();

  void fetchFirebaseData() async {
    await Firebase.initializeApp();
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference comunityref = databaseReference.child('expeirence');

    DataSnapshot? snapshot;
    var event = await comunityref.once();
    snapshot = event.snapshot;

    if (snapshot.value != null && snapshot.value is Map) {
      String description = "";
      String date = "";

      Map<dynamic, dynamic> data =
          snapshot.value as Map<dynamic, dynamic>; // Use explicit type casting

      if (data.containsKey('description') && data.containsKey('date')) {
        description = data['description'].toString();
        date = data['date'].toString();
      }

      setState(() {
        des = description;
        dat = date;
      });
    } else {
      setState(() {
        des = "No data ";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Community"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _useStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Connection error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.orangeAccent,
                backgroundColor: Colors.black,
              ));
            }
            var docs = snapshot.data!.docs;
            return Column(children: [
              _topPart(),
              _middlePart(),
              _bottomPart(docs),
              _button(),
            ]);
          }),
    ));
  }

  Container _topPart() {
    return Container(
      child: SingleChildScrollView(
        child: Container(
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
                      child: ClipOval(
                          child: Image.asset("assets/images/logo.png"))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "CONNECT AND DISCUSS",
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
                  child: Text("WITH COMMUNITIES",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                SizedBox(
                  height: 30,
                )
              ]),
        ),
      ),
    );
  }

  Container _middlePart() {
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 15,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Community Activity",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ]),
    );
  }

  Container _bottomPart(var docs) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      color: Colors.black,
      width: double.infinity,
      child: ListView.builder(
        itemCount: docs.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color.fromARGB(255, 134, 133, 131),
              ),
              borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
            ),
            // color: Colors.black,
            child: Container(
              height: MediaQuery.of(context).size.height / 5,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: const BorderRadius.all(const Radius.circular(20)),
                color: const Color.fromARGB(255, 134, 133, 131),
              ),
              child: Row(children: [
                Expanded(
                    flex: 6,
                    child: Container(
                      // padding: const EdgeInsets.only(bottom: 20),not working

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage('${docs[index]['image']}'),
                              fit: BoxFit.cover)),
                    )),
                Spacer(
                  flex: 1,
                ),
                Expanded(
                    flex: 14,
                    child: Container(
                      // padding: const EdgeInsets.only(top: 10),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('${docs[index]['date']}'),
                              Row(
                                children: [
                                  Text('${docs[index]['gamename']}'),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [Text('${docs[index]['review']}')],
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                15,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15,
                                        child: Theme(
                                          //
                                          data: ThemeData(useMaterial3: true),
                                          child: IconButton(
                                            icon: const Icon(Icons.thumb_up,
                                                size: 30.0),
                                            color:
                                                Color.fromARGB(255, 92, 85, 85),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                15,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15,
                                        child: IconButton(
                                          icon: const Icon(Icons.thumb_down,
                                              size: 30.0),
                                          color:
                                              Color.fromARGB(255, 92, 85, 85),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ]),
                              )
                            ]),
                      ),
                    ))
              ]),
            ),
          );
        },
      ),
    );
  }

  Container _button() {
    return Container(
      height: MediaQuery.of(context).size.height / 7.6,
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        height: MediaQuery.of(context).size.height / 5,
        child: IconButton(
          icon: const Icon(Icons.add_circle_rounded, size: 50.0),
          color: Color.fromARGB(255, 77, 83, 87),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return experiencepage();
            }));
          },
        ),
      ),
    );
  }
}
