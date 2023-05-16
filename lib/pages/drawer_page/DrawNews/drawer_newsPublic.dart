import 'package:flutter/material.dart';

import 'drawer_newsPublic_detail.dart';

class NewsPublicPage extends StatefulWidget {
  final String title;
  const NewsPublicPage({Key? key,required this.title}) : super(key: key);

  @override
  State<NewsPublicPage> createState() => _NewsPublicPageState();
}

class _NewsPublicPageState extends State<NewsPublicPage> {

  bool loading = false;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2),(){
      setState(() {
        loading = true;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(widget.title),
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
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Card(
                child: Container(
                  width: double.infinity,
                  // height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 0),
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey.shade800,
                                    size: 50,),
                                  radius: 35,
                                  backgroundColor: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                const Text("ผู้จัดการระบบ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
                                const Text("วันที่ 29/03/2022",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            const Text("วันหยุดสงกรานต์",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black),),
                            const Text("หยุด 3วัน วันที่ 13-15 เมษายน 2565",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black),),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // const Spacer(),
                          // const Spacer(),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              // margin: EdgeInsets.all(10),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: Colors.grey.shade500
                                // ),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    primary: Colors.deepPurpleAccent,
                                    splashFactory: NoSplash.splashFactory
                                    // minimumSize: Size(width, 100),
                                  ),
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailNewsPublicPage()));
                                  },
                                  child: Text('ดูเพิ่มเติม...')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white)
                ),
              ),
              const SizedBox(height: 20,),
              Card(
                child: Container(
                  width: double.infinity,
                  // height: 150,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 0),
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey.shade800,
                                    size: 50,),
                                  radius: 35,
                                  backgroundColor: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                const Text("ผู้จัดการระบบ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black),),
                                const Text("วันที่ 05/03/2022",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            const Text("วันหยุดประจำปี 2565",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black),),
                            const Text("บริษัทขอประกาศวันหยุดประจำบริษัท ปี2565 เพื่อแจ้งให้กับพนักงานได้รับทราบพร้อมกันทุกคน",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black),),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // const Spacer(),
                          // const Spacer(),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              // margin: EdgeInsets.all(10),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: Colors.grey.shade500
                                // ),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      primary: Colors.deepPurpleAccent,
                                      splashFactory: NoSplash.splashFactory
                                    // minimumSize: Size(width, 100),
                                  ),
                                  onPressed: (){},
                                  child: Text('ดูเพิ่มเติม...')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white)
                ),
              )
            ],
          ),
        ),
      )
          : const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 5,)
        )
    );
  }
}
