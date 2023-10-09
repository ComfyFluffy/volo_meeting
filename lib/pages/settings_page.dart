import 'package:volo_meeting/index.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: const BasedListView(
        children: [
          AudioSettingSection(),
          VideoSettingSection(),
          GeneralSettingSection(),
          LoginSettingSection(),
        ],
      ),
    );
  }
}
