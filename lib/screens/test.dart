import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TestFile extends StatefulWidget {
  const TestFile({Key? key}) : super(key: key);

  @override
  State<TestFile> createState() => _TestFileState();
}

class _TestFileState extends State<TestFile> {

  String url = "https://firebasestorage.googleapis.com/v0/b/pokedex-dfadf.appspot.com/o/drag_level%2Fgoku_9%2F0.png?alt=media&token=2587f5e4-996f-4d97-a47e-e0d87afe61fc";

  Uint8List? image;

  urlToBase() async{
    image = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
    setState(() {});
    print("Image: $image");
  }

  @override
  void initState() {
    super.initState();
    urlToBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            image != null ?
            Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: Image.memory(image!,fit: BoxFit.contain,)) :
            Center(child: CircularProgressIndicator()),

          ],
        ),
      ),
    );
  }
}
