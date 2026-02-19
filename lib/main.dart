import 'package:clepsydra/data/remote_data_source_impl.dart';
import 'package:clepsydra/repository/timer_repository.dart';
import 'package:clepsydra/screens/timer_list.dart';
import 'package:clepsydra/services/auth_service.dart';

import 'package:clepsydra/services/timer_service.dart';
import 'package:clepsydra/services/user_provider.dart';
// import 'package:clepsydra/time_tracker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final remoteDataSource = RemoteDataSourceImpl();
  final authService = AuthService();

  final userProvider = UserProvider(
    authService: authService,
    remote: remoteDataSource,
  );

  final timerRepository = TimerRepository(
    remote: remoteDataSource,
    isAuthenticated: () => userProvider.isAuthenticated,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerService(timerRepository)),
        ChangeNotifierProvider.value(value: userProvider),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121221),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.green,
          ),
        ),
      ),
      home: const TimerList(),
    );
  }
}
