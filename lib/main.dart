import 'package:volo_meeting/index.dart';

void main() => VoloMeeting.run();

class VoloMeetingApp extends StatelessWidget {
  const VoloMeetingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: VoloMeeting.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const HomePage(),
    );
  }
}
