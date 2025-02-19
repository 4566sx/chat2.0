import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'models/user.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 创建一个默认用户
    final defaultUser = User(
      id: '1',
      name: '访客',
      avatar: null,
    );

    return MaterialApp(
      title: '以马内利',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: SafeArea(
        child: ChatScreen(currentUser: defaultUser),
      ),
    );
  }
} 