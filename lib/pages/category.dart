import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:racingr/pages/gamelist.dart';
import 'package:collection/collection.dart';
import 'package:racingr/pages/home.dart';
import 'package:racingr/pages/signin.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> selectCategories = [];
  List<GameList> allGameList = [];
  List<GameList> fullGameList = [];
  List<GameList> goupedGameList = [];
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('games');
  String _uid = "";
  String _uname = "";
  String _uemail = "";
  int count = 0;
  bool isDataLoading = false;

  @override
  void initState() {
    getAllGamesdata();
    super.initState();
    getData();
  }

  void getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    setState(() {
      _uname = userDoc.get('username');
      _uemail = user.email!;
    });
  }

  Future<void> getAllGamesdata() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final allData = await querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var item in allData) {
      print("inside for loop");
      final games = item as Map;
      print(games['game_title']);
      allGameList.add(GameList(games['id'], games['game_title'],
          games['category'], games['img_url'], games['isSeleted']));
    }

    bool isGameAlreadyThere = false;
    for (int i = 0; i < allGameList.length; i++) {
      String category = allGameList[i].catogeries;

      if (goupedGameList.length > 0) {
        for (int y = 0; y < goupedGameList.length; y++) {
          if (category == goupedGameList[y].catogeries) {
            setState(() {
              isGameAlreadyThere = true;
            });
            break;
          } else {
            setState(() {
              if (isGameAlreadyThere == true) {
                isGameAlreadyThere = false;
              }
            });
          }
        }
        if (isGameAlreadyThere == false) {
          goupedGameList.add(GameList(
              allGameList[i].id,
              allGameList[i].game_title,
              allGameList[i].catogeries,
              allGameList[i].img_url,
              allGameList[i].isSeleted));
          setState(() {
            if (isGameAlreadyThere == true) {
              isGameAlreadyThere = false;
            }
          });
        }
      } else {
        goupedGameList.add(GameList(
            allGameList[i].id,
            allGameList[i].game_title,
            allGameList[i].catogeries,
            allGameList[i].img_url,
            allGameList[i].isSeleted));
      }
    }

    setState(() {
      fullGameList = goupedGameList;
      isDataLoading = true;
    });
  }

  void _toggleCategoriesSelection(String category) {
    setState(() {
      if (selectCategories.contains(category)) {
        selectCategories.remove(category);
      } else {
        selectCategories.add(category);
      }
    });
  }

  void _addSelectedImgToDB(String catogory_code) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    DocumentReference documentReference = collectionReference.doc(_uid);
    documentReference.update({
      'categories': FieldValue.arrayUnion([catogory_code]),
    });
  }

  void _removeSelectedImgFromDB(String catogory_code) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    DocumentReference documentReference = collectionReference.doc(_uid);
    documentReference.update({
      'categories': FieldValue.arrayRemove([catogory_code]),
    });
  }

  Future<void> _saveCategoriesToFirestore(String UserId) async {
    DocumentReference userDocref =
        FirebaseFirestore.instance.collection('users').doc(UserId);

    await userDocref.update({
      "categoreis": selectCategories,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: Text(''), actions: [
        GestureDetector(
          child: Icon(
            Icons.logout,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return singinpage();
            }));
          },
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(children: [
            _topPart(),
            _middlePart(),
            _gridViewList(context),
            _gotToNextPage(),
          ]),
        ),
      ),
    ));
  }

  Container _topPart() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/hometop.jpg"), fit: BoxFit.cover),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.end,
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
              padding: const EdgeInsets.only(left: 10.0, top: 20),
              child: Text(
                "PLEASE SELECT A GAME",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "FRANCHISE",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            )
          ]),
    );
  }

  Container _gridViewList(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: Colors.black),
      height: MediaQuery.of(context).size.height / 2,
      color: Colors.black,
      width: double.infinity,
      child: isDataLoading
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 8),
              itemCount: fullGameList.length,
              itemBuilder: (context, index) {
                // final item = fullGameList[index];
                return Card(
                  child: GestureDetector(
                    onTap: () {
                      print(fullGameList[index].game_title);
                      setState(() {
                        if (fullGameList[index].isSeleted == false) {
                          if (count < 3) {
                            fullGameList[index].isSeleted = true;
                            _addSelectedImgToDB(fullGameList[index].catogeries);

                            count++;
                          }
                        } else {
                          setState(() {
                            if (fullGameList[index].isSeleted == true) {
                              _removeSelectedImgFromDB(
                                  fullGameList[index].catogeries);
                              fullGameList[index].isSeleted = false;
                              count = count - 1;
                            }
                          });
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.height / 20,

                          decoration: BoxDecoration(
                              // color: Colors.black.withOpacity(1.0),
                              image: DecorationImage(
                                  image:
                                      AssetImage(fullGameList[index].img_url),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(
                                          fullGameList[index].isSeleted
                                              ? 1
                                              : 0),
                                      BlendMode.color))),
                          // child: Text("sdfsf"),
                        ),
                        Visibility(
                          visible: true,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              fullGameList[index].game_title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              maxLines: 4,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: fullGameList[index].isSeleted,
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.check,
                              color: Colors.red,
                              size: 30,
                              weight: 700,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
          : Center(
              child: CircularProgressIndicator(
                color: Colors.orangeAccent,
                backgroundColor: Colors.black,
              ),
            ),
    );
  }

  Container _middlePart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          SizedBox(
            child: Text(
              "PLEASE SELECT 3 FRANCHISES TO CONTINUE...",
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 70,
          ),
        ],
      ),
    );
  }

  Container _gotToNextPage() {
    return Container(
      alignment: Alignment.bottomRight,
      height: MediaQuery.of(context).size.height / 15,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.black),
      child: GestureDetector(
        child: Icon(
          Icons.arrow_forward_sharp,
          color: Colors.blue,
          size: 50,
          weight: 700,
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return home();
          }));
        },
      ),
    );
  }
}
