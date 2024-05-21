import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:racingr/pages/gamelist.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<GameList> fullGameList = [];
  List<GameList> selectGameList = [];
  List<GameList> finalselectGameList = [];
  bool isDataLoading = false;
  String _uid = "";
  late QuerySnapshot userDoc;
  List<String> selectedGames = [];
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('games');
  @override
  void initState() {
    loadObject();
    super.initState();
    getData();
  }

  void getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    //  userDoc =await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    // setState(() {
    //   _uname = userDoc.get('username');
    //   _uemail = user.email!;
    // });
  }

  Future<void> loadObject() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var item in allData) {
      print("inside for loop");
      final games = item as Map;
      print(games['game_title']);
      fullGameList.add(GameList(games['id'], games['game_title'],
          games['category'], games['img_url'], games['isSeleted']));
    }
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();

      if (documentSnapshot.exists) {
        // need to check whether cat are null or not

        selectedGames = List<String>.from(documentSnapshot.get('likedimages'));
      }
      for (int i = 0; i < selectedGames.length; i++) {
        for (int j = 0; j < fullGameList.length; j++) {
          if (selectedGames[i] == fullGameList[j].img_url) {
            selectGameList.add(GameList(
                fullGameList[j].id,
                fullGameList[j].game_title,
                fullGameList[j].catogeries,
                selectedGames[i],
                fullGameList[j].isSeleted));
          }
        }
      }
      setState(() {
        finalselectGameList = selectGameList;
        isDataLoading = true;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(''),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            _topPart(),
            _bottomPart(context),
          ]),
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
              padding: const EdgeInsets.only(left: 10.0, top: 40),
              child: Text(
                "MY FAVOURITES",
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

  Container _bottomPart(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.6,
      color: Colors.black,
      width: double.infinity,
      child: isDataLoading
          ? ListView.builder(
              itemCount: finalselectGameList.length,
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
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(20)),
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
                                    image: AssetImage(
                                        finalselectGameList[index].img_url),
                                    fit: BoxFit.cover)),
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                          flex: 14,
                          child: Container(
                            // padding: const EdgeInsets.only(top: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 30,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        selectGameList[index].game_title,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      // Text("sdfsdf"),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 30,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.favorite),
                                        color: Colors.red,
                                        onPressed: () {},
                                      )
                                    ],
                                  ),
                                ]),
                          ))
                    ]),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.orangeAccent,
                backgroundColor: Colors.black,
              ),
            ),
    );
  }
}
