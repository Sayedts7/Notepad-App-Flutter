import 'package:flutter/material.dart';
import 'package:notepad/home_screen.dart';

import 'db_helper.dart';
import 'notes_model.dart';

class Note_screen extends StatefulWidget {
  final int id;
 final String title, description, time;
  const Note_screen({Key? key, required this.id, required this.time, required this.description, required this.title}) : super(key: key);

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
          save  ?
          IconButton(onPressed: () {
            dbHelper!.delete(widget.id).then((value) {
              final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text('Deleted'.toString()), duration: Duration(seconds: 1));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
            });
          }, icon: Icon(Icons.delete),) :
          IconButton(onPressed: () {
            dbHelper!.delete(widget.id).then((value) {
              dbHelper!.insert(
                  Note(
                      id: int.parse(id),
                      title: titlecontroller.text.isEmpty ? '' : titlecontroller.text,
                      time: DateTime.now().toString(),
                      description: descriptioncontroller.text, picture: '')
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



              ],
            ),
          ),
        ),
      ),
    );
  }
}
