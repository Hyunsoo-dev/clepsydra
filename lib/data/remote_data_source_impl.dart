import 'dart:convert';

import 'package:clepsydra/data/time_block_model.dart';
import 'package:clepsydra/data/timer_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:clepsydra/data/remote_data_source.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final String baseUrl = 'http://192.168.200.121:3000';

  String? _accessToken;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  @override
  Future<TimerModel> createTimer(String title) async {
    try {
      final url = Uri.parse('$baseUrl/timers');
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({'title': title}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('data: $data');
        debugPrint('TimerModel.fromJson(data): ${TimerModel.fromJson(data)}}');
        return TimerModel.fromJson(data);
      } else {
        throw Exception('서버 응답 에러: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error creating timer: $e');
      throw Exception('네트워크 연결 확인이 필요합니다: $e');
    }
  }

  @override
  Future<List<TimerModel>> getAllTimers() async {
    try {
      final url = Uri.parse('$baseUrl/timers');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        // debugPrint("jsonList: $jsonList");
        return jsonList.map((json) => TimerModel.fromJson(json)).toList();
      } else {
        throw Exception('서버 응답 에러: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('네트워크 연결 확인이 필요합니다: $e');
    }
  }

  @override
  Future<TimeBlockModel> createTimeBlock(
    String timerId,
    Duration duration,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/time-blocks');
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({'timerId': timerId, 'seconds': duration.inSeconds}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('서버 응답: ${response.body}');
        final data = jsonDecode(response.body);
        debugPrint(
          'data: $data, TimeBlockModel.fromJson(data): ${TimeBlockModel.fromJson(data)}',
        );
        return TimeBlockModel.fromJson(data);
      } else {
        throw Exception('서버 응답 에러: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('네트워크 연결 확인이 필요합니다: $e');
    }
  }

  @override
  Future<List<TimeBlockModel>> getAllTimeBlocksByTimerId(String timerId) async {
    try {
      final url = Uri.parse('$baseUrl/time-blocks?timerId=$timerId');
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        debugPrint('jsonList: $jsonList');

        return jsonList.map((json) => TimeBlockModel.fromJson(json)).toList();
      } else {
        throw Exception('서버 응답 에러: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('네트워크 연결 확인이 필요합니다: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    try {
      final url = Uri.parse('$baseUrl/auth/google/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = jsonDecode(response.body);
        debugPrint('loginWithGoogle result: $result');
        _accessToken = result['accessToken'];
        return result['user'];
      } else {
        throw Exception('서버 응답 에러: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(('네트워크 연결 확인이 필요합니다: $e'));
    }
  }
}
