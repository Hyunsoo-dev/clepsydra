import 'package:clepsydra/screens/buttons/add_block_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimePicker extends StatefulWidget {
  final void Function(Duration duration) onTimeSelected;

  const TimePicker({super.key, required this.onTimeSelected});

  @override
  State<StatefulWidget> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  Duration duration = const Duration(hours: 0, minutes: 5, seconds: 30);

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts
  // a CupertinoTimerPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 280,
        padding: const EdgeInsets.only(top: 6.0),

        // The bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB191FF), // 상단은 밝게
              Color(0xFF8B63E6), // 중간
              Color(0xFF6A3CC9), // 중간 보라색 (Deep Purple 700)
            ],
          ),
        ),
        // color: const Color.fromARGB(255, 105, 84, 145),
        // CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    sizeStyle: CupertinoButtonSize.medium,
                    child: const Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onTimeSelected(duration);
                    },
                  ),
                ],
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AddBlockButton(
      onTap: () {
        _showDialog(
          CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hms,
            initialTimerDuration: duration,
            onTimerDurationChanged: (Duration newDuration) {
              setState(() => duration = newDuration);
            },
          ),
        );
      },
    );
  }
}
