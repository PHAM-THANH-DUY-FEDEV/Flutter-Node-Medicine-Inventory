// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medication_management_app/pages/components/EditItem.dart';

class DetailItem extends StatefulWidget {
  final String id;
  DetailItem({super.key, required this.id});

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  List<Map<String, dynamic>> productsData = [];
  Map<String, dynamic>? itemData;
  List<Map<String, String>> luuyList = [];
  List<Map<String, String>> hoatchatList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  void openEditlRoute(BuildContext context, {String? id}) {
    final List<Map<String, String>> parsedLuuyList =
        (itemData?['luuy'] as List<dynamic>)
            .map(
              (e) => {
                'title': e['title'].toString(),
                'content': e['content'].toString(),
              },
            )
            .toList();
    final List<Map<String, String>> parsedHoatchat =
        (itemData?['hoatchat'] as List<dynamic>)
            .map(
              (e) => {
                'tenhoatchat': e['tenhoatchat'].toString(),
                'khoiluong': e['khoiluong'].toString(),
              },
            )
            .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => EditItem(
              itemData: itemData,
              luuyList: parsedLuuyList,
              hoatchatList: parsedHoatchat,
            ),
      ),
    );
  }

  Future<void> _loadProductData() async {
    String? jsonString = await storage.read(key: 'productsData');
    if (jsonString != null) {
      List<dynamic> decoded = json.decode(jsonString);
      productsData = decoded.cast<Map<String, dynamic>>();

      if (productsData.isNotEmpty) {
        final selectedItem = productsData.firstWhere(
          (item) => item['_id'] == widget.id,
          orElse: () => <String, dynamic>{},
        );

        List<Map<String, String>> parsedLuuy = [];
        List<Map<String, String>> parsedHoatchat = [];
        try {
          if (selectedItem['luuy'] != null && selectedItem['luuy'] is List) {
            parsedLuuy =
                List<Map<String, dynamic>>.from(selectedItem['luuy'])
                    .map(
                      (item) => item.map(
                        (k, v) => MapEntry(k.toString(), v.toString()),
                      ),
                    )
                    .toList();
          }
          if (selectedItem['hoatchat'] != null &&
              selectedItem['hoatchat'] is List) {
            parsedHoatchat =
                List<Map<String, dynamic>>.from(selectedItem['hoatchat'])
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
          luuyList = parsedLuuy;
          hoatchatList = parsedHoatchat;
          isLoading = false;
        });
      }
    } else {
      productsData = [];
    }
  }

  String formatCurrency(String? numberString) {
    if (numberString == null || numberString.isEmpty) return "";
    final number = int.tryParse(numberString.replaceAll('.', ''));
    if (number == null) return "";
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(number);
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
              ? Card(
                margin: EdgeInsets.only(top: 100),
                child: Center(child: CircularProgressIndicator()),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      child: SizedBox(
                        child: Text(
                          itemData?['tenthuoc'] ?? "",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        'Số lượng tồn kho: ${itemData?['soluongtonkho']}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        'Ngày nhập: ${itemData?['ngaynhap']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15, top: 10),

                      child: Text(
                        'Ngày hết hạn: ${itemData?['ngayhethan']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 2,
                          color: Colors.green.shade300,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:
                            itemData?['image'] != ""
                                ? Image.network(
                                  itemData?['image'],
                                  fit: BoxFit.cover,
                                )
                                : Text("Hiện chưa có dữ liệu ảnh"),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        spacing: 10,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Thương hiệu: ${itemData?['thuonghieu']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Số đăng ký: ${itemData?['sodangky']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        'Chi tiết sản phẩm',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        spacing: 10,
                        children: [
                          listtitleItem(
                            title: "Danh mục",
                            content: itemData?["danhmuc"] ?? "",
                          ),
                          listtitleItem(
                            title: "Hình thức",
                            content: itemData?["dangthuoc"] ?? "",
                          ),
                          listtitleItem(
                            title: "Quy cách",
                            content: itemData?["khoiluong"] ?? "",
                          ),
                          listtitleItemCol(
                            title: "Chỉ định",
                            content: itemData?["chidinh"] ?? "",
                          ),
                          listtitleItemCol(
                            title: "Cách dùng",
                            content: itemData?["cachdung"] ?? "",
                          ),
                          listtitleItem(
                            title: "Thương hiệu xuất sứ",
                            content: itemData?["xuatsuthuonghieu"] ?? "",
                          ),
                          listtitleItem(
                            title: "Nước sản xuất",
                            content: itemData?["nuocsanxuat"] ?? "",
                          ),
                          listtitleItem(
                            title: "Giá tham khảo",
                            content: formatCurrency(
                              itemData?["giathamkhao"].toString() ?? "",
                            ),
                          ),
                          itemData?["hoatchat"] != null
                              ? buildHoatChatListSection(hoatchatList)
                              : SizedBox(),
                          itemData?["luuy"] != null
                              ? buildLuuYListSection(luuyList)
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade400,
        onPressed: () => openEditlRoute(context, id: widget.id),
        child: Icon(Icons.edit, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}

class listtitleItem extends StatelessWidget {
  final String title;
  final String content;

  const listtitleItem({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            '${title}: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class listtitleItemCol extends StatelessWidget {
  final String title;
  final String content;

  const listtitleItemCol({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            '${title}: ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            content,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildLuuYListSection(List<Map<String, String>> luuyData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(),
      Container(
        alignment: Alignment.topLeft,
        child: Text(
          'Lưu ý khi sử dụng',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 10),
      ...luuyData.map((item) {
        final title = item['title'] ?? "";
        final rawContent = item['content'] ?? "";
        final contentLines =
            rawContent
                .split('~')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .toList();

        return Container(
          margin: EdgeInsets.only(bottom: 15),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              ...contentLines.map(
                (line) => Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• ", style: TextStyle(fontSize: 14, height: 1.4)),
                      Expanded(
                        child: Text(
                          line.replaceFirst(RegExp(r'list\s*'), ''),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ],
  );
}

Widget buildHoatChatListSection(List<Map<String, String>> hoatchatData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(),
      Container(
        alignment: Alignment.topLeft,
        child: Text(
          'Hoạt chất',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(height: 10),
      ...hoatchatData.map((item) {
        final title = '${item['tenhoatchat']}:' ?? "";
        final rawContent = item['khoiluong'] ?? "";
        final contentLines =
            rawContent
                .split('~')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .toList();

        return Container(
          margin: EdgeInsets.only(bottom: 15),
          alignment: Alignment.topLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              ...contentLines.map(
                (line) => Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line.replaceFirst(RegExp(r'list\s*'), ''),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ],
  );
}
