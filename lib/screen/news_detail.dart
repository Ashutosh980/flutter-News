import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamasha/state/state_management.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyNewsDetails extends StatefulWidget{
  @override
  _MyNewsDetails createState() =>new _MyNewsDetails();

}
class _MyNewsDetails extends State<MyNewsDetails>{
  double progress=0;
  final Completer<WebViewController> _controller=Completer<WebViewController>();

@override
  void initState() {
  if(Platform.isAndroid)WebView.platform=SurfaceAndroidWebView();
    super.initState();
  }

 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color(0xFFA51234)));
 return MaterialApp(debugShowCheckedModeBanner: false,
   home: Scaffold(
     body: SafeArea(
       child: Container(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Row(
               children: [
                 IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,), onPressed: ()=> Navigator.of(context).pop(),
                 alignment: Alignment.topLeft,)
               ],
             ),
             Container(
               padding: const EdgeInsets.all(8.0),
               child: progress<1.0?LinearProgressIndicator(value: progress,):Container(),
             ),
             Expanded(child: WebView(
               initialUrl: context.read(urlState).state,
               javascriptMode: JavascriptMode.unrestricted,
               onWebViewCreated: (controller){
                 _controller.complete(controller);
               },
             ))
           ],
         ),
       ),
     ),
   ),
 );
  }
  
}