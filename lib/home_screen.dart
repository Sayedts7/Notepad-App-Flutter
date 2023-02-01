import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notepad/add_note.dart';
import 'package:notepad/note_screen.dart';
import 'package:notepad/theme_change_provider.dart';
import 'package:provider/provider.dart';

import 'db_helper.dart';
import 'note_provider.dart';
import 'notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController searchcontroller = TextEditingController();
  DBhelper? dbHelper = DBhelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () { setState(() {

    });});
  }
  @override
  Widget build(BuildContext context) {
    final notes  = Provider.of<NoteProvider>(context);
    final themechanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      appBar: AppBar(
        title:  const Text('Notepad', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
        actions: [
          Consumer(builder: (context, value, child){
            return PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context)=>[

                  const PopupMenuItem(
                    enabled: false,
                      value: 1,
                      child: Text('Theme Mode', style: TextStyle(color: Colors.black),)),

                  PopupMenuItem(
                    enabled: themechanger.enabled ? true : false,
                    onTap: (){
                      themechanger.setTheme(ThemeMode.dark);
                      themechanger.setenable(false);

                    },
                      value: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Dark Mode'),
                          Icon(Icons.dark_mode),

                        ],
                      )),
                  PopupMenuItem(
                      enabled: themechanger.enabled ? false : true,

                      value: 3,
                      onTap: (){
                        themechanger.setTheme(ThemeMode.light);
                        themechanger.setenable(true);

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Light Mode'),
                          Icon(Icons.light_mode),
                        ],
                      )),
                  PopupMenuItem(
                      value: 4,
                      onTap: (){
                        themechanger.setTheme(ThemeMode.system);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: const [
                          Text('System Mode'),
                          Icon(Icons.dark_mode),

                        ],
                      )),
                ]);

          }),
          


        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column (
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  height: 40,
                  child: TextFormField(
                    onChanged: (value){
                      setState(() {

                      });
                    },
                    controller: searchcontroller,

                    decoration:  InputDecoration(
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      contentPadding: const EdgeInsets.all(10),
                      prefixIcon: const Icon(Icons.search, color: Colors.black,),
                      hintText: 'Search Notes',
                      hintStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.grey.shade300
                          ),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      enabledBorder  : OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey.shade300
                            ),
                            borderRadius: BorderRadius.circular(30)
                        )


                    ),
                  ),
                ),
              ),

            FutureBuilder(
                future: notes.getData(),
                builder: (context, AsyncSnapshot<List<Note>> snapshot){

                  if(snapshot.hasData){

                    return Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            reverse: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index){
                                String title = snapshot.data![index].title.toString();
                                String des = snapshot.data![index].description.toString();
                                String all = title + des;
                                var id = snapshot.data![index].id;
                                if(searchcontroller.text.isEmpty)
                                  {
                                    if(index % 2 == 0){
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) =>
                                                  Note_screen(id:
                                                  int.parse(snapshot.data![index].id.toString()),
                                                      time: snapshot.data![index].time
                                                          .toString(),
                                                      description: snapshot.data![index]
                                                          .description.toString(),
                                                      title: snapshot.data![index].title
                                                          .toString())));
                                        },
                                        child: Dismissible(

                                          key: UniqueKey(),
                                          onDismissed: (direction) {

                                            dbHelper!.delete(id!);


                                          },
                                          background: Container(
                                            color: Colors.grey,
                                            child: Icon(Icons.delete),
                                          ),
                                          child: Card(
                                            color: Colors.red.shade300,
                                            child: Container(
                                              height: MediaQuery.of(context).size.height * 0.13,
                                              width:  MediaQuery.of(context).size.height * 1,
                                              decoration: BoxDecoration(
                                                  color: Colors.red.shade300,
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    Container(
                                                      height: MediaQuery.of(context).size.height * 0.03,

                                                      child: Text(
                                                        overflow: TextOverflow.ellipsis,

                                                        snapshot.data![index].title.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                    ),
                                                    Container(
                                                      height: MediaQuery.of(context).size.height * 0.03,
                                                      child: Text(
                                                        overflow: TextOverflow.fade,

                                                        snapshot.data![index].description.toString(),  style: TextStyle(fontSize: 16, ),),
                                                    ),
                                                    Text(snapshot.data![index].time.toString(),  style: TextStyle(color: Colors.black45 ),),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    else{
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) =>
                                                  Note_screen(id:
                                                  int.parse(snapshot.data![index].id.toString()),
                                                      time: snapshot.data![index].time
                                                          .toString(),
                                                      description: snapshot.data![index]
                                                          .description.toString(),
                                                      title: snapshot.data![index].title
                                                          .toString())));
                                        },
                                        child: Dismissible(
                                          key: UniqueKey(),
                                          onDismissed: (direction) {

                                            dbHelper!.delete(id!);


                                          },
                                          background: Container(
                                            color: Colors.grey,
                                            child: Icon(Icons.delete),
                                          ),
                                          child: Card(
                                            color: Colors.green.shade300,
                                            child: Container(
                                              height: MediaQuery.of(context).size.height * 0.13,
                                              width:  MediaQuery.of(context).size.height * 1,
                                              decoration: BoxDecoration(
                                                  color: Colors.green.shade300,
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    Container(
                                                      height: MediaQuery.of(context).size.height * 0.03,

                                                      child: Text(
                                                        overflow: TextOverflow.ellipsis,

                                                        snapshot.data![index].title.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                    ),
                                                    Container(
                                                      height: MediaQuery.of(context).size.height * 0.03,

                                                      child: Text(
                                                        overflow: TextOverflow.ellipsis,

                                                        snapshot.data![index].description.toString(),  style: TextStyle(fontSize: 16, ),),
                                                    ),
                                                    Text(snapshot.data![index].time.toString(),  style: TextStyle(color: Colors.black45 ),),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                  }else if (all.toLowerCase().contains(searchcontroller.text.toLowerCase())){
                                  if(index % 2 == 0){
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>
                                                Note_screen(id:
                                                int.parse(snapshot.data![index].id.toString()),
                                                    time: snapshot.data![index].time
                                                        .toString(),
                                                    description: snapshot.data![index]
                                                        .description.toString(),
                                                    title: snapshot.data![index].title
                                                        .toString())));
                                      },
                                      child: Dismissible(
                                        key: UniqueKey(),
                                        onDismissed: (direction) {

                                          dbHelper!.delete(id!);


                                        },
                                        background: Container(
                                          color: Colors.grey,
                                          child: Icon(Icons.delete),
                                        ),
                                        child: Card(
                                          color: Colors.red.shade300,
                                          child: Container(
                                            height: MediaQuery.of(context).size.height * 0.13,
                                            width:  MediaQuery.of(context).size.height * 1,
                                            decoration: BoxDecoration(
                                                color: Colors.red.shade300,
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Container(
                                                    height: MediaQuery.of(context).size.height * 0.03,
                                                    child: Text(
                                                      overflow: TextOverflow.ellipsis,

                                                      snapshot.data![index].title.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                  ),
                                                  Container(
                                                    height: MediaQuery.of(context).size.height * 0.03,
                                                    child: Text(
                                                      overflow: TextOverflow.fade,

                                                      snapshot.data![index].description.toString(),  style: TextStyle(fontSize: 16, ),),
                                                  ),
                                                  Text(snapshot.data![index].time.toString(),  style: TextStyle(color: Colors.black45 ),),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  else{
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) =>
                                                Note_screen(id:
                                                int.parse(snapshot.data![index].id.toString()),
                                                    time: snapshot.data![index].time
                                                        .toString(),
                                                    description: snapshot.data![index]
                                                        .description.toString(),
                                                    title: snapshot.data![index].title
                                                        .toString())));
                                      },
                                      child: Dismissible(
                                        key: UniqueKey(),
                                        onDismissed: (direction) {

                                          dbHelper!.delete(id!);


                                        },
                                        background: Container(
                                          color: Colors.grey,
                                          child: Icon(Icons.delete),
                                        ),
                                        child: Card(
                                          color: Colors.green.shade300,
                                          child: Container(
                                            height: MediaQuery.of(context).size.height * 0.13,
                                            width:  MediaQuery.of(context).size.height * 1,
                                            decoration: BoxDecoration(
                                                color: Colors.green.shade300,
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Container(
                                                    height: MediaQuery.of(context).size.height * 0.03,

                                                    child: Text(
                                                      overflow: TextOverflow.ellipsis,

                                                      snapshot.data![index].title.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                                  ),
                                                  Container(
                                                    height: MediaQuery.of(context).size.height * 0.03,

                                                    child: Text(
                                                      overflow: TextOverflow.ellipsis,

                                                      snapshot.data![index].description.toString(),  style: TextStyle(fontSize: 16, ),),
                                                  ),
                                                  Text(snapshot.data![index].time.toString(),  style: TextStyle(color: Colors.black45 ),),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }

                                return Container();

                              }),
                        ),
                      ),
                    );
                  }
                   return Center(child: CircularProgressIndicator());

                })

            ],
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddNote()));
          },
          backgroundColor: Colors.grey,
          child: Icon(Icons.add, size: 40,
              ),
        )
    );
  }
}
