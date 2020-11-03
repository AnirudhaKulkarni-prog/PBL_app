import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
void main() {
  runApp(
    MaterialApp(
      home:Classify(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class Classify extends StatefulWidget {
  @override
  Classify_State createState() => Classify_State();
}

class Classify_State extends State<Classify> {
  File our_image;
  bool isloaded=false;
  List ls;
  String name;
  String accuracy;

  for_gallery_image()
  async {
    var temp=await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      our_image=File(temp.path);
      isloaded=true;
      applymodeltoimage(our_image);

    });
  }
  load_model()
  async {
    var result=await Tflite.loadModel(labels:"assets/labels.txt",model:"assets/model_unquant.tflite");
    print("Our result ${result}");
  }
  applymodeltoimage(File file)
  async {
    var res=await Tflite.runModelOnImage(
      path:file.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5, );
      setState(() {
        ls=res;
        print(ls);
        String str=ls[0]['label'];
        name=str.substring(0);
        accuracy=ls!=null?(ls[0]['confidence']*100).toString().substring(0,2)+"%":" ";


      });

  }
  
@override
  void initState() {
    super.initState();
    load_model().then((val){
      setState(() {
        
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Image classification")),
        body:Container(
          child: Column(
            children: <Widget>[
              SizedBox(height:20),
              isloaded?Center(
                child: Container(
                  height:250,
                  width:250,
                  decoration:BoxDecoration(
                    image: DecorationImage(image: FileImage(File(our_image.path)),fit: BoxFit.contain),
                 
                    

                  )
                ),
              ):Container(),
              SizedBox(height:10),
              name!=null?Text("Name:-${name}\nConfidence:-${accuracy}"):Container(),
            ],


          ),

        ),
      floatingActionButton: FloatingActionButton(onPressed:(){
        for_gallery_image();
      },
      child: Icon(Icons.add_a_photo), ),  
      );
    
  }
}