import 'package:volo_meeting/index.dart';

class LoginSettingSection extends StatelessWidget {
  const LoginSettingSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const BasedListSection(
      children: [
        NetworkDetectTile(),
        ProxySettingTile(),
        CacheCleanTile(),
        NewReleaseTile(),
        AboutUsTile(),
      ],
    );
  }
}
