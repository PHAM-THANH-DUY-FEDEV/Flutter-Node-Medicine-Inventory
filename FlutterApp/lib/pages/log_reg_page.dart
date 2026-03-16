import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medication_management_app/pages/components/LogForm.dart';
import 'package:medication_management_app/pages/components/RegForm.dart';

class LogRegPage extends StatefulWidget {
  final VoidCallback onLogRegSuccess;
  const LogRegPage({super.key, required this.onLogRegSuccess});
  @override
  State<LogRegPage> createState() => _LogRegPageState();
}

class _LogRegPageState extends State<LogRegPage> {
  bool isLoginForm = true;
  final storage = FlutterSecureStorage();
  void toggleLogin() {
    setState(() {
      isLoginForm = !isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          "Medicins Managemen",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.green[200],
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(top: 20),
          child: Container(
            alignment: Alignment.topCenter,
            width: 380,
            height: isLoginForm ? 530 : 770,
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 10,
                  blurRadius: 7,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  width: 400,
                  margin: EdgeInsets.only(bottom: 10, top: 10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          toggleLogin();
                        },

                        child: Container(
                          width: 164,
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 20,
                            right: 20,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                isLoginForm
                                    ? Colors.white
                                    : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:
                                  !isLoginForm
                                      ? Colors.green.shade300
                                      : Colors.green,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          toggleLogin();
                        },
                        child: Container(
                          width: 164,
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 20,
                            right: 20,
                          ),
                          decoration: BoxDecoration(
                            color:
                                !isLoginForm
                                    ? Colors.white
                                    : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:
                                  isLoginForm
                                      ? Colors.green.shade300
                                      : Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                isLoginForm
                    ? LogForm(
                      onLogRegSuccess: () {
                        widget.onLogRegSuccess();
                      },
                    )
                    : RegForm(
                      onLogRegSuccess: () {
                        widget.onLogRegSuccess();
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
