import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';

class TimerScreen extends StatefulWidget {
  final List<Duration> durations;

  const TimerScreen({super.key, required this.durations});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  int _currentDurationIndex = 0;
  bool _isFlashing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.durations.isNotEmpty
          ? widget.durations[0]
          : const Duration(seconds: 1),
    );

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _toggleFlash();
        // Vibration.vibrate(duration: 300);

        if (await Vibration.hasVibrator()) {
          await Vibration.vibrate();
        }

        if (!mounted) return;

        setState(() {
          _currentDurationIndex++;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_currentDurationIndex < widget.durations.length) {
            _controller.duration = widget.durations[_currentDurationIndex];
            _controller.forward(from: 0.0);
          } else {
            Navigator.of(context).pop();
          }
        });
      }
    });

    if (widget.durations.isNotEmpty) {
      _controller.forward();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    Vibration.cancel();
    super.dispose();
  }

  void _toggleFlash() {
    if (!mounted) return;

    setState(() {
      _isFlashing = true;

      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        setState(() {
          _isFlashing = false;
        });
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final bool hasActiveTimer = _currentDurationIndex < widget.durations.length;
    final Duration currentBlockDuration = hasActiveTimer
        ? widget.durations[_currentDurationIndex]
        : Duration.zero;

    return Scaffold(
      backgroundColor: const Color(0xFF121221),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 배경 레이어
          Center(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/clepsydra.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          // 컨텐츠 레이어
          Center(
            child: Hero(
              tag: 'timer-hero-tag',
              child: Material(
                type: MaterialType.transparency,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      'assets/lottie/glass.json',
                      controller: _controller,
                      width: 400,
                      height: 400,
                      fit: BoxFit.contain,
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget? child) {
                        double remainingTime =
                            currentBlockDuration.inSeconds *
                            (1.0 - _controller.value);
                        Duration remainingTimeCeil = Duration(
                          seconds: remainingTime.ceil(),
                        );
                        return Text(
                          _formatDuration(remainingTimeCeil),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    AnimatedOpacity(
                      opacity: _isFlashing ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
