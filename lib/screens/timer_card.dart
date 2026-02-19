import 'package:flutter/material.dart';

class TimerCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const TimerCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // GridView에서 크기가 제어되므로 width/height는 지정하지 않음
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          // 1. 외부 광채 (Outer Glow)
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9D7AF2).withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            // 하단 깊이감을 위한 어두운 그림자
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ],
          // 2. 메인 그라데이션 (TimeBlock과 유사한 보라색 테마)
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB191FF), // 상단은 밝게
              Color(0xFF8B63E6), // 중간
              Color(0xFF6A3CC9), // 하단은 진하게
            ],
          ),
          // 3. 상단 밝은 테두리 (유리 같은 느낌)
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Stack(
            children: [
              // 4. 안쪽 상단 하이라이트 (Glossy 효과)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60, // 카드 크기에 맞춰 높이 조정
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
              // 콘텐츠 (타이틀)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
