// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:share_plus/share_plus.dart';
//
// class Share_note extends StatefulWidget {
//   final String title;
//   final String des;
//   const Share_note({Key? key, required this.title, required this.des}) : super(key: key);
//
//   @override
//   State<Share_note> createState() => _Share_noteState();
// }
//
// class _Share_noteState extends State<Share_note> {
//   String title = '';
//   String des = '';
//   String text = '';
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     title= widget.title;
//     des = widget.des;
//      text = 'Title: '+title  + '\nDescription: '+ des;
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Share Preview'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//            Container(
//                height: MediaQuery.of(context).size.height * 0.77,
//                child: Text(text, style: TextStyle(fontSize: 30),)),
//
//
//
//
//             Builder(
//               builder: (BuildContext context) {
//                 return Center(
//                   child: ElevatedButton(
//
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Theme.of(context).colorScheme.onPrimary,
//                       backgroundColor: Theme.of(context).colorScheme.primary,
//                     ),
//
//                     onPressed:  () => _onShareWithResult(context),
//                     child: const Text('Share With Result'),
//                   ),
//                 );
//               },
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   void _onShareWithResult(BuildContext context) async {
//     final box = context.findRenderObject() as RenderBox?;
//     final scaffoldMessenger = ScaffoldMessenger.of(context);
//     ShareResult shareResult;
//
//       shareResult = await Share.shareWithResult(text,
//           sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
//
//     scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
//   }
//
//
//   SnackBar getResultSnackBar(ShareResult result) {
//     return SnackBar(
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Share result: ${result.status}"),
//           if (result.status == ShareResultStatus.success)
//             Text("Shared to: ${result.raw}")
//         ],
//       ),
//     );
//   }
// }
//
//
//
