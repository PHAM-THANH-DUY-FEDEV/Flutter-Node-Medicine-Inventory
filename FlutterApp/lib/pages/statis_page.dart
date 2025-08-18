import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:medication_management_app/AppService.dart';
import 'package:medication_management_app/pages/components/DetailItemStatis.dart';
import 'package:medication_management_app/pages/components/n_pie_chart.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class statisPage extends StatefulWidget {
  final VoidCallback onLogout;
  const statisPage({super.key, required this.onLogout});

  @override
  State<statisPage> createState() => _statisPageState();
}

class _statisPageState extends State<statisPage> {
  int touchedIndex = -1;
  Key tweenKey = UniqueKey();
  FlutterSecureStorage storage = FlutterSecureStorage();
  Map<String, dynamic> statisData = {};
  List<dynamic> statisDataCategory = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final baseUrl = AppService.getBaseUrl();

    final response = await http.get(Uri.parse('$baseUrl/api/statis'));
    final responseCategory = await http.get(
      Uri.parse('$baseUrl/api/statis/category'),
    );

    if (response.statusCode == 200) {
      final resBody = jsonDecode(response.body);
      final dataMap = resBody['statisData'] as Map<String, dynamic>;
      if (dataMap.isNotEmpty) {
        if (!mounted) return;

        final Map<String, dynamic> safeData = dataMap;

        await storage.write(key: 'statisData', value: jsonEncode(safeData));

        setState(() {
          statisData = safeData;
        });
      }
    } else {
      print("Lỗi: ${response.statusCode}");
      if (!mounted) return;
    }

    if (responseCategory.statusCode == 200) {
      final resBody = jsonDecode(responseCategory.body);

      if (resBody['statisDataCategory'].isNotEmpty) {
        if (!mounted) return;

        await storage.write(
          key: 'staticDataCategory',
          value: resBody['statisDataCategory'],
        );

        setState(() {
          statisDataCategory = jsonDecode(resBody['statisDataCategory']);
        });
      }
    } else {
      print("Lỗi: ${response.statusCode}");
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Text(
                "Biểu đồ thống kê",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 20.0,
                  left: 10.0,
                  right: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NPieChart(
                      radius: 100.0,
                      expired:
                          statisData.isNotEmpty
                              ? statisData['expired'] ?? 0
                              : 0,
                      available:
                          statisData.isNotEmpty
                              ? statisData['available'] ?? 0
                              : 0,
                      outOfStock:
                          statisData.isNotEmpty
                              ? statisData['outOfStock'] ?? 0
                              : 0,
                      nearExpiry:
                          statisData.isNotEmpty
                              ? statisData['nearExpiry'] ?? 0
                              : 0,
                      textSize: 16.0,
                      strokeWidth: 6.0,
                    ),
                    SizedBox(width: 20.0),
                    Container(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegend(Colors.red.shade300, "Hết hạn"),
                          SizedBox(height: 10),
                          _buildLegend(Colors.green.shade300, "Khả dụng"),
                          SizedBox(height: 10),
                          _buildLegend(Colors.grey, "Hết hàng"),
                          SizedBox(height: 10),
                          _buildLegend(Colors.yellow.shade300, "Cận date"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Phân tích",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              CardAnalysis(
                id: "medicinsexpired",
                title: "Tổng thuốc hết hạn",
                value:
                    statisData.isNotEmpty
                        ? statisData['expired'].toString()
                        : "0",
                color: Colors.red.shade300,
                onTap: () {
                  // Handle tap for total drugs
                },
              ),
              CardAnalysis(
                id: "medicinsnearexpiry",
                title: "Tổng thuốc cận date",
                value:
                    statisData.isNotEmpty
                        ? statisData['nearExpiry'].toString()
                        : "0",
                color: Colors.yellow.shade300,

                onTap: () {
                  // Handle tap for total drugs
                },
              ),
              CardAnalysis(
                id: "medicinsoutofstock",
                title: "Tổng thuốc đang hết hàng",
                value:
                    statisData.isNotEmpty
                        ? statisData['outOfStock'].toString()
                        : "0",
                color: Colors.grey,

                onTap: () {
                  // Handle tap for total drugs
                },
              ),
              CardAnalysis(
                id: "medicinsavailable",
                title: "Tổng thuốc còn khả dụng",
                value:
                    statisData.isNotEmpty
                        ? (statisData['available'] + statisData['available'])
                            .toString()
                        : "0",
                color: Colors.green.shade400,
                onTap: () {
                  // Handle tap for total drugs
                },
              ),
              SizedBox(height: 20.0),
              Text(
                "Thuốc đã bán theo danh mục",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              ...statisDataCategory.map((item) {
                return CardAnalysisCategory(
                  title: item['danhmuc'] ?? 'Không rõ',
                  value: item['tongSoLuongTrongDanhMuc'].toString(),
                  topValue: item['thuocBanNhieuNhat'],
                  onTap: () {
                    // Bạn có thể xử lý khi nhấn vào danh mục này, ví dụ:
                    print("Xem chi tiết danh mục: ${item['danhmuc']}");
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildLegend(Color color, String label) {
  return Row(
    children: [
      Container(width: 20, height: 20, color: color),
      SizedBox(width: 10),
      Text(label, style: TextStyle(fontSize: 14)),
      SizedBox(width: 12),
    ],
  );
}

class CardAnalysis extends StatelessWidget {
  final String title;
  final String value;
  final String id;
  final Color color;
  final VoidCallback onTap;

  const CardAnalysis({
    Key? key,
    required this.title,
    required this.id,
    required this.value,
    required this.onTap,
    required this.color,
  }) : super(key: key);
  void openDetailRoute(BuildContext context, {String? id}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Detailitemstatis(id: id!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openDetailRoute(context, id: id),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 20.0,
          bottom: 20.0,
          left: 20.0,
          right: 10.0,
        ),
        margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(width: 14, height: 14, color: color),
            SizedBox(width: 8),
            Text("${title}: ${value}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class CardAnalysisCategory extends StatelessWidget {
  final String title;
  final String value;
  final Map<String, dynamic>? topValue;
  final VoidCallback onTap;

  const CardAnalysisCategory({
    Key? key,
    required this.title,
    required this.value,
    required this.onTap,
    required this.topValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tenThuoc =
        topValue != null && topValue!.isNotEmpty
            ? topValue!['tenthuoc'] ?? 'Không có dữ liệu'
            : 'Không có dữ liệu';
    final soLuongBanChay =
        topValue != null && topValue!.isNotEmpty
            ? topValue!['soluong'] ?? 'Không có dữ liệu'
            : 'Không có dữ liệu';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 20.0,
          bottom: 20.0,
          left: 20.0,
          right: 20.0,
        ),
        margin: const EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 10,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thuốc ${title.toLowerCase()}: ${value}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "Thuốc bán chạy nhất:",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
            Text(
              tenThuoc,
              style: TextStyle(fontSize: 16, color: Colors.green.shade800),
            ),
            SizedBox(height: 10),
            Text(
              "Số lượng: ${soLuongBanChay}",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }
}
