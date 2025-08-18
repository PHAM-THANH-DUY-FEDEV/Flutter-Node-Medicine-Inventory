import 'dart:async';
import 'dart:ui';

import "package:flutter/material.dart";
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:medication_management_app/AppService.dart';
import 'dart:convert';

import 'package:medication_management_app/pages/components/DetailItem.dart';
import 'package:medication_management_app/pages/components/DetailItemBill.dart';

class Billitem extends StatelessWidget {
  final Map<String, String> item;
  final void Function(String) onMessage;
  final Future<void> Function(BuildContext, String?) confirmDelete;
  const Billitem({
    Key? key,
    required this.item,
    required this.onMessage,
    required this.confirmDelete,
  }) : super(key: key);
  String? get id => item['_id'];

  void openDetailRoute(BuildContext context, {String? id}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBillItem(id: id!), // đảm bảo item có _id
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => confirmDelete(context, id),
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            padding: EdgeInsets.all(5),
            icon: Icons.delete,
            label: 'Xoá',
          ),
        ],
      ),
      child: InkWell(
        onTap: () => openDetailRoute(context, id: id),
        borderRadius: BorderRadius.circular(15),
        customBorder: Border.all(width: 2, color: Colors.green.shade400),
        child: Container(
          padding: EdgeInsets.all(15),
          // margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade100, width: 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            color: Colors.white,
          ),

          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                item['khachhang'] ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'Sdt: ${item['dienthoai'] ?? "0"}',
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 14,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: 25),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ngày mua hàng: ${item['ngay'] ?? "Chưa có dữ liệu"}',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontFamily: 'poppins',
                              ),
                            ),
                            Text(
                              'Giờ mua: ${item['gio'] ?? "Chưa có dữ liệu"}',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
