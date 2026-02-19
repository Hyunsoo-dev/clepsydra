import 'package:clepsydra/data/timer_model.dart';
import 'package:clepsydra/screens/buttons/add_block_button.dart';
import 'package:clepsydra/screens/common/common_app_bar.dart';
import 'package:clepsydra/screens/time_tracker_screen.dart';
import 'package:clepsydra/screens/timer_card.dart';
import 'package:clepsydra/services/timer_service.dart'; // Service import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerList extends StatelessWidget {
  const TimerList({super.key});

  void _handleAddButton(BuildContext context) async {
    final TextEditingController titleController = TextEditingController();

    final String? title = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('타이머의 이름을 정해주세요', style: TextStyle(fontSize: 18)),
          content: TextField(
            controller: titleController,
            autofocus: true,
            decoration: const InputDecoration(hintText: '예) 요가 수업'),
            onSubmitted: (value) {
              Navigator.of(context).pop(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(titleController.text),
              child: const Text('만들기'),
            ),
          ],
        );
      },
    );

    if (title != null && title.trim().isNotEmpty) {
      if (!context.mounted) return;

      // Service를 통해 타이머 생성
      final timerService = context.read<TimerService>();
      final newTimer = await timerService.addTimer(title);
      debugPrint('newTimer: $newTimer');
      if (!context.mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              TimeTrackerScreen(mode: TimerMode.create, initialTimer: newTimer),
        ),
      );
    }
  }

  void _handleClickTimer(BuildContext context, TimerModel timer) async {
    print('timer: $timer');

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            TimeTrackerScreen(mode: TimerMode.edit, initialTimer: timer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerService = context.watch<TimerService>();
    final timers = timerService.timers;
    debugPrint('timer_list -> timers: ${timers.toString()}');
    return Scaffold(
      appBar: const CommonAppBar(),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              Expanded(
                child: GridView.builder(
                  itemCount: timers.length,
                  padding: const EdgeInsets.all(40.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final timer = timers[index];
                    return TimerCard(
                      title: timer.title,
                      onTap: () => _handleClickTimer(context, timer),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Hero(
        tag: 'new-timer',
        child: AddBlockButton(onTap: () => _handleAddButton(context)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
