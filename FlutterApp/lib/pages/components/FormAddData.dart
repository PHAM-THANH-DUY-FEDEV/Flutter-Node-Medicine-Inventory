import 'package:flutter/material.dart';

class FormAddData extends StatefulWidget {
  const FormAddData({super.key});

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
          "content": "list ${luuyContentController.text}",
        });
        luuyContentController.clear();
      });
    }
  }

  void onSubmit() {
    formData["hoatchat"] = hoatChatList;
    formData["luuy"] = luuyList;

    print("Dữ liệu cuối cùng:\n${formData}");
    // Bạn có thể convert sang JSON: jsonEncode(formData)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form Nhập Thuốc")),
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
              _buildTextField("URL Hình ảnh", "image"),
              _buildTextField("Giá tham khảo", "giathamkhao"),
              _buildTextField("Tá dược", "taduoc"),
              _buildTextField("Danh mục", "danhmuc"),
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
                onPressed: onSubmit,
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

  Widget _buildTextField(String label, String key, {int maxLines = 1}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      onChanged: (val) => formData[key] = val,
    );
  }
}
