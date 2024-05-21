import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// import 'package:http/http.dart' as http;
import 'package:racingr/pages/Navbar.dart';
import 'package:racingr/pages/gamelist.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> recomendationGames = [];

  List<GameList> foundGameList = [];
  List<GameList> recomendedGames = [];
  bool standardSelected = false;
  int selectedIndex = -1;

  List<GameList> fullGameList = [];

  bool isRecomendedGamesLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
    getImagedata();
  }

  String _uid = "";
  String _uname = "";
  String _uemail = "";

  List<Offset> pointList = <Offset>[];

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('games');

  Future<void> getImagedata() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var item in allData) {
      final games = item as Map;

      foundGameList.add(GameList(games['id'], games['game_title'],
          games['category'], games['img_url'], games['isSeleted']));
    }

    List<String> selectedGames = [];

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();

    if (userDoc.exists) {
      selectedGames = List<String>.from(userDoc.get('likedimages'));

      if (selectedGames.length > 0) {
        for (int i = 0; i < foundGameList.length; i++) {
          for (int j = 0; j < selectedGames.length; j++) {
            if (foundGameList[i].img_url == selectedGames[j]) {
              setState(() {
                foundGameList[i].isSeleted = true;
              });
            }
          }
        }
      }
    }
    fetchRecommendedGames();
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

  Future<void> fetchRecommendedGames() async {
    List<String> userSelectedCategories = await getSelectedCategories();

    if (userSelectedCategories.length > 0) {
      for (int j = 0; j < userSelectedCategories.length; j++) {
        for (int i = 0; i < foundGameList.length; i++) {
          if (userSelectedCategories[j] == foundGameList[i].catogeries) {
            recomendedGames.add(GameList(
                foundGameList[i].id,
                foundGameList[i].game_title,
                foundGameList[i].catogeries,
                foundGameList[i].img_url,
                foundGameList[i].isSeleted));
          }
        }
      }
      setState(() {
        isRecomendedGamesLoading = true;
        foundGameList = recomendedGames;
        fullGameList = recomendedGames;
      });
    } else {
      setState(() {
        foundGameList = [];
      });
    }
  }

  Future<List<String>> getSelectedCategories() async {
    List<String> selectedCategories = [];

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();

    if (userDoc.exists) {
      print(userDoc.data()); // need to check whether cat are null or not
      selectedCategories = List<String>.from(userDoc.get('categories'));
    }
    return selectedCategories;
  }

  void onSearch(String search) {
    List<GameList> results = [];
    if (search == "") {
      setState(() {
        foundGameList = fullGameList;
      });
    } else {
      results = foundGameList
          .where((element) =>
              element.game_title.toLowerCase().contains(search.toLowerCase()))
          .toList();
      setState(() {
        if (results.length > 0) {
          foundGameList = results;
        }
      });
    }
  }

  void _addSelectedImgToDB(String img_url) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    DocumentReference documentReference = collectionReference.doc(_uid);
    documentReference.update({
      'likedimages': FieldValue.arrayUnion([img_url]),
    });
  }

  void _removeSelectedImgFromDB(String img_url) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");
    DocumentReference documentReference = collectionReference.doc(_uid);
    documentReference.update({
      'likedimages': FieldValue.arrayRemove([img_url]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Home"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            _topPart(),
            _middlePart(),
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
                "DISCOVER NEW",
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
              child: Text("RACING GAME",
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
      height: MediaQuery.of(context).size.height / 10,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Recommender",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("SEARCH A TITLE AND FIND SIMILER CONTENT",
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.red)),
            ),
            SizedBox(
              height: 10,
            )
          ]),
    );
  }

  Container _bottomPart(BuildContext context) {
    return Container(
        color: Colors.black,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
              child: TextField(
                style: TextStyle(color: Colors.white),
                autocorrect: false,
                enableSuggestions: false,
                onChanged: (value) => onSearch(value),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintStyle:
                        TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    hintText: "Search games"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.3,
              //need to responsive

              child: isRecomendedGamesLoading
                  ? ListView.builder(
                      itemCount: foundGameList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(children: <Widget>[
                          gameCard(foundGameList[index], context, index,
                              foundGameList[index].isSeleted),
                          Positioned(
                              top: 10,
                              child: movieImage(foundGameList[index].img_url))
                        ]);
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: Colors.orangeAccent,
                        backgroundColor: Colors.black,
                      ),
                    ),
            ),
          ],
        ));
  }

  Widget gameCard(
      GameList games, BuildContext context, int index, bool isSeleted) {
    return InkWell(
      child: Container(
          margin: EdgeInsets.only(left: 60.0),
          width: MediaQuery.of(context).size.width,
          height: 120.0,
          child: Card(
            color: const Color.fromARGB(255, 61, 57, 57),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 54.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        games.game_title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white),
                        maxLines: 4,
                      ),
                      Theme(
                        data: ThemeData(useMaterial3: true),
                        child: isSeleted
                            ? IconButton(
                                icon: const Icon(Icons.favorite),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    _removeSelectedImgFromDB(
                                        foundGameList[index].img_url);
                                    if (foundGameList[index].isSeleted ==
                                        true) {
                                      foundGameList[index].isSeleted = false;
                                    }
                                  });
                                },
                              )
                            : IconButton(
                                icon: const Icon(Icons.favorite_outline),
                                color: Colors.amber,
                                onPressed: () {
                                  setState(() {
                                    if (foundGameList[index].isSeleted ==
                                        false) {
                                      foundGameList[index].isSeleted = true;
                                      _addSelectedImgToDB(
                                          foundGameList[index].img_url);
                                    }
                                  });
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
      onTap: () => {},
    );
  }

  Widget movieImage(String imgUrl) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            image: new AssetImage(imgUrl),
            fit: BoxFit.cover,
          )),
    );
  }
}
