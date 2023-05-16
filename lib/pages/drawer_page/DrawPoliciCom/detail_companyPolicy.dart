import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailCompanyPolicyPage extends StatefulWidget {
  const DetailCompanyPolicyPage({Key? key}) : super(key: key);

  @override
  State<DetailCompanyPolicyPage> createState() => _DetailCompanyPolicyPageState();
}

class _DetailCompanyPolicyPageState extends State<DetailCompanyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('นโยบายบริษัท'),
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
            // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Card(
                elevation: 3,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.white)
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        // padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                        alignment: Alignment.center,
                        child: const Text(
                          "มาตราโควิด-19",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        // padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "ให้ปฎิบัติตามดังนี้",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        // padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "รูปภาพ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                          child: Image(image: AssetImage('images/78.jpg'),))
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
