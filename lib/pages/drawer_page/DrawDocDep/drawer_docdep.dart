import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:index/api/url.dart';
import 'package:page_transition/page_transition.dart';
import '../../widjet/popupAlert.dart';
import 'drawer_docdep_folder.dart';

class DocDepPage extends StatefulWidget {
  const DocDepPage({Key? key}) : super(key: key);

  @override
  State<DocDepPage> createState() => _DocDepPageState();
}

class _DocDepPageState extends State<DocDepPage> {
  bool loading = false;
  List dataDoc = [];

  Future<Null> getdataFolder() async{
    String url = pathurl.docdep;
    final response = await get(
        Uri.parse(url),
        // headers: {"Authorization": "Bearer $token"}
    );
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        dataDoc = data["data"];
      });
    }else if(response.statusCode == 401){
      popup().sessionexpire(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getdataFolder();
    Future.delayed(const Duration(seconds: 1), (){
      setState(() {
        loading = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('เอกสารแผนก'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
          ),
        ),
      ),
      body: loading ? SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
          child: buildGridView(),
        ),
      )
      :const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
          strokeWidth: 5
        )
      )
    );
  }


  Widget buildGridView() => GridView.builder(
    gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 3/2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
    ),
    // padding: const EdgeInsets.all(5),
    shrinkWrap: true,
    controller: ScrollController(),
    itemCount: dataDoc.length,
    itemBuilder: (context, i) {
      return LisCom(dataDoc[i]);
      // return Text("${shoeList[i].imgPath}");
    },
  );

  Widget LisCom(item) {
    var name = item['name'];
    var id = item['ID'];
    var sec = item['sec'];
    var total = item['total'];

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
            PageTransition(
              child: DocDepNamePage(name: '$name'),
              type: PageTransitionType.rightToLeft,
              alignment: Alignment.bottomCenter,
              duration: Duration(milliseconds: 600),
              reverseDuration: Duration(milliseconds: 600),
            )
        );
      },
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // const SizedBox(height: 10),
              Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  alignment: Alignment.center,
                  child: Image.asset('images/folder.png',width: 50,),
                ),
              ),
              Expanded(
                  flex: 0,
                  child: Container(
                    child: Text(
                      "$name",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  )
              )

            ],
          ),
        ),
      ),
    );
  }

}
