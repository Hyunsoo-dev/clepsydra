import 'package:flutter/material.dart';

class ElegantPurpleButton extends StatelessWidget {
  final Duration duration;

  const ElegantPurpleButton({super.key, required this.duration});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // 1. 외부 광채 (Outer Glow)
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D7AF2).withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
          // 하단 깊이감을 위한 어두운 그림자
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
        // 2. 메인 그라데이션 (더 다채로운 보라색 조합)
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB191FF), // 상단은 밝게
            Color(0xFF8B63E6), // 중간
            Color(0xFF6A3CC9), // 하단은 진하게
          ],
        ),
        // 3. 상단 밝은 테두리 (유리 같은 느낌 추가)
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // 4. 안쪽 상단 하이라이트 (Glossy 효과의 핵심)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            // 콘텐츠 (아이콘 및 텍스트)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.auto_awesome, // 반짝이는 아이콘
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _formatDuration(duration),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400, // 너무 두껍지 않게
                      fontFamily: 'Courier', // 타이머 느낌을 주는 폰트 (선택사항)
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
