import 'package:flutter/material.dart';
import 'package:notepad/db_helper.dart';
import 'package:notepad/notes_model.dart';

import 'home_screen.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  var id = DateTime.now().millisecondsSinceEpoch.toString();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();



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
                description: descriptioncontroller.text, picture: '')
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
