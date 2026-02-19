import 'package:clepsydra/data/time_block_model.dart';

import 'timer_model.dart';

abstract class RemoteDataSource {
  Future<TimerModel> createTimer(String title);
  Future<List<TimerModel>> getAllTimers();
  Future<TimeBlockModel> createTimeBlock(String timerId, Duration duration);
  Future<List<TimeBlockModel>> getAllTimeBlocksByTimerId(String timerId);
  Future<Map<String, dynamic>> loginWithGoogle(String idToken);
}
