import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notepad/Utility/Utility.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:share_plus/share_plus.dart';

class Screenshot_Share extends StatefulWidget {
  final String title;
  final String des;
  final String bytes;
  const Screenshot_Share({Key? key, required this.title, required this.des, required this.bytes}) : super(key: key);

  @override
  State<Screenshot_Share> createState() => _Screenshot_ShareState();
}

class _Screenshot_ShareState extends State<Screenshot_Share> {

  GlobalKey previewContainer = new GlobalKey();
  int originalSize = 800;
  Image? _image;


  String title = '';
  String des = '';
  String text = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title= widget.title;
    des = widget.des;
    text = title  + '\n'+des;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(

        ),
        title: const Text('Share Preview'),

      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.1,
          color: Colors.grey.shade300,
          child: Center(
            child: IconButton(
              onPressed: (){
                ShareFilesAndScreenshotWidgets().shareScreenshot(
                  previewContainer,
                  originalSize,
                  "Title",
                  "Name.png",
                  "image/png",
                );}, icon: Icon(Icons.share,color: Colors.green,),
            ),
          ),
        ),
      ),

      body:   SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RepaintBoundary(
                key: previewContainer,
                child:Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        // height: MediaQuery.of(context).size.height * 0.1,
                          child: Text(text, style: TextStyle(fontSize: 25),)),

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Builder(builder: (BuildContext){
                          return Utility.imageFromBase64String(widget.bytes);
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),


    );
  }



}



