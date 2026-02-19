import 'dart:async';

import 'package:clepsydra/data/timer_model.dart';
import 'package:clepsydra/screens/buttons/play_button.dart';
import 'package:clepsydra/screens/timer_screen.dart';
import 'package:clepsydra/services/time_block_service.dart';
import 'package:clepsydra/services/timer_service.dart';
import 'package:clepsydra/time_block.dart';
import 'package:clepsydra/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TimerMode { create, edit }

class TimeTrackerScreen extends StatefulWidget {
  final TimerModel? initialTimer;
  final TimerMode mode;

  const TimeTrackerScreen({super.key, required this.mode, this.initialTimer});

  @override
  State<TimeTrackerScreen> createState() => _TimeTrackerScreenState();
}

class _TimeTrackerScreenState extends State<TimeTrackerScreen> {
  late String title = '';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    title = widget.initialTimer?.title ?? '';

    Future.microtask(() {
      final timerId = widget.initialTimer?.id;
      if (timerId != null) {
        context.read<TimerService>().getAllTimeBlocksByTimerId(timerId);
      }
    });
  }

  void _addDuration(Duration duration) async {
    final timerId = widget.initialTimer?.id;

    if (timerId != null) {
      final timerService = context.read<TimerService>();
      debugPrint('_addDuration timerId: $timerId, duration: $duration');
      timerService.createTimeBlock(timerId, duration);
    }
  }

  // void _stopTimer() {
  //   _timer?.cancel();
  //   // _isPlaying = false;
  //   setState(() {});
  // }

  void _handlePlayButton() {
    final timerService = context.read<TimerService>();
    final timeBlocks = timerService.timeblocks;

    final List<Duration> durations = timeBlocks.map((timeBlock) {
      return Duration(seconds: timeBlock.seconds);
    }).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TimerScreen(durations: durations),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerService = context.watch<TimerService>();
    final timeBlocks = timerService.timeblocks;

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.transparent),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/clepsydra.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12.0),
                  itemCount: timeBlocks.length,
                  itemBuilder: (BuildContext context, int index) {
                    final duration = Duration(
                      seconds: timeBlocks[index].seconds,
                    );
                    return TimeBlock(duration: duration);
                  },
                ),
              ),
              const SizedBox(height: 130), // FAB 영역 확보를 위한 여백
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimePicker(onTimeSelected: _addDuration),
          if (timeBlocks.isNotEmpty) ...[
            const SizedBox(width: 20),
            Hero(
              tag: 'timer-hero-tag',
              child: PlayButton(onTap: _handlePlayButton),
            ),
          ],
        ],
      ),
    );
  }
}
