import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/FadeAnimation.dart';
import 'package:imam_pelayanan_katolik/homepage.dart';
//import 'package:pelayanan_iman_katolik/forgetPassword.dart';
//import 'package:pelayanan_iman_katolik/singup.dart';
import 'DatabaseFolder/mongodb.dart';
//import 'package:pelayanan_iman_katolik/homePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/imageedit_2_4702386825.png?alt=media&token=53776f41-1d60-4057-adeb-899f82d0ae67'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/light-1.png?alt=media&token=0d0ab37a-ebca-4259-881c-dd4e1ba844bd'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/light-2.png?alt=media&token=fe4a055f-63fe-4d76-afb8-8fae5d353cdb'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/pelayananimankatolik.appspot.com/o/clock.png?alt=media&token=d1a161d5-ca29-4d5c-9a4d-e8a02f26cb09'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                          1.6,
                          Container(
                            margin: EdgeInsets.only(top: 85),
                            child: Center(
                              child: Text(
                                'Halo,Imam Katolik!',
                                style: GoogleFonts.davidLibre(
                                  textStyle: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      letterSpacing: .5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey))),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email or Phone number",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          2,
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                                textColor: Colors.white,
                                color: Colors.lightBlue,
                                child: Text("Login"),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                onPressed: () async {
                                  if (emailController.text == "" ||
                                      passwordController.text == "") {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Email atau Password Tidak Boleh Kosong",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    emailController.clear();
                                    passwordController.clear();
                                  } else {
                                    var ret = await MongoDatabase.findUser(
                                        emailController.text,
                                        passwordController.text);

                                    if (ret != "failed") {
                                      print(ret);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                ret[0]['name'],
                                                ret[0]['_id'],
                                                ret[0]['idGereja'])),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Email dan Password Salah",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 2,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      emailController.clear();
                                      passwordController.clear();
                                    }
                                  }
                                }),
                          )),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
