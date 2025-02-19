import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'ai_service.dart';
import 'models/message.dart';
import 'models/user.dart';
import 'theme/app_colors.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final User currentUser;
  
  const ChatScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  String _currentStreamResponse = '';

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(Message(
        text: "原主的平安与你同在，我是约翰牧师，很高兴能遇见你。请告诉我，我能为你做什么？",
        isUser: false,
      ));
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _messages.add(Message(
        text: text,
        isUser: true,
        sender: widget.currentUser,
      ));
      _controller.clear();
      _isLoading = true;
      _currentStreamResponse = '';
      _messages.add(Message(
        text: '',
        isUser: false,
      ));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      await for (final chunk in AiService.getStreamResponse(text)) {
        setState(() {
          _currentStreamResponse += chunk;
          _messages.last = Message(
            text: _currentStreamResponse,
            isUser: false,
          );
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    } catch (e) {
      setState(() {
        _messages.last = Message(
          text: "抱歉，发生了一些错误。让我们一起祷告寻求主的帮助。",
          isUser: false,
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundPrimary,
              AppColors.backgroundSecondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '以马内利',
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      itemCount: _messages.length,
                      itemBuilder: (context, i) => MessageBubble(message: _messages[i]),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundElevated,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -1),
                      blurRadius: 8,
                      color: AppColors.shadow,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      if (_isLoading)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const CupertinoActivityIndicator(),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadow,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                    hintText: '分享你的想法...',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  ),
                                  maxLines: null,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (_) => _sendMessage(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.gradientStart,
                                    AppColors.gradientEnd,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(25),
                                  onTap: _sendMessage,
                                  child: const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Icon(
                                      Icons.send_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
} 