import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  String _currentText = '';
  
  Future<void> init() async {
    await _flutterTts.setLanguage("zh-CN");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.9);
    await _flutterTts.setVolume(1.0);

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _currentText = '';
    });
  }

  Future<void> speakStream(String text) async {
    if (text.isEmpty) return;
    
    // 如果新的文本与当前正在播放的不同，则开始播放
    if (text != _currentText) {
      _currentText = text;
      
      // 分割文本为句子
      final sentences = text.split(RegExp(r'[。！？.!?]')).where((s) => s.isNotEmpty).toList();
      
      for (var sentence in sentences) {
        if (_currentText != text) {
          // 如果当前文本已经改变，说明有新的流入，停止当前播放
          break;
        }
        
        if (sentence.trim().isNotEmpty) {
          _isSpeaking = true;
          await _flutterTts.speak(sentence.trim());
          // 等待当前句子播放完成
          await Future.delayed(Duration(milliseconds: sentence.length * 200));
        }
      }
    }
  }

  Future<void> speak(String text) async {
    if (_isSpeaking) {
      await stop();
    }
    _isSpeaking = true;
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    _isSpeaking = false;
    _currentText = '';
    await _flutterTts.stop();
  }

  bool get isSpeaking => _isSpeaking;
} 