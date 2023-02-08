import 'dart:io';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notepad/home_screen.dart';
import 'package:notepad/share_preview.dart';
import 'package:notepad/test%202.dart';
import 'package:notepad/test%20save.dart';
import 'package:notepad/test.dart';
import 'Utility/Utility.dart';
import 'Utility/db_helper.dart';
import 'Utility/notes_model.dart';

class Note_screen extends StatefulWidget {
  final int id, idForNotf;
  var bytes;
 final String title, description, time;
   Note_screen({Key? key,
     required this.idForNotf,
     required this.id,
     required this.bytes,
     required this.time,
     required this.description,
     required this.title})
       : super(key: key);

  @override
  State<Note_screen> createState() => _Note_screenState();
}

class _Note_screenState extends State<Note_screen> {
  String now = DateFormat.yMMMMd().add_Hms().format(DateTime.now());
  DateTime selectedDate = DateTime.now();
  DateTime fullDate = DateTime.now();

  Future<DateTime> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: selectedDate,
        lastDate: DateTime(2100));
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );
      if (time != null) {
        setState(() {
          fullDate = DateTimeField.combine(date, time);
        });
        //TODO
        //schedule a notification

        await _notificationService.scheduleNotifications(
            id: widget.idForNotf,
            title: widget.title,
            body: widget.description,
            time: fullDate);
      }
      return DateTimeField.combine(date, time);
    } else {
      return selectedDate;
    }
  }
  final NotificationService _notificationService = NotificationService();

  var id = DateTime.now().millisecondsSinceEpoch.toString();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  late bool save;
  @override
  DBhelper? dbHelper = DBhelper();

  File? _image;
  var pickedFile;
  var byte = 'R0lGODlhAQABAAAAACwAAAAAAQABAAA=';
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
    print(titlecontroller);

    descriptioncontroller.text = widget.description;
    print(descriptioncontroller);
    save = true;

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        actions: [
          titlecontroller.text.isEmpty   && descriptioncontroller.text.isEmpty ?
          Icon(Icons.share, color: Colors.grey.shade700,) :
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Screenshot_Share(title: widget.title, des: widget.description, bytes: byte ?? widget.bytes  ,)));
          }, icon: const Icon(Icons.share)) ,


          save  ?
          IconButton(onPressed: () {
            dbHelper!.delete(widget.id).then((value) {
              final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text('Deleted'.toString()), duration: const Duration(seconds: 1));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
            });
            },
            icon: Icon(Icons.delete),)
              :
          IconButton(onPressed: () {
            dbHelper!.delete(widget.id).then((value) {
              dbHelper!.insert(
                  Note(
                      id: int.parse(id),
                      title: titlecontroller.text.isEmpty ? '' : titlecontroller.text,
                      time: now,
                      description: descriptioncontroller.text, picture:byte ?? widget.bytes )
              ).then((value){
                const snackBar = SnackBar(backgroundColor: Colors.green,content: Text('Saved'), duration: Duration(seconds: 1),);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
                setState(() {

                });
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }).onError((error, stackTrace) {
                print("error$error");
                final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text(error.toString()), duration: const Duration(seconds: 1));

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            });


          },
            icon: const Icon(Icons.save_alt),)
        ],
      ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.1,
              color: Colors.grey.shade300,
              child: Center(
                child: IconButton(
                  onPressed: (){
                    _selectDate(context);
                    }, icon: Icon(Icons.add_alert,color: Colors.green,),
                ),
              ),
            ),
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
                  child: Column(
                    children: [
                      Text(widget.time, style: const TextStyle(fontSize: 25),),
                      Text('')
                    ],
                  ),
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
                const Divider(),
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
                      hintStyle: TextStyle( color: Colors.grey,),
                      border: InputBorder.none
                  ),
                ),
               // Builder(builder: (BuildContext context){
               //   return Utility.imageFromBase64String(widget.bytes);
               // }),
                const Divider(),
                InkWell(
                  onTap: (){
                    getGalleryImage();
                    setState(() {
                      save = false;
                    });
                  },
                  child: widget.bytes != null ? Center(
                    child: SizedBox(
                      height: 400,
                      width: 400,
                      // child: Image.asset(bytes),
                      child:_image!= null ? Image.file(_image!.absolute) : Builder(builder: (BuildContext context){
                        return Utility.imageFromBase64String(widget.bytes);
                      }),

                      // return Utility.imageFromBase64String(photo.photoName ?? "");

                    ),
                  ) : Center(
                    child: SizedBox(
                      height: 400,
                      width: 400,

                      // child: Image.asset(bytes),
                      child:_image!= null ? Image.file(_image!.absolute) : const Icon(Icons.image),
                      // return Utility.imageFromBase64String(photo.photoName ?? "");

                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  MyHomePage()));
          },
          backgroundColor: Colors.grey,
          child: const Icon(Icons.add, size: 40,
          ),
        )
    );
  }
}

