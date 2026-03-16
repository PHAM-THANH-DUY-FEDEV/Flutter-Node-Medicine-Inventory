import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medication_management_app/AppService.dart';

class LogForm extends StatefulWidget {
  final VoidCallback onLogRegSuccess;
  const LogForm({super.key, required this.onLogRegSuccess});

  @override
  State<LogForm> createState() => _LogFormState();
}

class _LogFormState extends State<LogForm> {
  String? message;
  final storage = FlutterSecureStorage();

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  bool validateFields() {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        message = "Vui lòng nhập đầy đủ thông tin";
      });
      showMessagePopup(message!);
      return false;
    } else {
      return true;
    }
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

  Future<void> logUser() async {
    final baseUrl = AppService.getBaseUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/api/login/user'), // Đổi thành IP backend nếu cần
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phoneController.text,
        'password': passwordController.text,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final token = data['token'];
      final userId = data['userId'];
      print(userId);
      await _writeToken(token, userId);
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
      setState(() => message = "Đăng nhập thất bại: ${data['message']}");
      showMessagePopup(message!);
    } else if (response.statusCode == 401) {
      setState(() => message = "Đăng nhập thất bại: ${data['message']}");
      showMessagePopup(message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 20),
            prefixIcon: Icon(Icons.person, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.green.shade100, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20),
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
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Mật khẩu',
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 20),
            prefixIcon: Icon(Icons.lock, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.green.shade100, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.green, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 400,
          child: ElevatedButton(
            onPressed: () {
              print(phoneController.text);
              print(passwordController.text);
              if (validateFields()) {
                logUser();
              } else {
                print("Vui lòng kiểm tra lại thông tin.");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Đăng nhập',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
