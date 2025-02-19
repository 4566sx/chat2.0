import 'user.dart';

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final User? sender;

  Message({
    required this.text,
    required this.isUser,
    User? sender,
    DateTime? timestamp,
  })  : this.sender = sender,
        this.timestamp = timestamp ?? DateTime.now();
} 