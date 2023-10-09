import 'package:volo_meeting/index.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BasedListTile(
      leadingIcon: Icons.settings_rounded,
      titleText: '设置',
      onTap: () => context.push(const SettingsPage()),
    );
  }
}
