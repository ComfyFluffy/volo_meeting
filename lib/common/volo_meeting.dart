import 'package:volo_meeting/index.dart';
import 'dart:developer' as devtools show log;

class VoloMeeting {
  const VoloMeeting._();

  static const appName = 'Volo Meeting';

  static void run() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }

    runApp(const VoloMeetingApp());
  }

  static void printLog(dynamic log) =>
      devtools.log(log, time: DateTime.now(), name: appName);
}
