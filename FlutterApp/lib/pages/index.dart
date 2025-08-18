// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medication_management_app/pages/home_page.dart';
import 'package:medication_management_app/pages/bills_page.dart';
import 'package:medication_management_app/pages/noti_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medication_management_app/pages/statis_page.dart';

class IndexPage extends StatefulWidget {
  final VoidCallback onLogout;
  int? indexNum;
  IndexPage({super.key, required this.onLogout, required this.indexNum});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late List<Widget> pages = [
    HomePage(onLogout: widget.onLogout),
    BillsPage(onLogout: widget.onLogout),
    // NotiPage(onLogout: widget.onLogout),
    statisPage(onLogout: widget.onLogout),
  ];

  bool isFABVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nội dung chính (bao gồm các trang)
          pages[widget.indexNum ?? 0],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[100],
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/iconsPng/medicin.png',
              height: 30,
              width: 30,
            ),
            label: 'Thuốc',
            activeIcon: Image.asset(
              'assets/iconsPng/medicin_act.png',
              height: 30,
              width: 30,
            ),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Hóa đơn'),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.notifications),
          //   label: 'Thông báo',
          // ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Thống kê',
          ),
        ],
        currentIndex: widget.indexNum ?? 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            widget.indexNum = index;
          });
        },
      ),
      drawer: Drawer(),
    );
  }
}
