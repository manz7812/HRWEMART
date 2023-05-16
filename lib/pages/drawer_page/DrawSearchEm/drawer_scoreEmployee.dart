import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EditScoreEmployeePage extends StatefulWidget {
  const EditScoreEmployeePage({Key? key}) : super(key: key);

  @override
  State<EditScoreEmployeePage> createState() => _EditScoreEmployeePageState();
}

class _EditScoreEmployeePageState extends State<EditScoreEmployeePage> {
  bool loading = false;
  int score = 0;
  TextEditingController scoretxt = TextEditingController();

  void addScore(){
    if(score  >= 100){
      print("no add score");
    }else{
      setState(() {
        score++;
        scoretxt.text = score.toString();
      });
    }
  }

  void removeScore(){
    if(score <= 100 && score > 0){
      setState(() {
        score--;
        scoretxt.text = score.toString();
      });
    }else{
      print("no remove score");
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
    scoretxt.addListener(() {
      setState(() {

      });
    });
    score = 100;
    scoretxt.text = score.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('จัดการคะแนนพนักงาน'),
        centerTitle: true,
        flexibleSpace : Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
            // border: Border.all(width: 15, color: Colors.white),
            gradient:  LinearGradient(
              colors: [
                Color(0xff6200EA),
                Colors.white,
              ],
              begin:  FractionalOffset(0.0, 1.0),
              end:  FractionalOffset(1.5, 1.5),
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.deepPurpleAccent,
            //     spreadRadius: 5, blurRadius: 30,
            //     offset: Offset(5, 3),
            //   ),
            // ],
            // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
          ),
        ),
      ),
      body: loading ? SingleChildScrollView(
        child: Card(
          elevation: 3,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.white)
          ),
          child: Container(
            width: double.infinity,
            // height: 150,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 0,bottom: 20),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey.shade400,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      const Text("ธีรภัทร์ เจริญวงค์ (แมน)",
                        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.deepPurpleAccent),),
                      Row(
                        children: const[
                          Text("ตำแน่ง : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
                          Text("Programmer",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black),),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text("อีเมล : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),)),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text("Theeraphad2541@gmail.com",
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black),),
                              )),
                        ],
                      ),
                      Row(
                        children: const[
                          Text("เบอร์โทรศัพท์ : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                          Text("0869497812",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black),),
                        ],
                      ),
                      Row(
                        children: [
                          Text("คะแนน : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.black),),
                          Text(
                            "${scoretxt.text}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              color: score ==0 || score <=10
                                  ? Colors.red
                                  : score == 11 || score <=20
                                  ? Colors.red.shade200
                                  : score == 21 || score <=30
                                  ? Colors.deepOrange.shade300
                                  : score == 31 || score <=40
                                  ? Colors.deepOrange
                                  : score == 41 || score <=50
                                  ? Colors.orange.shade300
                                  : score == 51 || score <=60
                                  ? Colors.orange.shade700
                                  : score == 61 || score <=70
                                  ? Colors.amber.shade200
                                  : score == 71 || score <=80
                                  ? Colors.yellow.shade400
                                  : score == 81 || score <=90
                                  ? Colors.lightGreen
                                  : score == 91 || score <=95
                                  ? Colors.green.shade300 : Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton(///
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  elevation: 3,
                                  shape: CircleBorder(),
                                ),
                                onPressed: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  removeScore();
                                },
                                child: const Icon(
                                  Icons.remove,
                                  size: 50,
                                  color: Colors.white,
                                )
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              autofocus: false,
                              // focusNode: FocusNode(),
                              showCursor: true,
                              readOnly: false,
                              controller: scoretxt,
                              style: TextStyle(
                                color: score ==0 || score <=10
                                    ? Colors.red
                                    : score == 11 || score <=20
                                    ? Colors.red.shade200
                                    : score == 21 || score <=30
                                    ? Colors.deepOrange.shade300
                                    : score == 31 || score <=40
                                    ? Colors.deepOrange
                                    : score == 41 || score <=50
                                    ? Colors.orange.shade300
                                    : score == 51 || score <=60
                                    ? Colors.orange.shade700
                                    : score == 61 || score <=70
                                    ? Colors.amber.shade200
                                    : score == 71 || score <=80
                                    ? Colors.yellow.shade400
                                    : score == 81 || score <=90
                                    ? Colors.lightGreen
                                    : score == 91 || score <=95
                                    ? Colors.green.shade300 : Colors.green,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) => (value!.isEmpty) ? '' : null,
                              decoration: const InputDecoration(
                                // filled: true,
                                // fillColor: Colors.grey.shade300,
                                // label: Text("เลือกวันที่"),
                                suffixIcon: Icon(
                                  Icons.star,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (val){
                                // print(val);
                                if(val.isEmpty){
                                  print("alert");
                                  val = "0";
                                  // scoretxt.text = "0";
                                  FocusScope.of(context).requestFocus(FocusNode());
                                }
                                var numScore = int.parse(val);
                                score = int.parse(val);
                                if(numScore <= 100 && numScore >0){
                                  // print("ok");
                                }else{
                                  // print("no ok");
                                  scoretxt.text = 0.toString();
                                  score = 0;
                                  // val = "0";
                                  FocusScope.of(context).requestFocus(FocusNode());
                                }
                              },
                            ),
                          ),
                          // Container(
                          //   child: Text(
                          //       "${scoretxt.text}",
                          //     style: TextStyle(
                          //       color: score ==0 || score <=10
                          //           ? Colors.red
                          //           : score == 11 || score <=20
                          //           ? Colors.red.shade200
                          //           : score == 21 || score <=30
                          //           ? Colors.deepOrange.shade300
                          //           : score == 31 || score <=40
                          //           ? Colors.deepOrange
                          //           : score == 41 || score <=50
                          //           ? Colors.orange.shade300
                          //           : score == 51 || score <=60
                          //           ? Colors.orange.shade700
                          //           : score == 61 || score <=70
                          //           ? Colors.amber.shade200
                          //           : score == 71 || score <=80
                          //           ? Colors.yellow.shade400
                          //           : score == 81 || score <=90
                          //           ? Colors.lightGreen
                          //           : score == 91 || score <=95
                          //           ? Colors.green.shade300 : Colors.green,
                          //       fontSize: 50
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: ElevatedButton(///อนุมัติ
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  elevation: 3,
                                  shape: CircleBorder(),
                                ),
                                onPressed: (){
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  addScore();
                                },
                                child: const Icon(
                                  Icons.add,
                                  size: 50,
                                  color: Colors.white,
                                )
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              // padding: const EdgeInsets.only(right: 16, left: 16),
                              // margin: EdgeInsets.all(10),
                              // alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: Colors.grey.shade500
                                // ),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    // minimumSize: Size(width, 100),
                                  ),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ยกเลิก')),
                            ),
                          ),
                          const SizedBox(width: 20,),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              // padding: const EdgeInsets.only(right: 16, left: 16),
                              // margin: EdgeInsets.all(10),
                              // alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: Colors.grey.shade500
                                // ),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    // backgroundColor: Colors.green,
                                    backgroundColor: Colors.green,
                                    // minimumSize: Size(width, 100),
                                  ),
                                  onPressed: (){

                                    },
                                  child: Text('บันทึก')),
                            ),
                          ),
                        ],
                      )
                    ],
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
              strokeWidth: 5,)
        ),
    );
  }
}
