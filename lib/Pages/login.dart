import 'package:eip_test/Client/client_server.dart';
import 'package:eip_test/Styles/color.dart';
import 'package:eip_test/main.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  static String ipAddress = "";
  bool isVisible = false;
  dynamic _clientLogin;
  final TextEditingController input = TextEditingController();

  @override
  void initState() {
    super.initState();
    input.text = ipAddress;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: MyColor().myGrey,
        appBar: AppBar(
          title: const Text("Login Page"),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding( // Logo
                padding: const EdgeInsets.only(top: 60.0, bottom: 35.0),
                child: Center(
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: MyColor().myOrange,
                          borderRadius: BorderRadius.circular(10)),
                      width: 200,
                      height: 100,
                      child: Image.asset(
                        'assets/images/logo_easystream_orange.png',
                      ),
                    ),
                    onDoubleTap: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                  ),
                ),
              ),
              Visibility( // IP Address
                visible: isVisible,
                replacement: const SizedBox(
                  height: 74.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15.0, bottom: 0.0),
                  child: TextField(
                    controller: input,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: MyColor().myOrange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: MyColor().myOrange),
                      ),
                      labelText: 'IP Address',
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    onChanged: (value) {
                      setState(() {
                        ipAddress = value;
                      });
                    },
                  ),
                ),
              ),
              Padding( // Email
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15.0, bottom: 0.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColor().myOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: MyColor().myOrange),
                    ),
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
              Padding( // Password
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColor().myOrange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: MyColor().myOrange),
                    ),
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
              ),
              TextButton( // Forgot Password Button
                onPressed: () {
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              Container( // Login Button
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: MyColor().myOrange,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    debugPrint("email : " + email);
                    debugPrint("password : " + password);
                    _clientLogin = await login(email, password);
                    if (_clientLogin != null) {
                      await createTcpClient(ipAddress).then((value) {
                        if (value == true) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()));
                        } else {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error",
                                      style:
                                          TextStyle(color: MyColor().myOrange)),
                                  content: Text(
                                      "Couldn't connect to the server OBS",
                                      style:
                                          TextStyle(color: MyColor().myOrange)),
                                  backgroundColor: MyColor().myGrey,
                                );
                              });
                        }
                      });
                    } else {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error",
                                  style: TextStyle(color: MyColor().myOrange)),
                              content: Text("Email or Password incorrect",
                                  style: TextStyle(color: MyColor().myOrange)),
                              backgroundColor: MyColor().myGrey,
                            );
                          });
                    }
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              const Text( // Create New User
                'New User? Create Account',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
