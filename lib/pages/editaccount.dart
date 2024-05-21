import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class editaccount extends StatefulWidget {
  const editaccount({Key? key}) : super(key: key);

  @override
  State<editaccount> createState() => _editaccountState();
}

class _editaccountState extends State<editaccount> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _usernamecontrollernonedit =
      TextEditingController();
  final TextEditingController _usernamecontrollerlabel =
      TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _emailcontrollernonedit = TextEditingController();
  final TextEditingController _emailcontrollerlabel = TextEditingController();

  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;

    _fetchUserData();
  }

  void _fetchUserData() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.uid)
        .get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      _usernamecontroller.text = userData['username'] ?? '';
      _usernamecontrollernonedit.text = userData['username'] ?? '';
      _emailcontroller.text = userData['email'] ?? '';
      _emailcontrollernonedit.text = userData['email'] ?? '';
      _usernamecontrollerlabel.text = "Name :";
      _emailcontrollerlabel.text = "Email";
    }
  }

  Future<void> _updateUserData() async {
    await FirebaseFirestore.instance.collection('users').doc(_user.uid).update({
      'username': _usernamecontroller.text,
      'email': _emailcontroller.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            AppBar(backgroundColor: Colors.black, title: Text("Edit Account ")),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0),
          child: Column(children: [
            _topPart(),
            _middlePart(),
            _bottomPart(),
            // _button(),
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
                "MY ACCOUNT",
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

  Container _middlePart() {
    return Container(
      height: MediaQuery.of(context).size.height / 3.6,
      color: const Color.fromARGB(255, 131, 128, 128),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
              child: Text("Account Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: TextFormField(
                      controller: _usernamecontrollerlabel,
                      decoration: InputDecoration(
                        // prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // hintText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 1,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: TextFormField(
                      controller: _usernamecontrollernonedit,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // hintText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 1,
                      readOnly: true,
                      // validator: (text) {
                      //   if (text?.isEmpty ?? true) {
                      //     return 'Email cannot be empty';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: TextFormField(
                      controller: _emailcontrollerlabel,
                      decoration: InputDecoration(
                        // prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // hintText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 1,
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: TextFormField(
                      controller: _emailcontrollernonedit,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // hintText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 1,
                      readOnly: true,
                      // validator: (text) {
                      //   if (text?.isEmpty ?? true) {
                      //     return 'Email cannot be empty';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _bottomPart() {
    return Container(
      height: MediaQuery.of(context).size.height / 2.9,
      color: Color.fromARGB(255, 209, 206, 206),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
                child: Text(
                  "Edit/Update Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: TextFormField(
                        controller: _usernamecontrollerlabel,
                        decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // hintText: "Email",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 1,
                        readOnly: true,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.8,
                      child: TextFormField(
                        controller: _usernamecontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          // hintText: "Email",
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 1,
                        // readOnly: true,
                        validator: (text) {
                          if (text?.isEmpty ?? true) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 14,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 14,
                child: ElevatedButton(
                  onPressed: () {
                    _updateUserData();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 77, 83, 87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 12.0,
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  child: const Text('Edit Profile',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
