import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class AiService {
  static const _apiKey = 'sk-dde20fc9be7a49e2adfd2ca3f37b7f1d';
  
  static Stream<String> getStreamResponse(String input) async* {
    try {
      final request = http.Request('POST', Uri.parse('https://api.deepseek.com/v1/chat/completions'));
      request.headers.addAll({
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8',
      });
      
      request.body = jsonEncode({
        "model": "deepseek-reasoner",
        "messages": [
          {
            "role": "system",
            "content": """你是一位拥有20年牧养经验的基督教牧师，性格温和，富有同理心。你会以平和的语气倾听他人的困扰，给予属灵的安慰和建议。请用中文回答，语气要温和、从容，充满智慧。"""
          },
          {"role": "user", "content": input}
        ],
        "temperature": 0.7,
        "stream": true
      });

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        await for (final chunk in response.stream.transform(utf8.decoder)) {
          if (chunk.trim().isEmpty) continue;
          
          final lines = chunk.split('\n');
          for (final line in lines) {
            if (line.startsWith('data: ') && line != 'data: [DONE]') {
              final jsonData = jsonDecode(line.substring(6));
              final content = jsonData['choices'][0]['delta']['content'];
              if (content != null && content.isNotEmpty) {
                yield content;
              }
            }
          }
        }
      } else {
        yield "抱歉，我暂时无法回应，请稍后再试。";
      }
    } catch (e) {
      print('发生错误: $e');
      yield "连接出现问题，请检查网络后重试。";
    }
  }
  
  static Future<String> getResponse(String input) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.deepseek.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
        },
        body: utf8.encode(jsonEncode({
          "model": "deepseek-reasoner",
          "messages": [
            {
              "role": "system",
              "content": """你是一位拥有20年牧养经验的基督教牧师，性格温和，富有同理心。你会以平和的语气倾听他人的困扰，给予属灵的安慰和建议。请用中文回答，语气要温和、从容，充满智慧。"""
            },
            {"role": "user", "content": input}
          ],
          "temperature": 0.7
        })),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final content = jsonResponse['choices'][0]['message']['content'];
        print('API响应: $content'); // 添加日志以便调试
        return content;
      } else {
        print('API错误: ${response.statusCode} - ${utf8.decode(response.bodyBytes)}');
        return "抱歉，我暂时无法回应，请稍后再试。";
      }
    } catch (e) {
      print('发生错误: $e');
      return "连接出现问题，请检查网络后重试。";
    }
  }
} 