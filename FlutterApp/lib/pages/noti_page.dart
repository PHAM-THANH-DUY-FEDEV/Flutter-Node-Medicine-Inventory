// import 'package:flutter/material.dart';

// class NotiPage extends StatefulWidget {
//   final VoidCallback onLogout;
//   const NotiPage({super.key, required this.onLogout});

//   @override
//   State<NotiPage> createState() => _NotiPageState();
// }

// class _NotiPageState extends State<NotiPage> {
//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Thông báo'),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout, color: Colors.white),
//             onPressed: widget.onLogout,
//           ),
//         ],
//       ),
//       body:
//           message != null
//               ? Column(
//                 children: [
//                   Text(message.notification?.title ?? ''),
//                   Text(message.notification?.body ?? ''),
//                   Text(message.notification?.body ?? ''),
//                 ],
//               )
//               : Center(child: Text('Không có thông báo nào.')),
//     );
//   }
// }
