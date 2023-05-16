import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:index/pages/widjet/myAlertLocation.dart';
import 'package:path/path.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;

  const PDFViewerPage({Key? key, required this.file,}) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  bool loading = false;
  PDFViewController? controller;
  int pages = 0;
  int indexPage = 0;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1),(){
      setState(() {
        loading = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    final text = '${indexPage + 1} of $pages';

    return  Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(name),
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
        actions: pages >= 0
            ? [
          Center(child: Text(text)),
          IconButton(
            icon: Icon(Icons.chevron_left, size: 32),
            onPressed: () {
              final page = indexPage == 0 ? pages : indexPage - 1;
              controller?.setPage(page);
            },
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, size: 32),
            onPressed: () {
              final page = indexPage == pages - 1 ? 0 : indexPage + 1;
              controller?.setPage(page);
            },
          ),
        ]
            : null,
      ),
      body: loading ? PDFView(
        // nightMode: true,
        filePath: widget.file.path,
        // autoSpacing: true,
        swipeHorizontal: true,
        // pageSnap: false,
        // pageFling: false,
        onRender: (pages) => setState(() => this.pages = pages!),
        onViewCreated: (controller) =>
            setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) =>
            setState(() => this.indexPage = indexPage!),
      ) : const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
            strokeWidth: 5,
          )
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   elevation: 4.0,
      //   icon: const Icon(Icons.add),
      //   label: const Text('Add a task'),
      //   onPressed: () {},
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.check_circle_outline),
              onPressed: () {
                MyDialog().alertJobWork(context);
              },
              iconSize: 100,
              color: Colors.green,
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                MyDialog().alertJobWorkCancle(context);
              },
              iconSize: 100,
              color: Colors.red,
            )
          ],
        ),
      ),
    );

  }
}