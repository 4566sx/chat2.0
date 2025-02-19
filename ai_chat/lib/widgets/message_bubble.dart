import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../models/message.dart';
import '../theme/app_colors.dart';
import '../services/tts_service.dart';

class MessageBubble extends StatefulWidget {
  final Message message;

  const MessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final TTSService _tts = TTSService();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (!widget.message.isUser) {
      _startSpeaking();
    }
  }

  @override
  void didUpdateWidget(MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.message.isUser && widget.message.text != oldWidget.message.text) {
      _startSpeaking();
    }
  }

  void _startSpeaking() {
    if (widget.message.text.isNotEmpty) {
      _tts.speakStream(widget.message.text);
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            widget.message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.message.isUser) ...[
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.message.isUser
                    ? AppColors.primary
                    : AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message.text,
                    style: TextStyle(
                      color: widget.message.isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (!widget.message.isUser && widget.message.text.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.stop : Icons.play_arrow,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          onPressed: () {
                            if (_isPlaying) {
                              _tts.stop();
                              setState(() {
                                _isPlaying = false;
                              });
                            } else {
                              _startSpeaking();
                            }
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (widget.message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                widget.message.sender?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_isPlaying) {
      _tts.stop();
    }
    super.dispose();
  }
} 