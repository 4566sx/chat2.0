import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'models/user.dart';
import 'services/tts_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TTSService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '以马内利',
      theme: AppTheme.lightTheme,
      home: ChatScreen(
        currentUser: User(
          name: "访客",
          avatarUrl: null,
        ),
      ),
    );
  }
} 