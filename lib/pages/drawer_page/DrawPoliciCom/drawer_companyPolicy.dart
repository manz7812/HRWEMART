import 'package:flutter/material.dart';
import 'package:index/pages/widjet/doc_Card.dart';


class CompanyPolicyPage extends StatefulWidget {
  final String title;
  const CompanyPolicyPage({Key? key, required this.title}) : super(key: key);

  @override
  State<CompanyPolicyPage> createState() => _CompanyPolicyPageState();
}

class _CompanyPolicyPageState extends State<CompanyPolicyPage> {
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
            // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
          ),
        ),
      ),
      body: loading ? SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: Column(
            children: <Widget>[
              nayoby().show_nayoby1(context),
              const SizedBox(height: 10,),
              nayoby().show_nayoby1(context),
              const SizedBox(height: 10,),
              nayoby().show_nayoby1(context),
            ],
          ),
        ),
      ): const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            strokeWidth: 5,)
      )
    );
  }
}
