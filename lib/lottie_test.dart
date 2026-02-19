import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyTimerPage extends StatefulWidget {
  const MyTimerPage({super.key});

  @override
  State<MyTimerPage> createState() => _MyTimerPageState();
}

class _MyTimerPageState extends State<MyTimerPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 10초 동안 애니메이션이 한 번 흐르도록 설정
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // 메모리 해제 필수!
    super.dispose();
  }

  void _startTimer() {
    _controller.forward(); // 애니메이션 시작 (0.0 -> 1.0)
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset(
              alignment: Alignment.center,

              'assets/lottie/glass.json',
              controller: _controller, // 컨트롤러 연결
              fit: BoxFit.contain,
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                Duration remainingTime =
                    _controller.duration! * (1.0 - _controller.value);

                return Text(_formatDuration(remainingTime));
              },
            ),
          ],
        ),
        ElevatedButton(onPressed: _startTimer, child: const Text("타이머 시작")),
        // Stack(
        //   fit: StackFit.expand,
        //   alignment: Alignment.center,
        //   children: [
        //     Lottie.asset(
        //       'assets/lottie/hourglass.json',
        //       controller: _controller, // 컨트롤러 연결
        //       fit: BoxFit.contain,
        //     ),
        //     Text('10:0:0'),
        //     ElevatedButton(onPressed: _startTimer, child: Text("타이머 시작")),
        //   ],
        // ),
      ],
    );
  }
}
