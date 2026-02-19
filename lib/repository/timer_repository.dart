import 'package:clepsydra/data/remote_data_source.dart';
import 'package:clepsydra/data/time_block_model.dart';
import 'package:clepsydra/data/timer_model.dart';
import 'package:clepsydra/services/user_provider.dart';
// import 'package:clepsydra/time_block.dart';
import 'package:flutter/foundation.dart';

class TimerRepository {
  final RemoteDataSource _remote;
  final bool Function() _isAuthenticated;
  // 게스트용 저장소
  final List<TimerModel> _guestTimers = [];
  final Map<String, List<TimeBlockModel>> _guestTimeBlocks = {};
  TimerRepository({
    required RemoteDataSource remote,
    required bool Function() isAuthenticated,
  }) : _remote = remote,
       _isAuthenticated = isAuthenticated;
  // final userProvider = context.read<UserProvider>().isAuthenticated;

  // 새로운 타이머 추가
  Future<TimerModel> addTimer(String title) async {
    if (_isAuthenticated()) {
      try {
        debugPrint("회원 모드: 리모트 DB에 타이머를 생성합니다.");
        final remoteTimer = await _remote.createTimer(title);
        return remoteTimer;
      } catch (e) {
        throw Exception('서버에 타이머를 생성하지 못했습니다.');
      }
    }
    debugPrint("비회원 모드: 로컬 DB에 타이머를 생성합니다.");
    final now = DateTime.now();
    final newTimer = TimerModel(
      id: now.millisecondsSinceEpoch.toString(), // 임시 ID
      title: title,
      createdAt: now,
      updatedAt: now,
      deletedAt: null,
    );

    _guestTimers.add(newTimer);
    return newTimer;
  }

  // 모든 타이머 가져오기
  Future<List<TimerModel>> getAllTimers() async {
    if (_isAuthenticated()) {
      try {
        debugPrint("회원 모드: 리모트 DB에서 데이터를 가져옵니다.");
        return await _remote.getAllTimers();
      } catch (e) {
        throw Exception('서버에서 데이터를 불러올 수 없습니다: $e');
      }
    }

    debugPrint("비회원 모드: 로컬 DB에서 데이터를 가져옵니다.");
    return _guestTimers.toList();
  }

  // 타임 블록 추가
  Future<void> createTimeBlock(String timerId, Duration duration) async {
    debugPrint('addTimeBlock called -> timerId: $timerId, duration: $duration');

    if (_isAuthenticated()) {
      try {
        debugPrint("회원 모드: 리모트 DB에 타임 블록을 생성합니다.");
        await _remote.createTimeBlock(timerId, duration);
      } catch (e) {
        throw Exception('서버에 타임 블록을 생성하지 못했습니다.');
      }
    } else {
      debugPrint("비회원 모드: 로컬 DB에 타임 블록을 생성합니다.");
      final now = DateTime.now();
      final newBlock = TimeBlockModel(
        id: now.millisecondsSinceEpoch.toString(),
        seconds: duration.inSeconds,
        createdAt: now,
        updatedAt: now,
      );

      _guestTimeBlocks.putIfAbsent(timerId, () => []);
      _guestTimeBlocks[timerId]!.add(newBlock);
    }
  }

  // 타임 블록 가져오기
  Future<List<TimeBlockModel>> getAllTimeBlocksByTimerId(String timerId) async {
    if (_isAuthenticated()) {
      try {
        debugPrint("회원 모드: 리모트 DB에서 타임 블록을 가져옵니다.");
        return await _remote.getAllTimeBlocksByTimerId(timerId);
      } catch (e) {
        throw Exception('서버에서 데이터를 불러올 수 없습니다: $e');
      }
    }
    debugPrint("비회원 모드: 로컬 DB에서 타임 블록을 가져옵니다.");
    return _guestTimeBlocks[timerId] ?? [];
  }

  // 타이머 삭제
  Future<void> deleteTimer(int timerId) async {
    // await _local.deleteTimer(timerId);

    // TODO: 서버에서도 삭제 요청 보내기
  }
}
