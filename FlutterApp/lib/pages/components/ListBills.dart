import 'dart:io';
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medication_management_app/AppService.dart';
import 'package:medication_management_app/pages/components/Billitem.dart';

class Listbills extends StatefulWidget {
  List<Map<String, String>> billsData;
  final VoidCallback onLoadData;
  Listbills({super.key, required this.billsData, required this.onLoadData});
  void name(params) {}

  @override
  State<Listbills> createState() => _ListbillsState();
}

class _ListbillsState extends State<Listbills> {
  String? message = "";
  void showMessagePopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[50],
          title: Text(
            "Thông báo",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.green.shade900,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 20, fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.green.shade900,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // đóng dialog
              },
            ),
          ],
        );
      },
    );
  }

  void onMessage(String message) {
    showMessagePopup(context, message);
  }

  Future<void> onDelete(String? id) async {
    final baseUrl = AppService.getBaseUrl();
    final response = await http.get(
      Uri.parse('$baseUrl/api/bills/delete?id=$id'),
      headers: {'Content-Type': 'application/json'},
    );

    final resBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        message = resBody['message'];
      });
      onMessage(message!); // Hiển thị popup thông báo
      // ignore: use_build_context_synchronously
      widget.onLoadData();
    } else if (response.statusCode == 401) {
      setState(() {
        message = resBody['error'];
      });
      onMessage(message!);
    } else {
      onMessage("Lỗi kết nối: ${response.statusCode}");
    }
  }

  Future<void> confirmDelete(BuildContext context, String? id) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Xác nhận xoá'),
            content: Text('Bạn có chắc chắn muốn xoá thuốc này không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('Huỷ'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Xoá'),
              ),
            ],
          ),
    );

    if (result == true) {
      await onDelete(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: widget.billsData.length,
        itemBuilder: (context, index) {
          final item = widget.billsData[index];
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Billitem(
              onMessage: onMessage,
              item: item,
              confirmDelete: confirmDelete,
            ),
          );
        },
      ),
    );
  }
}
