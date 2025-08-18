import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medication_management_app/AppService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medication_management_app/pages/components/ListBills.dart';

class BillsPage extends StatefulWidget {
  final VoidCallback onLogout;
  const BillsPage({super.key, required this.onLogout});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> billsData = [];
  FlutterSecureStorage storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((_) {
      if (mounted) {
        loadData();
      }
    });
  }

  Future<void> loadData() async {
    final baseUrl = AppService.getBaseUrl();

    final response = await http.get(Uri.parse('$baseUrl/api/bills/'));

    if (response.statusCode == 200) {
      final resBody = jsonDecode(response.body);
      final List dataList = resBody['dataBills'];
      if (dataList.isNotEmpty) {
        if (!mounted) return;

        final List<Map<String, dynamic>> safeData =
            dataList.cast<Map<String, dynamic>>();

        await storage.write(key: 'billsData', value: jsonEncode(safeData));

        setState(() {
          billsData = safeData;
          isLoading = false;
        });
      }
    } else {
      print("Lỗi: ${response.statusCode}");
      if (!mounted) return;
      setState(() => isLoading = true);
    }
  }

  Future<void> searchData(String text) async {
    final baseUrl = AppService.getBaseUrl();
    final response = await http.get(
      Uri.parse('$baseUrl/api/bills/search-bills/?q=$text'),
    );

    if (response.statusCode == 200) {
      final resBody = jsonDecode(response.body);
      final List dataList = resBody['dataBills'];
      if (dataList.isNotEmpty) {
        if (!mounted) return;

        // Đảm bảo giữ nguyên kiểu dữ liệu ban đầu (bao gồm List, Map)
        final List<Map<String, dynamic>> safeData =
            dataList.cast<Map<String, dynamic>>();

        await storage.write(key: 'productsData', value: jsonEncode(safeData));

        setState(() {
          billsData = safeData;
          isLoading = false;
        });
      }
    } else {
      print("Lỗi: ${response.statusCode}");
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hóa đơn'),
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onSubmitted: (value) => {searchData(value)},
              decoration: InputDecoration(
                hintText: 'Nhập số điện thoại khách hàng',
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.green.shade100,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
          ),
          isLoading
              ? Container(
                margin: EdgeInsets.only(top: 100),
                child: Center(child: CircularProgressIndicator()),
              )
              : Expanded(
                child: Listbills(
                  billsData:
                      billsData
                          .map(
                            (item) => item.map(
                              (key, value) =>
                                  MapEntry(key, value?.toString() ?? ""),
                            ),
                          )
                          .toList(),

                  onLoadData: loadData,
                ),
              ),
        ],
      ),
    );
  }
}
