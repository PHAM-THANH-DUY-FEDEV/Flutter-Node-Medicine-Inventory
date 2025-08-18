import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:medication_management_app/AppService.dart';
import 'package:medication_management_app/pages/components/ListMedicinsLib.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onLogout;
  const HomePage({super.key, required this.onLogout});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Map<String, dynamic>> productsData = [];
  String? ids;
  final String idKey = 'id';
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

    final response = await http.get(Uri.parse('$baseUrl/api/medicins/lib'));

    if (response.statusCode == 200) {
      final resBody = jsonDecode(response.body);
      final List dataList = resBody['dataMedicins'];
      if (dataList.isNotEmpty) {
        if (!mounted) return;

        final List<Map<String, dynamic>> safeData =
            dataList.cast<Map<String, dynamic>>();

        await storage.write(key: 'productsData', value: jsonEncode(safeData));

        setState(() {
          productsData = safeData;
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
      Uri.parse('$baseUrl/api/medicins/search-medicins-lib/?q=$text'),
    );

    if (response.statusCode == 200) {
      final resBody = jsonDecode(response.body);
      final List dataList = resBody['dataMedicins'];
      if (dataList.isNotEmpty) {
        if (!mounted) return;

        // Đảm bảo giữ nguyên kiểu dữ liệu ban đầu (bao gồm List, Map)
        final List<Map<String, dynamic>> safeData =
            dataList.cast<Map<String, dynamic>>();

        await storage.write(key: 'productsData', value: jsonEncode(safeData));

        setState(() {
          productsData = safeData;
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
        title: Text('Trang Chủ'),
        backgroundColor: Colors.green,
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
                hintText: 'Nhập tên thuốc',
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
                child: ListMedicinsLib(
                  productsData:
                      productsData
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

      floatingActionButton: SpeedDial(
        icon: Icons.add,
        spacing: 15,
        iconTheme: IconThemeData(color: Colors.white),
        spaceBetweenChildren: 15,
        backgroundColor: Colors.green[400],
        childMargin: EdgeInsets.all(10),
        children: [
          SpeedDialChild(
            child: Icon(Icons.medical_services, color: Colors.white),
            backgroundColor: Colors.green[400],

            label: 'Thêm Thuốc',
            onTap:
                () => {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamedAndRemoveUntil("/addMedicins", (route) => true),
                },
          ),
        ],
      ),
    );
  }
}
