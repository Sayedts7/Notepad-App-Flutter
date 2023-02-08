import 'dart:io';
import 'dart:ui';

import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notepad/Utility/db_helper.dart';
import 'package:notepad/Utility/notes_model.dart';
import 'package:intl/intl.dart';
import 'package:notepad/test%202.dart';
import 'Utility/Utility.dart';
import 'home_screen.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  DateTime selectedDate = DateTime.now();
  DateTime fullDate = DateTime.now();
  String now = DateFormat.yMMMMd().add_Hms().format(DateTime.now());

  int id = DateTime.now().millisecondsSinceEpoch;
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
          final snackBar = SnackBar(backgroundColor: Colors.green ,content: Text('Reminder added'), duration: Duration(seconds: 1));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        //TODO
        //schedule a notification

        await _notificationService.scheduleNotifications(
            id: id,
            title: titlecontroller.text!,
            body: descriptioncontroller.text!,
            time: fullDate);
      }
      return DateTimeField.combine(date, time);
    } else {
      return selectedDate;
    }
  }
  final NotificationService _notificationService = NotificationService();
  var image ;
  var bytes;


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
        title:  Text('Note'),
        actions: [
          IconButton(onPressed: () {
            dbHelper!.insert(
            Note(
                id: id,
                title:  titlecontroller.text ,

                time: now,
                description: descriptioncontroller.text,
                picture: bytes ?? null)
          ).then((value){

                const snackBar = SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Saved'),
                  duration: Duration(seconds: 1),);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                    builder: (context)=>HomeScreen()));
                setState(() {
                });
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }).onError((error, stackTrace) {
              print("error"+error.toString());
              final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text(error.toString()), duration: const Duration(seconds: 1));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          }, icon: Icon(Icons.save_alt),)
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
                }, icon: const Icon(Icons.add_alert,color: Colors.green,),
            ),
          ),
        ),
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
                  child: Text(now, style: const TextStyle(fontSize: 15),),
                ),

                TextFormField(
                  minLines: 1,
                  maxLines: 1000,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  controller: titlecontroller,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey,fontWeight: FontWeight.bold),
                      border: InputBorder.none
                  ),
                ),

                const Divider(),

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
    );
  }
}
