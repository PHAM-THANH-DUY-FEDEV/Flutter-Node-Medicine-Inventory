import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medication_management_app/AppService.dart';
import 'package:medication_management_app/pages/validators.dart';

class RegForm extends StatefulWidget {
  RegForm({super.key});

  @override
  State<RegForm> createState() => _RegFormState();
}

class _RegFormState extends State<RegForm> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordComfirmController =
      TextEditingController();

  String? message = "";

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

  Future<void> regisUser() async {
    final baseUrl = AppService.getBaseUrl();

    final response = await http.post(
      Uri.parse('$baseUrl/api/register/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phoneController.text,
        'password': passwordController.text,
        'repassword': passwordComfirmController.text,
        'name': nameController.text,
      }),
    );

    final resBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        message = "Đăng ký thành công vui lòng đăng nhập";
      });
      showMessagePopup(message!);
      print("Đăng ký thành công: ${resBody['id']}");
    } else if (response.statusCode == 409) {
      setState(() {
        message = "Đăng ký thất bại: ${resBody['error']}";
      });
      showMessagePopup(message!);
      print("Đăng ký thất bại: ${resBody['error']}");
    } else if (response.statusCode == 400) {
      setState(() {
        message = "Đăng ký thất bại: ${resBody['error']}";
      });
      showMessagePopup(message!);
      print("Đăng ký thất bại: ${resBody['error']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              "Nhập số điện thoại:",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              hintText: 'Số điện thoại',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 18),
              prefixIcon: Icon(Icons.person, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.green.shade100, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              errorText: validatePhone(phoneController.text),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              "Nhập họ và tên:",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Nguyễn Văn A',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 18),
              prefixIcon: Icon(Icons.person, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.green.shade100, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              errorText: validateName(nameController.text),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              "Nhập mật khẩu:",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'Mật khẩu',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 18),
              prefixIcon: Icon(Icons.lock, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.green.shade100, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              errorText: validatePass(passwordController.text),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              "Xác nhận mật khẩu:",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ),
          TextField(
            obscureText: true,
            controller: passwordComfirmController,
            decoration: InputDecoration(
              hintText: 'Mật khẩu',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 18),
              prefixIcon: Icon(Icons.lock, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.green.shade100, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              errorText: validateRePass(
                passwordController.text,
                passwordComfirmController.text,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 400,
            child: ElevatedButton(
              onPressed: () {
                regisUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Đăng ký cho người dùng',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              "Đăng ký bằng email:",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                // padding: const EdgeInsets.all(),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Image.asset(
                    "assets/iconsPng/google.png",
                    width: 40,
                    height: 40,
                  ),
                  onPressed: () {
                    // Xử lý đăng nhập bằng email
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
