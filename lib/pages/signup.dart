import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racingr/pages/category.dart';
import 'package:racingr/pages/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class signuppage extends StatefulWidget {
  const signuppage({Key? key}) : super(key: key);

  @override
  State<signuppage> createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _createuserinfirestore(User? user) {
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'username': _usernameController.text,
        'email': _emailController.text,
        'likedimages': []
      }).then((_) {
        print("User added ");
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
      }).catchError((Error) {
        print("Failed");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/signin.JPG"),
            fit: BoxFit.fill,
          )),
          child: Stack(
            alignment: Alignment.bottomCenter, //newly added
            children: <Widget>[
              _getSignUp(context),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 9,
          width: MediaQuery.of(context).size.width / 5,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage("assets/images/logo.png"))),
        ),
      ],
    )));
  }

  Container _getSignUp(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 1.12,
      height: MediaQuery.of(context).size.height / 1.4,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14.5)),
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30, // <-- SEE HERE
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 15,
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Username",
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 1,
                validator: (text) {
                  if (text?.isEmpty ?? true) {
                    return 'Email cannot be empty';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 35, // <-- SEE HERE
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 15,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (text) {
                  if (text?.isEmpty ?? true) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 35, // <-- SEE HERE
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 15,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (text) {
                  if (text?.isEmpty ?? true) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 35, // <-- SEE HERE
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 15,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Confirm password",
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (text) {
                  if (text?.isEmpty ?? true) {
                    return 'Password is not match';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30, // <-- SEE HERE
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 14,
              child: ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text)
                        .then((value) {
                      _createuserinfirestore(value.user);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return Categories();
                      }));
                    });
                  } else {
                    print("form is not valid");
                  }
                },
                // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 77, 83, 87),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 12.0,
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                child: const Text('Sign Up',
                    style: TextStyle(color: Colors.black)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30, // <-- SEE HERE
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an Account ?  ",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => singinpage(),
                          ));
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                    ))
              ],
            )
          ]),
        ),
      ),
    );
  }
}
