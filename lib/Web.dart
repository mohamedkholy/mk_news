import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Web extends StatefulWidget {
  String url;
  String title;

  Web(this.title,this.url, {super.key});
  @override
  State<Web> createState() {
    return _WebState();
  }
}

class _WebState extends State<Web> {
  double progress = 0;
  late WebViewController controller;

  @override
  void initState() {
   controller= WebViewController()
    ..setBackgroundColor(Colors.white)
    ..setNavigationDelegate(
    NavigationDelegate(
    onProgress: (progress) {
    setState(() {
    this.progress=progress/100;
    });
    },
    )
    )
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            progress < 1?SizedBox(height: 3,child: LinearProgressIndicator(color: Colors.red,value: progress,),):SizedBox(),
            Expanded(
              child: WebViewWidget(
                controller: controller,
              ),
            )
          ],
        ),
      ),
    );
  }
}
