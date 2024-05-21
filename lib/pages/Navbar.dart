import 'package:flutter/material.dart';
import 'package:racingr/pages/performance.dart';
import 'package:racingr/pages/community.dart';
import 'package:racingr/pages/favourite.dart';
import 'package:racingr/pages/editaccount.dart';
import 'package:racingr/pages/category.dart';
import 'package:racingr/pages/home.dart';
import 'package:racingr/pages/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _uid = "";
  String _uname = "";
  String _uemail = "";
  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 119, 118, 118),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                _uname,
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              accountEmail: Text(
                _uemail,
                style: TextStyle(fontSize: 17),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(child: Image.asset("assets/images/logo.png")),
                backgroundColor: Colors.white,
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/mvl1.jpg"),
                      fit: BoxFit.cover)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                "Home",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return home();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics),
              title: Text(
                "Gameplay Analysis",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return Performance();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text(
                "Community",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return communitypage();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text(
                "Favourites",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return Favourite();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text(
                "Category",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return Categories();
                }));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                "Settings",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return editaccount();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return singinpage();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}
