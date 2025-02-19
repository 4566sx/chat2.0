import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../models/message.dart';
import '../theme/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.sender != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 12, right: 12),
                child: Text(
                  message.sender!.name,
                  style: GoogleFonts.notoSerif(
                    fontSize: 12,
                    color: AppColors.navy.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(message.isUser ? 20 : 5),
                bottomRight: Radius.circular(message.isUser ? 5 : 20),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: message.isUser 
                      ? AppColors.userMessageBg.withOpacity(0.95)
                      : AppColors.botMessageBg.withOpacity(0.95),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(message.isUser ? 20 : 5),
                      bottomRight: Radius.circular(message.isUser ? 5 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                    border: Border.all(
                      color: message.isUser 
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.notoSerif(
                      color: message.isUser ? Colors.white : AppColors.textPrimary,
                      fontSize: 16,
                      height: 1.5,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 