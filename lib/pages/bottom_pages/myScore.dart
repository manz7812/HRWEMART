import 'package:flutter/material.dart';

class MyScorePage extends StatefulWidget {
  const MyScorePage({Key? key}) : super(key: key);

  @override
  State<MyScorePage> createState() => _MyScorePageState();
}

class _MyScorePageState extends State<MyScorePage> {
  bool loading = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.70,
      // minChildSize: 0.2,
      maxChildSize: 1.0,
      builder: (BuildContext context, ScrollController scrollController) {
        return Scaffold(
          body: loading ? SingleChildScrollView(
            child: Card(
              elevation: 3,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.transparent)
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                      alignment: Alignment.topLeft,
                      child:  Row(
                        children: [
                          Text(
                            "คะแนนของฉัน : ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "100 คะแนน",
                            style: TextStyle(
                              color: Colors.black87,
                              // fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                      alignment: Alignment.topLeft,
                      child:  Text(
                        "ประวัติการหักคะแนน :",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              : const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                  strokeWidth: 5,
                )
          ),
        );
      },
    );
  }
}
