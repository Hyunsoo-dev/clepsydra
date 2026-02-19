import 'package:clepsydra/data/time_block_model.dart';
import 'package:flutter/material.dart';
import 'package:clepsydra/repository/timer_repository.dart';
import 'package:clepsydra/data/timer_model.dart';
import 'package:flutter/foundation.dart'; // debugPrint용

class TimerService extends ChangeNotifier {
  final TimerRepository _timerRepository;
  List<TimerModel> _timers = [];
  List<TimerModel> get timers => _timers;

  List<TimeBlockModel> _timeBlocks = [];
  List<TimeBlockModel> get timeblocks => _timeBlocks;

  TimerService(this._timerRepository) {
    getAllTimers();
  }

  // DB에서 타이머 목록을 새로고침하고 UI에 알림
  Future<void> getAllTimers() async {
    _timers = await _timerRepository.getAllTimers();
    debugPrint('getAllTimers : $_timers');
    notifyListeners();
  }

  // 타이머 추가하기
  Future<TimerModel> addTimer(String title) async {
    final newTimer = await _timerRepository.addTimer(title);
    await getAllTimers();
    return newTimer;
  }

  // 기록 추가하기
  Future<void> createTimeBlock(String timerId, Duration duration) async {
    await _timerRepository.createTimeBlock(timerId, duration);
    await getAllTimeBlocksByTimerId(timerId);
  }

  // 타임 블록 가져오기
  Future<void> getAllTimeBlocksByTimerId(String timerId) async {
    _timeBlocks = await _timerRepository.getAllTimeBlocksByTimerId(timerId);
    debugPrint('getAllTimeBlocksByTimerId _timeBlocks: $_timeBlocks');
    notifyListeners();
  }
}
