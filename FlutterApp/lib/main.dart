import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medication_management_app/AppService.dart';
import 'package:medication_management_app/pages/add_medicin.dart';
import 'package:medication_management_app/pages/index.dart';
import 'package:medication_management_app/pages/log_reg_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final _plugin = FlutterLocalNotificationsPlugin();

class _MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();
  bool? _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await requestNotificationPermission();
    await _checkLoginStatus();
  }

  Future<void> requestNotificationPermission() async {
    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
  }

  Future<void> _checkLoginStatus() async {
    try {
      String? token = await storage
          .read(key: 'token')
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () {
              print('Storage read timed out');
              return null;
            },
          );
      print(token);

      if (token != null && token != "") {
        setState(() {
          _isLoggedIn = true;
        });
      }
      if (_isLoggedIn != null && _isLoggedIn == true) {
        await NotificationService.showNotification(
          0,
          "Thông báo đăng nhập thành công",
          "Bạn đã đăng nhập thành công vào ứng dụng quản lý thuốc",
        );
      }
      print('Token read: $token, isLoggedIn: $_isLoggedIn');
    } catch (e, stackTrace) {
      print('Error reading token: $e, StackTrace: $stackTrace');
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  Future<void> _logout() async {
    final currentContext = navigatorKey.currentContext;
    if (currentContext == null) {
      print("No valid context for showing dialog");
      return;
    }

    final shouldLogout = await showDialog<bool>(
      context: currentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận đăng xuất"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Hủy", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "Đăng xuất",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      try {
        await storage.delete(key: 'token');
        setState(() {
          _isLoggedIn = false;
        });

        await NotificationService.showNotification(
          0,
          "Thông báo",
          "Bạn đã đăng xuất thành công",
        );

        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          "/login",
          (route) => false,
        );
      } catch (e, stackTrace) {
        print('Error during logout: $e, StackTrace: $stackTrace');
        if (mounted) {
          ScaffoldMessenger.of(
            currentContext,
          ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
        }
      }
    }
  }

  void _onLoginSuccess() async {
    if (_isLoggedIn != null && _isLoggedIn == true) {
      await NotificationService.showNotification(
        0,
        "Thông báo đăng nhập thành công",
        "Bạn đã đăng nhập thành công vào ứng dụng quản lý thuốc",
      );
    }
    if (!mounted) {
      return;
    }
    try {
      setState(() {
        _isLoggedIn = true;
      });
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          "/",
          (route) => false,
        );
      } else {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamedAndRemoveUntil("/", (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Navigation failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          color: Colors.green,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: "/",
      routes: {
        "/":
            (context) =>
                _isLoggedIn == null
                    ? const Center(child: CircularProgressIndicator())
                    : _isLoggedIn!
                    ? IndexPage(onLogout: _logout, indexNum: 0)
                    : LogRegPage(onLoginSuccess: _onLoginSuccess),
        "/login": (context) => LogRegPage(onLoginSuccess: _onLoginSuccess),
        "/addMedicins": (context) => AddMedicinPage(),
        "/notification": (context) => IndexPage(onLogout: _logout, indexNum: 2),
      },
    );
  }
}

class CustomFABLocation extends FloatingActionButtonLocation {
  final double offsetY;
  CustomFABLocation({required this.offsetY});
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset defaultOffset = FloatingActionButtonLocation.endFloat
        .getOffset(scaffoldGeometry);
    return Offset(defaultOffset.dx, defaultOffset.dy - offsetY);
  }
}
