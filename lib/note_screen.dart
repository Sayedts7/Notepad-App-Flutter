import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepad/home_screen.dart';
import 'package:notepad/share_screen.dart';
import 'package:notepad/share_preview.dart';

import 'Utility/Utility.dart';
import 'Utility/db_helper.dart';
import 'Utility/notes_model.dart';

class Note_screen extends StatefulWidget {
  final int id;
  var bytes;
 final String title, description, time;
   Note_screen({Key? key, required this.id,required this.bytes, required this.time, required this.description, required this.title}) : super(key: key);

  @override
  State<Note_screen> createState() => _Note_screenState();
}

class _Note_screenState extends State<Note_screen> {

  var id = DateTime.now().millisecondsSinceEpoch.toString();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  late bool save;
  @override
  DBhelper? dbHelper = DBhelper();

  File? _image;
  var pickedFile;
  var byte;
  final picker = ImagePicker();
  Future getGalleryImage()async{
    pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if(pickedFile != null){

        _image = File(pickedFile.path);
      print(byte);
      }else{
      print('No image selected');
      }
    });
    setState(() async{
      byte = Utility.base64String(await _image!.readAsBytes());

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titlecontroller.text = widget.title;
    descriptioncontroller.text = widget.description;
    save = true;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Screenshot_Share(title: widget.title, des: widget.description, bytes: widget.bytes,)));
          }, icon: Icon(Icons.share)),

          save  ?
          IconButton(onPressed: () {
            dbHelper!.delete(widget.id).then((value) {
              final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text('Deleted'.toString()), duration: Duration(seconds: 1));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
            });
            }, icon: Icon(Icons.delete),)
              :
          IconButton(onPressed: () {
            dbHelper!.delete(widget.id).then((value) {
              dbHelper!.insert(
                  Note(
                      id: int.parse(id),
                      title: titlecontroller.text.isEmpty ? '' : titlecontroller.text,
                      time: DateTime.now().toString(),
                      description: descriptioncontroller.text, picture:byte!= null ?byte : widget.bytes )
              ).then((value){
                const snackBar = SnackBar(backgroundColor: Colors.green,content: Text('Saved'), duration: Duration(seconds: 1),);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                setState(() {

                });
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }).onError((error, stackTrace) {
                print("error$error");
                final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text(error.toString()), duration: const Duration(seconds: 1));

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            });


          }, icon: const Icon(Icons.save_alt),)
        ],
      ),

      body: SingleChildScrollView(
        child: SafeArea(
          child:  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(widget.time, style: const TextStyle(fontSize: 15),),
                ),

                TextFormField(
                  onTap: (){
                    setState(() {
                      save = false;
                    });
                  },
                  controller: titlecontroller,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                 // initialValue: widget.title,
                  minLines: 1,
                  maxLines: 10000,

                  decoration: const InputDecoration(
                      hintText: 'title',
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey,fontWeight: FontWeight.bold),
                      border: InputBorder.none
                  ),
                ),
                Divider(),

                TextFormField(
                  controller: descriptioncontroller,
                  onTap: (){
                    setState(() {
                      save = false;
                    });
                  },

                  minLines: 1,
                  maxLines: 10000,

                  //style: const TextStyle( fontWeight: FontWeight.bold),
                  //initialValue: widget.description,

                  decoration: const InputDecoration(
                    hintText: 'Note something down',
                      hintStyle: TextStyle( color: Colors.black,),
                      border: InputBorder.none
                  ),
                ),
               // Builder(builder: (BuildContext context){
               //   return Utility.imageFromBase64String(widget.bytes);
               // }),
                Divider(),
                InkWell(
                  onTap: (){
                    getGalleryImage();
                    setState(() {
                      save = false;
                    });
                  },
                  child: widget.bytes != null ? Center(
                    child: Container(
                      height: 400,
                      width: 400,
                      // child: Image.asset(bytes),
                      child:_image!= null ? Image.file(_image!.absolute) : Builder(builder: (BuildContext context){
                        return Utility.imageFromBase64String(widget.bytes);
                      }),

                      // return Utility.imageFromBase64String(photo.photoName ?? "");

                    ),
                  ) : Center(
                    child: Container(
                      height: 400,
                      width: 400,

                      // child: Image.asset(bytes),
                      child:_image!= null ? Image.file(_image!.absolute) : Icon(Icons.image),
                      // return Utility.imageFromBase64String(photo.photoName ?? "");

                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screenshot_Share(title: widget.title , des: widget.description, bytes: widget.bytes, )));
        //   },
        //   backgroundColor: Colors.grey,
        //   child: Icon(Icons.add, size: 40,
        //   ),
        // )
    );
  }
}
