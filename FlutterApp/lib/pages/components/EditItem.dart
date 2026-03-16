import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:medication_management_app/AppService.dart';

class EditItem extends StatefulWidget {
  Map<String, dynamic>? itemData;
  List<Map<String, String>> luuyList = [];
  List<Map<String, String>> hoatchatList = [];

  EditItem({
    Key? key,
    required this.itemData,
    required this.luuyList,
    required this.hoatchatList,
  }) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? formData = {
    "_id": "",
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
    "ngayhethan": "",
  };
  final TextEditingController hoatChatController = TextEditingController();

  final TextEditingController khoiluongHCController = TextEditingController();

  List<Map<String, String>> hoatChatList = [];
  List<Map<String, String>> luuyList = [];
  List<Map<String, String>> luuyListEdit = [];

  // List<Map<String, String>> luuyList = [];

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

  @override
  void initState() {
    super.initState();
    formData = Map<String, dynamic>.from(widget.itemData ?? {});
    formData?['_id'] = widget.itemData?['_id'];
    print(formData?['_id']);
    print(widget.luuyList);
    // Gán luuyList ban đầu
    luuyList = List<Map<String, String>>.from(widget.luuyList);
    hoatChatList = List<Map<String, String>>.from(widget.hoatchatList);
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void addHoatChat() {
    final tenHoatChat = hoatChatController.text.trim();
    final khoiLuong = khoiluongHCController.text.trim();

    if (tenHoatChat.isEmpty || khoiLuong.isEmpty) return;

    setState(() {
      final existingIndex = hoatChatList.indexWhere(
        (item) =>
            item['tenhoatchat']?.toLowerCase() == tenHoatChat.toLowerCase(),
      );

      if (existingIndex != -1) {
        // Nếu đã tồn tại, cập nhật lại khối lượng
        hoatChatList[existingIndex]['khoiluong'] = khoiLuong;
      } else {
        // Nếu chưa có thì thêm mới
        hoatChatList.add({"tenhoatchat": tenHoatChat, "khoiluong": khoiLuong});
      }

      hoatChatController.clear();
      khoiluongHCController.clear();
    });
  }

  void saveLuuY() {
    if (selectedLuuYTitle.isNotEmpty && luuyContentController.text.isNotEmpty) {
      setState(() {
        final existingIndex = luuyList.indexWhere(
          (item) => item['title'] == selectedLuuYTitle,
        );

        if (existingIndex != -1) {
          // Nếu đã tồn tại, cập nhật content
          luuyList[existingIndex]['content'] = luuyContentController.text;
        } else {
          // Nếu chưa tồn tại, thêm mới
          luuyList.add({
            "title": selectedLuuYTitle,
            "content": luuyContentController.text,
          });
        }

        luuyContentController.clear();
      });
    }
  }

  void onSubmit() async {
    formData?["hoatchat"] = hoatChatList;
    formData?["luuy"] = luuyList;
    await submitData(formData!);
  }

  Future<void> submitData(Map<String, dynamic> formData) async {
    try {
      final baseUrl = AppService.getBaseUrl();
      String? token = await storage.read(key: 'token');

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/api/medicins/edit"),
      );

      request.headers["Authorization"] = "Bearer $token";

      formData.forEach((key, value) {
        if (value is List || value is Map) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      if (_selectedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", _selectedImage!.path),
        );
      }

      final response = await request.send();
      print("STATUS: ${response.statusCode}");
      final responseBody = await response.stream.bytesToString();
      print("BODY RAW: $responseBody");
      Map<String, dynamic> resBody = {};

      if (responseBody.isNotEmpty) {
        print("BEFORE JSON");
        print(responseBody);

        resBody = jsonDecode(responseBody);

        print("AFTER JSON");
      }

      if (response.statusCode == 200) {
        showMessagePopup(resBody["message"]);
        if (!mounted) return;
      } else {
        showMessagePopup(resBody["error"] ?? "Lỗi server");
      }
    } catch (e) {
      print("Edit medicine error: $e");
      showMessagePopup("Không thể kết nối đến server");
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
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, "/");
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
      appBar: AppBar(title: Text("Chỉnh sửa")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Tên thuốc", "tenthuoc"),
              _buildTextField("Thương hiệu", "thuonghieu"),
              _buildTextField("Dạng thuốc", "dangthuoc"),
              _buildTextField("Số đăng ký", "sodangky"),
              _buildTextField("Khối lượng", "khoiluong"),
              _buildTextField("Chỉ định", "chidinh", maxLines: 3),
              _buildTextField("Cách dùng", "cachdung", maxLines: 3),
              _buildTextField("Liều dùng", "lieudung", maxLines: 3),
              _buildTextField("Tác dụng phụ", "tacdungphu", maxLines: 3),
              _buildTextField("Xuất xứ thương hiệu", "xuatsuthuonghieu"),
              _buildTextField("Nước sản xuất", "nuocsanxuat"),
              SizedBox(height: 20),
              Text(
                "Ảnh hiện tại",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
              SizedBox(height: 20),
              formData?["image"] != null
                  ? Image.network(formData?['image'], fit: BoxFit.cover)
                  : Text("Hiện tại chưa có ảnh"),
              SizedBox(height: 20),
              Text(
                "Ảnh thay đổi",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
              _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.cover)
                  : Text("Chưa chọn ảnh"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Chọn ảnh từ thư viện"),
              ),
              SizedBox(height: 20),

              _buildTextField("Giá tham khảo", "giathamkhao"),
              _buildTextField("Tá dược", "taduoc"),
              _buildTextField("Danh mục", "danhmuc"),
              _buildTextField("Số lượng tồn kho", "soluongtonkho"),
              _buildTextField("Ngày nhập", "ngaynhap"),
              _buildTextField("Ngày hết hạn", "ngayhethan"),
              _buildTextField("Ngày cảnh báo", "ngaycanhbao"),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),

              Text(
                "Hoạt chất",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Danh sách hoạt chất:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  if (hoatChatList.isEmpty)
                    Text("Chưa có hoạt chất nào.")
                  else
                    ...hoatChatList.map(
                      (item) => Card(
                        child: ListTile(
                          title: Text(item['tenhoatchat'] ?? ""),
                          subtitle: Text(
                            "Khối lượng: ${item['khoiluong'] ?? ""}",
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
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

                  IconButton(onPressed: addHoatChat, icon: Icon(Icons.edit)),
                ],
              ),

              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              Text(
                "Lưu ý",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Danh sách lưu ý:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  if (luuyList.isEmpty)
                    Text("Chưa có lưu ý nào.")
                  else
                    ...luuyList.map(
                      (item) => Card(
                        child: ListTile(
                          title: Text(item['title'] ?? ""),
                          subtitle: Text(item['content'] ?? ""),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10),

              SizedBox(height: 20),
              Text(
                "Nhập thêm hoặc chỉnh lưu ý:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                onPressed: () => {saveLuuY()},
                // ignore: sort_child_properties_last
                child: Text(
                  "Lưu lưu ý",
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
                  "Lưu thay đổi",
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

  Widget _buildTextField(String label, String key, {int maxLines = 1}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      initialValue: formData?[key].toString(),
      maxLines: maxLines,
      onChanged: (val) => formData?[key] = val,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'Vui lòng nhập $label';
        }
        return null;
      },
    );
  }
}
