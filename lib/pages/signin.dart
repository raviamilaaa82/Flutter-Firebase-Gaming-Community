import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:racingr/pages/forgotpassword.dart';
import 'package:racingr/pages/signup.dart';

import 'package:racingr/pages/home.dart';

class singinpage extends StatefulWidget {
  const singinpage({Key? key}) : super(key: key);

  @override
  State<singinpage> createState() => _singinpageState();
}

class _singinpageState extends State<singinpage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(0),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/signin.JPG"),
                  fit: BoxFit.fill,
                )),
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: SingleChildScrollView(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        _getSignIn(context),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 9,
                width: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"))),
              ),
            ],
          )),
    ));
  }

  Container _getSignIn(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 1.12,
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14.5)),
      child: Form(
        key: _formkey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              "Sign In",
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
            height: MediaQuery.of(context).size.height / 25, // <-- SEE HERE
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
            height: MediaQuery.of(context).size.height / 20, // <-- SEE HERE
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 14,
            child: ElevatedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((value) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return home();
                    })).onError((error, stackTrace) {
                      print("error");
                    });
                  });
                } else {
                  print("form is not valid");
                }
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
                  const Text('Sign In', style: TextStyle(color: Colors.black)),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 25, // <-- SEE HERE
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => forgotpassword(),
                        ));
                  },
                  child: Text(
                    "Forget Password ?",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                  ))
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 25, // <-- SEE HERE
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "New Member ?  ",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => signuppage(),
                        ));
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                  ))
            ],
          )
        ]),
      ),
    );
  }
}
