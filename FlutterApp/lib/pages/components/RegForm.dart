import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medication_management_app/AppService.dart';
import 'package:medication_management_app/main.dart';
import 'package:medication_management_app/pages/validators.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegForm extends StatefulWidget {
  final VoidCallback onLogRegSuccess;
  RegForm({super.key, required this.onLogRegSuccess});

  @override
  State<RegForm> createState() => _RegFormState();
}

class _RegFormState extends State<RegForm> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordComfirmController =
      TextEditingController();
  final storage = FlutterSecureStorage();

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

  Future<void> _writeToken(String token, String ids) async {
    try {
      await storage
          .write(key: 'token', value: token)
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              print('Storage write timed out');
              throw Exception('Storage write timed out');
            },
          );
      await storage
          .write(key: 'id', value: ids)
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              print('Storage write timed out');
              throw Exception('Storage write timed out');
            },
          );
      print('Token written: $token');
    } catch (e, stackTrace) {
      print('Error writing token: $e, StackTrace: $stackTrace');
      rethrow;
    }
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

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'];
      final userId = data['userId'];
      await _writeToken(token, userId);
      String? savedToken = await storage.read(key: "token");
      print("TOKEN REGISTER: $savedToken");
      setState(() {
        message = "Đăng ký thành công";
      });
      showMessagePopup(message!);
      try {
        print('Gọi onLogRegSuccess...');
        widget.onLogRegSuccess();
        print('onLogRegSuccess đã được gọi thành công.');
      } catch (e, stackTrace) {
        print('Lỗi khi gọi onLogRegSuccess: $e, StackTrace: $stackTrace');
        setState(() {
          message = "Error calling callback: $e";
        });
      }
    } else if (response.statusCode == 409) {
      setState(() {
        message = "Đăng ký thất bại: ${data['error']}";
      });
      showMessagePopup(message!);
      print("Đăng ký thất bại: ${data['error']}");
    } else if (response.statusCode == 400) {
      setState(() {
        message = "Đăng ký thất bại: ${data['error']}";
      });
      showMessagePopup(message!);
      print("Đăng ký thất bại: ${data['error']}");
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
        ],
      ),
    );
  }
}
