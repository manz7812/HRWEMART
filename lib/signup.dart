import 'package:flutter/material.dart';
import 'fade_animation.dart';
import 'login.dart';


class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // Colors.purple,
                  Colors.purple.shade600,
                  Colors.deepPurpleAccent,
                ])),
        child: Column(
          children: [
            // Container(
            //     // margin: const EdgeInsets.all(10),
            //     padding: EdgeInsets.only(top: 60),
            //     child: const FadeAnimation(
            //       2,
            //       Text(
            //         "HR System",
            //         style: TextStyle(
            //           fontSize: 35,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //           letterSpacing: 3,
            //         ),
            //       ),
            //     )),
            Expanded(
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  margin: const EdgeInsets.only(top: 80),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Container(
                          // color: Colors.red,
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(left: 22, bottom: 20),
                            child: const FadeAnimation(
                              2,
                              Text(
                                "ลงทะเบียน",
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.black87,
                                    letterSpacing: 2,
                                    fontFamily: "Sarabun"),
                              ),
                            )),
                        FadeAnimation(
                          2,
                          Container(
                              width: double.infinity,
                              height: 60,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purpleAccent, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.purpleAccent,
                                        blurRadius: 5,
                                        offset: Offset(1, 1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.email_outlined),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          label: Text("Username"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        FadeAnimation(
                          2,
                          Container(
                              width: double.infinity,
                              height: 60,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purpleAccent, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.purpleAccent,
                                        blurRadius: 5,
                                        offset: Offset(1, 1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.password_rounded),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          label: Text("Password"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        FadeAnimation(
                          2,
                          Container(
                              width: double.infinity,
                              height: 60,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purpleAccent, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.purpleAccent,
                                        blurRadius: 5,
                                        offset: Offset(1, 1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.perm_identity_outlined),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          label: Text("ชื่อ-นามสกุล"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        FadeAnimation(
                          2,
                          Container(
                              width: double.infinity,
                              height: 60,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purpleAccent, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.purpleAccent,
                                        blurRadius: 5,
                                        offset: Offset(1, 1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.manage_accounts),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          label: Text("ตำแหน่ง"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        FadeAnimation(
                          2,
                          Container(
                              width: double.infinity,
                              height: 60,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.purpleAccent, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.purpleAccent,
                                        blurRadius: 5,
                                        offset: Offset(1, 1)),
                                  ],
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.credit_card_outlined),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          label: Text("รหัสตำแหน่ง"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          2,
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.purpleAccent,
                                shadowColor: Colors.purpleAccent,
                                elevation: 18,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Colors.purpleAccent,
                                    Colors.deepPurpleAccent
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                child: const Text(
                                  'ตกลง',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                      fontFamily: "Sarabun"
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        FadeAnimation(
                          2,
                          TextButton(
                              onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                                },
                              child: const Text(
                                " เข้าสู่ระบบ ",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15,fontFamily: "Sarabun"),
                              )),
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
