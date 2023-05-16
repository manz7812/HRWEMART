import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';

class WebCheckINChecKOutPage extends StatefulWidget {
  final String? link;
  const WebCheckINChecKOutPage({Key? key, required this.link}) : super(key: key);

  @override
  State<WebCheckINChecKOutPage> createState() => _WebCheckINChecKOutPageState();
}

class _WebCheckINChecKOutPageState extends State<WebCheckINChecKOutPage> {
  late WebViewController webcontroller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      // appBar: AppBar(
      //   title: const Text(""),
      //   // leading: IconButton(
      //   //   onPressed: () {
      //   //     Navigator.of(pageContext).pop();
      //   //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InsertDocLAPage(),), (route) => route.isFirst);
      //   //   },
      //   //   icon: Icon(Icons.arrow_back),
      //   // ),
      //   centerTitle: true,
      //   elevation: 0,
      //   flexibleSpace : Container(
      //     decoration: const BoxDecoration(
      //       borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
      //       // border: Border.all(width: 15, color: Colors.white),
      //       gradient:  LinearGradient(
      //         colors: [
      //           Color(0xff6200EA),
      //           Colors.white,
      //         ],
      //         begin:  FractionalOffset(0.0, 1.0),
      //         end:  FractionalOffset(1.5, 1.5),
      //       ),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.transparent,
      //           spreadRadius: 5, blurRadius: 30,
      //           offset: Offset(5, 3),
      //         ),
      //       ],
      //       // image: DecorationImage(image: NetworkImage('https://www.pngitem.com/pimgs/m/391-3918613_personal-service-platform-person-icon-circle-png-transparent.png'))
      //     ),
      //   ),
      // ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: '${widget.link}',
        onWebViewCreated: (cotroller){
          this.webcontroller=cotroller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cancel,size: 50,),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
