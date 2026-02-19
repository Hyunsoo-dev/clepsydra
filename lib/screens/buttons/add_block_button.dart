import 'package:flutter/material.dart';

class AddBlockButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddBlockButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1A1A2E),
          border: Border.all(
            color: const Color(0xFFD6A4FF).withValues(alpha: 0.8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB794F4).withValues(alpha: 0.5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
