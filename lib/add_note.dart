import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepad/Utility/db_helper.dart';
import 'package:notepad/Utility/notes_model.dart';

import 'Utility/Utility.dart';
import 'home_screen.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  var image ;
  var bytes;

  var id = DateTime.now().millisecondsSinceEpoch.toString();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  File? _image;
  // var pickedFile;
  final picker = ImagePicker();
  Future getGalleryImage()async{
     final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
     setState(() {
       if(pickedFile != null){
         _image = File(pickedFile!.path);
       //   print('oooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
       //   print(_image.toString());
       // print(bytes);
       }else{
       print('No image selected');
       }
     });
     setState(() async{
         bytes = Utility.base64String(await _image!.readAsBytes());

     });



  }

  DBhelper? dbHelper = DBhelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        actions: [
          IconButton(onPressed: () {
            dbHelper!.insert(
            Note(
                id: int.parse(id),
                title: titlecontroller.text.isEmpty ? '' : titlecontroller.text,
                time: DateTime.now().toString(),
                description: descriptioncontroller.text, picture: bytes ?? null)
          ).then((value){
                final snackBar = SnackBar(backgroundColor: Colors.green,content: Text('Saved'), duration: Duration(seconds: 1),);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                setState(() {

                });
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }).onError((error, stackTrace) {
              print("error"+error.toString());
              final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text(error.toString()), duration: Duration(seconds: 1));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          }, icon: Icon(Icons.save_alt),)
        ],
      ),

      body: SafeArea( 
        child:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(DateTime.now().toString(), style: TextStyle(fontSize: 15),),
                ),

                TextFormField(
                  minLines: 1,
                  maxLines: 1000,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  controller: titlecontroller,
                  decoration: InputDecoration(
                    hintText: 'Title',
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey,fontWeight: FontWeight.bold),
                      border: InputBorder.none
                  ),
                ),

                Divider(),

                TextFormField(
                  minLines: 1,
                  maxLines: 1000,
                  controller: descriptioncontroller,
                  decoration: const InputDecoration(
                      hintStyle: TextStyle( color: Colors.grey,),
                      hintText: 'Note something down',
                    border: InputBorder.none
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: (){
                    getGalleryImage();
                  },
                  child: Center(
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
    );
  }
}
