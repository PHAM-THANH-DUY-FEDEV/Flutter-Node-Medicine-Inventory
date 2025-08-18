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

class MedicinLibItem extends StatelessWidget {
  final Map<String, String> item;
  final void Function(String) onMessage;
  final Future<void> Function(BuildContext, String?) confirmDelete;
  const MedicinLibItem({
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
        builder: (context) => DetailItem(id: id!), // đảm bảo item có _id
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
          padding: EdgeInsets.all(5),
          // margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade100, width: 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            color: Colors.white,
          ),

          child: Row(
            children: [
              !AppService.checkWeb()
                  ? Image.network(
                    item['image'] ?? "",
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                  : SizedBox(),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        item['tenthuoc'] ?? "",
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
                      'Sđk: ${item['sodangky'] ?? "0"}',
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontSize: 14,
                        fontFamily: 'poppins',
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Số lượng trong kho: ${item['soluongtonkho'] ?? "Chưa có dữ liệu"}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontFamily: 'poppins',
                      ),
                    ),
                    Text(
                      'Danh mục: ${item['danhmuc'] ?? "Chưa có dữ liệu"}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontFamily: 'poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
