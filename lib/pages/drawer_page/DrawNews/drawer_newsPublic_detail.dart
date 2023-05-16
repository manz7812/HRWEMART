import 'package:flutter/material.dart';

class DetailNewsPublicPage extends StatefulWidget {
  const DetailNewsPublicPage({Key? key}) : super(key: key);

  @override
  State<DetailNewsPublicPage> createState() => _DetailNewsPublicPageState();
}

class _DetailNewsPublicPageState extends State<DetailNewsPublicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('รายละเอียดข่าวสาร'),
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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.transparent)
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("วันหยุดสงกรานต์",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black),),
                      SizedBox(height: 30),
                      Text("หยุด 3วัน วันที่ 13-15 เมษายน 2565\n16 เมษายน 2565 ทำงานปกติ",
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black),),
                      SizedBox(height: 30),
                      Image(
                        image: AssetImage('images/55841.png'),
                        width: 400,
                        height: 250,
                        // fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
