import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class DetailBillItem extends StatefulWidget {
  final String id;

  DetailBillItem({super.key, required this.id});

  @override
  State<DetailBillItem> createState() => _DetailBillItemState();
}

class _DetailBillItemState extends State<DetailBillItem> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  List<Map<String, dynamic>> billsData = [];
  Map<String, dynamic>? itemData;
  List<Map<String, String>> sanphamList = [];
  @override
  void initState() {
    super.initState();
    _loadBillData();
  }

  Future<void> _loadBillData() async {
    String? jsonString = await storage.read(key: 'billsData');
    if (jsonString != null) {
      List<dynamic> decoded = json.decode(jsonString);
      billsData = decoded.cast<Map<String, dynamic>>();

      if (billsData.isNotEmpty) {
        final selectedItem = billsData.firstWhere(
          (item) => item['_id'] == widget.id,
          orElse: () => <String, dynamic>{},
        );

        List<Map<String, String>> parsedSanpham = [];
        try {
          if (selectedItem['sanpham'] != null &&
              selectedItem['sanpham'] is List) {
            parsedSanpham =
                List<Map<String, dynamic>>.from(selectedItem['sanpham'])
                    .map(
                      (item) => item.map(
                        (k, v) => MapEntry(k.toString(), v.toString()),
                      ),
                    )
                    .toList();
          }
        } catch (e) {
          print("Lỗi khi parse : $e");
        }

        setState(() {
          itemData = selectedItem;
          sanphamList = parsedSanpham;
        });
      }
    } else {
      billsData = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi Tiết Hóa Đơn"),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(),
            listtitleItemCol(
              title: "Mã hóa đơn",
              value: itemData?['_id'] ?? "",
            ),
            Divider(),
            listtitleItemCol(
              title: "Ngày | giờ",
              value: "${itemData?['ngay']} | ${itemData?['gio']}",
            ),
            Divider(),
            listtitleItemCol(
              title: "Tên khách hàng",
              value: itemData?['khachhang'] ?? "",
            ),
            Divider(),
            listtitleItemCol(
              title: "Số điện thoại",
              value: itemData?['dienthoai'] ?? "",
            ),
            Divider(),
            listtitleItemCol(
              title: "Tên nhân viên",
              value: itemData?['nhanvien'] ?? "",
            ),
            Divider(),
            buildSPListSection(sanphamList),
          ],
        ),
      ),
    );
  }
}

class listtitleItemCol extends StatelessWidget {
  final String title;
  final String value;

  const listtitleItemCol({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${title}: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Flexible(child: Text(value, style: TextStyle(fontSize: 18))),
        ],
      ),
    );
  }
}

Widget buildSPListSection(List<Map<String, String>> sanphamlist) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.topLeft,
          child: Text(
            'Những sản phẩm đã mua',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      SizedBox(height: 10),
      ...sanphamlist.map((item) {
        final idSanpham = item['idsanpham'] ?? "";
        final nameSanpham = item['tensanpham'] ?? "";
        final quantitum = item['soluong'] ?? "";
        final type = item['donvi'] ?? "";

        return Container(
          margin: EdgeInsets.only(bottom: 15),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sản phẩm:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      nameSanpham,
                      style: TextStyle(fontSize: 18),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              listtitleItemCol(title: "Số lượng", value: quantitum),
              listtitleItemCol(title: "Đơn vị", value: type),
              SizedBox(height: 5),
            ],
          ),
        );
      }).toList(),
    ],
  );
}
