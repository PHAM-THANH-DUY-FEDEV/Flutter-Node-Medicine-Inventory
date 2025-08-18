import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medication_management_app/AppService.dart';
import 'package:medication_management_app/pages/components/FormAddData.dart';
import 'package:medication_management_app/pages/components/ListMedicinsLib.dart';
import 'package:medication_management_app/pages/validators.dart';

class AddMedicinPage extends StatefulWidget {
  const AddMedicinPage({Key? key}) : super(key: key);

  @override
  _AddMedicinPageState createState() => _AddMedicinPageState();
}

class _AddMedicinPageState extends State<AddMedicinPage> {
  bool isLoading = true;
  List<Map<String, String>> newData = [];

  void changeLoading() {
    setState(() {
      isLoading != isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
        leading: IconButton(
          icon: Icon(
            Icons.home, // Có thể thay bằng icon khác
            color: Colors.white, // Đổi màu tại đây
            size: 24, // Đổi kích thước icon
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FormAddData(changeLoading: changeLoading),
      backgroundColor: Colors.green.shade50,
    );
  }
}

class FormAddData extends StatefulWidget {
  final VoidCallback changeLoading;
  const FormAddData({super.key, required this.changeLoading});

  @override
  _FormAddDataState createState() => _FormAddDataState();
}

class _FormAddDataState extends State<FormAddData> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {
    "tenthuoc": "",
    "thuonghieu": "",
    "dangthuoc": "",
    "sodangky": "",
    "khoiluong": "",
    "hoatchat": [],
    "chidinh": "",
    "cachdung": "",
    "lieudung": "",
    "tacdungphu": "",
    "luuy": [],
    "xuatsuthuonghieu": "",
    "nuocsanxuat": "",
    "image": "",
    "giathamkhao": "",
    "taduoc": "",
    "danhmuc": "",
    "soluongtonkho": "",
    "ngaynhap": "",
    "ngaycanhbao": "",
    "ngayhethan": "",
  };

  final TextEditingController hoatChatController = TextEditingController();
  final TextEditingController khoiluongHCController = TextEditingController();

  List<Map<String, String>> hoatChatList = [];
  List<Map<String, String>> luuyList = [];

  String selectedLuuYTitle = "";
  final TextEditingController luuyContentController = TextEditingController();

  List<String> luuyTitles = [
    "Chống chỉ định",
    "Thận trọng khi sử dụng",
    "Khả năng lái xe và sử dụng máy móc",
    "Thời kỳ mang thai",
    "Thời kỳ cho con bú",
    "Tương tác thuốc",
  ];
  void addHoatChat() {
    setState(() {
      hoatChatList.add({
        "tenhoatchat": hoatChatController.text,
        "khoiluong": khoiluongHCController.text,
      });
      hoatChatController.clear();
      khoiluongHCController.clear();
    });
  }

  void addLuuY() {
    if (selectedLuuYTitle.isNotEmpty && luuyContentController.text.isNotEmpty) {
      setState(() {
        luuyList.add({
          "title": selectedLuuYTitle,
          "content": "${luuyContentController.text}",
        });
        luuyContentController.clear();
      });
    }
  }

  void onSubmit() {
    formData["hoatchat"] = hoatChatList;
    formData["luuy"] = luuyList;
    widget.changeLoading;
    submitData(formData);
    Navigator.pushReplacementNamed(context, "/");
  }

  Future<void> submitData(Map<String, dynamic> formData) async {
    final baseUrl = AppService.getBaseUrl();

    final response = await http.post(
      Uri.parse('$baseUrl/api/medicins/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(formData),
    );

    final resBody = jsonDecode(response.body);
    if (!mounted) return;
    if (response.statusCode == 200) {
      final message = resBody['message'];
      showMessagePopup(message); // Hiển thị popup thông báo
      widget.changeLoading(); // Thay đổi trạng thái loading
    } else if (response.statusCode == 401) {
      final messageErr = resBody['error'];
      showMessagePopup(messageErr); // Có thể thêm dòng này để hiển thị lỗi
      widget.changeLoading();
    } else {
      showMessagePopup("Lỗi kết nối: ${response.statusCode}");
      widget.changeLoading();
    }
  }

  void showMessagePopup(String message) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                "Tên thuốc",
                "tenthuoc",
                valiFunc: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập tên thuốc';
                  }
                  return null;
                },
              ),
              _buildTextField(
                "Thương hiệu",
                "thuonghieu",
                valiFunc: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập thương hiệu';
                  }
                  return null;
                },
              ),
              _buildTextField("Dạng thuốc", "dangthuoc"),
              _buildTextField(
                "Số đăng ký",
                "sodangky",
                valiFunc: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập số đăng ký';
                  }
                  return null;
                },
              ),
              _buildTextField(
                "Khối lượng",
                "khoiluong",
                valiFunc: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập khối lượng';
                  }
                  return null;
                },
              ),
              _buildTextField("Chỉ định", "chidinh", maxLines: 3),
              _buildTextField(
                "Cách dùng",
                "cachdung",
                maxLines: 3,
                valiFunc: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập cách dùng';
                  }
                  return null;
                },
              ),
              _buildTextField("Liều dùng", "lieudung", maxLines: 3),
              _buildTextField("Tác dụng phụ", "tacdungphu", maxLines: 3),
              _buildTextField("Xuất xứ thương hiệu", "xuatsuthuonghieu"),
              _buildTextField("Nước sản xuất", "nuocsanxuat"),
              _buildTextField("URL Hình ảnh", "image"),
              _buildTextField("Giá tham khảo", "giathamkhao"),
              _buildTextField(
                "Tá dược",
                "taduoc",
                valiFunc: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập tá dược';
                  }
                  return null;
                },
              ),
              _buildTextField("Danh mục", "danhmuc"),
              _buildTextField(
                "Số lượng tồn kho",
                "soluongtonkho",
                valiFunc: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập số lượng';
                  }
                  return null;
                },
              ),
              _buildTextField(
                "Ngày nhập kho",
                "ngaynhap",
                valiFunc: (val) => validateNgayNhap(val),
              ),
              _buildTextField(
                "Ngày hết hạn",
                "ngayhethan",
                valiFunc: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập ngày hết hạn';
                  }
                  return null;
                },
              ),
              _buildTextField(
                "Ngày cảnh báo",
                "ngaycanhbao",
                valiFunc: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Vui lòng nhập ngày cảnh báo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),

              Text(
                "Hoạt chất",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: hoatChatController,
                      decoration: InputDecoration(labelText: "Tên hoạt chất"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: khoiluongHCController,
                      decoration: InputDecoration(labelText: "Khối lượng"),
                    ),
                  ),
                  IconButton(onPressed: addHoatChat, icon: Icon(Icons.add)),
                ],
              ),

              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),

              Text(
                "Lưu ý",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              DropdownButtonFormField<String>(
                value: selectedLuuYTitle.isEmpty ? null : selectedLuuYTitle,
                hint: Text("Chọn tiêu đề"),
                items:
                    luuyTitles
                        .map(
                          (title) => DropdownMenuItem(
                            value: title,
                            child: Text(title),
                          ),
                        )
                        .toList(),
                onChanged:
                    (val) => setState(() => selectedLuuYTitle = val ?? ""),
              ),
              TextField(
                controller: luuyContentController,
                decoration: InputDecoration(labelText: "Nội dung lưu ý"),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addLuuY,
                // ignore: sort_child_properties_last
                child: Text(
                  "Thêm lưu ý",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.green.shade400,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    () => {
                      if (_formKey.currentState!.validate())
                        {onSubmit()}
                      else
                        {print("Form không hợp lệ")},
                    },
                // ignore: sort_child_properties_last
                child: Text(
                  "Thêm thuốc",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.green.shade400,
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String key, {
    int maxLines = 1,
    FormFieldValidator<String>? valiFunc,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      onChanged: (val) => formData[key] = val,
      validator: valiFunc,
    );
  }
}
