// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:math';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medication_management_app/AppService.dart';
import 'package:medication_management_app/pages/components/DetailItem.dart';
import 'package:medication_management_app/pages/components/EditItem.dart';

class Detailitemstatis extends StatefulWidget {
  final String id;
  Detailitemstatis({super.key, required this.id});

  @override
  State<Detailitemstatis> createState() => _DetailitemstatisState();
}

class _DetailitemstatisState extends State<Detailitemstatis> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  List<Map<String, dynamic>> productsData = [];
  Map<String, dynamic> statisData = {};
  List<Map<String, dynamic>> itemsData = [];

  Map<String, dynamic>? itemData;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  Future<void> _loadData() async {
    String? ProductJsonString = await storage.read(key: 'productsData');
    if (ProductJsonString != null) {
      List<dynamic> decoded = json.decode(ProductJsonString);
      productsData = decoded.cast<Map<String, dynamic>>();
    }
    String? StatisJsonString = await storage.read(key: 'statisData');
    if (StatisJsonString != null) {
      Map<String, dynamic> decoded = json.decode(StatisJsonString);
      statisData = decoded;
    }
    for (var item in statisData['${widget.id}']) {
      print(item['idthuoc']);
      final itemProduct = productsData.firstWhere(
        (element) => element['_id'] == item['idthuoc'],
        orElse: () => {},
      );
      itemsData.add(itemProduct);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết'),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          isLoading
              ? Container(
                margin: EdgeInsets.only(),
                child: Center(child: CircularProgressIndicator()),
              )
              : Container(
                margin: EdgeInsets.only(top: 20),
                child: ListView.builder(
                  itemCount: itemsData.length,
                  itemBuilder: (context, index) {
                    final item = itemsData[index];
                    return MedicinStatisItem(item: item);
                  },
                ),
              ),
    );
  }
}

class MedicinStatisItem extends StatelessWidget {
  final Map<String, dynamic> item;
  const MedicinStatisItem({super.key, required this.item});

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
    return InkWell(
      onTap: () => openDetailRoute(context, id: item["_id"]),
      borderRadius: BorderRadius.circular(15),
      customBorder: Border.all(width: 2, color: Colors.green.shade400),
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        // margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green.shade100, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                  Text(
                    'Ngày nhập: ${item['ngaynhap'] ?? "Chưa có dữ liệu"}',
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 14,
                      fontFamily: 'poppins',
                    ),
                  ),
                  Text(
                    'Ngày hết hạn: ${item['ngayhethan'] ?? "Chưa có dữ liệu"}',
                    style: TextStyle(
                      color: Colors.red.shade400,
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
    );
  }
}
