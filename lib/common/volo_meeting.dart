import 'package:volo_meeting/index.dart';
import 'dart:developer' as devtools show log;

class VoloMeeting {
  const VoloMeeting._();

  static const appName = 'Volo Meeting';

  static void run() async {
    WidgetsFlutterBinding.ensureInitialized();

    await androidInit();

    runApp(
      ProviderScope(
        overrides: [
          persistenceProvider.overrideWithValue(await Persistence.init()),
        ],
        child: const VoloMeetingApp(),
      ),
    );
  }

  static Future<void> androidInit() async {
    if (!UniversalPlatform.isAndroid) return;
    await FlutterDisplayMode.setHighRefreshRate();
  }

  static void printLog(dynamic log) =>
      devtools.log('$log', time: DateTime.now(), name: appName);
}
