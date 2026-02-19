import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TimeBlockService {
  static const String baseUrl = 'http://172.30.1.76:3000';

  // 타임 블록 생성
  // POST /time-blocks
  Future<bool> createTimeBlock(String timerId, Duration duration) async {
    try {
      final url = Uri.parse('$baseUrl/time-blocks');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'timerId': timerId, 'seconds': duration.inSeconds}),
      );

      print('response.statusCode => ${response.statusCode}');
      print('response.body => ${response.body}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        debugPrint(
          'Failed to create block: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error creating time block: $e');
      return false;
    }
  }

  // 타임 블록 전체 목록 조회
  // GET /time-blocks?timerId=:timerId
  Future<List<Duration>> getAllTimeBlocks(String timerId) async {
    try {
      final url = Uri.parse('$baseUrl/time-blocks?timerId=$timerId');
      print('timerId: $timerId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('response.statusCode => ${response.statusCode}');
      print('response.body => ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        return jsonList
            .map((json) => Duration(seconds: json['seconds']))
            .toList();
      } else {
        throw Exception(
          'Failed to get all time blocks: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error getting all time blocks: $e');
      throw Exception('데이터를 불러오는데 실패했습니다.');
    }
  }
}
