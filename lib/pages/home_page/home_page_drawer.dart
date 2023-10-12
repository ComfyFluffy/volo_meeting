import 'package:volo_meeting/index.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SafeArea(
        child: BasedListView(
          children: [
            ProfileTile(),
            BasedListSection(
              elevation: 0,
              children: [
                AccountSecureTile(),
                SettingsTile(),
                HelpServiceTile(),
                AboutUsTile(),
              ],
            ),
            BasedListSection(
              elevation: 0,
              children: [
                LogoutTile(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
