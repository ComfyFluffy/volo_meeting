import 'package:volo_meeting/index.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('个人信息')),
      body: const BasedListView(
        children: [
          BasedListSection(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: BasedAvatar(
                    size: 128,
                  ),
                ),
              ),
              ProfileNameTile(),
              DeviceIdTile(),
            ],
          ),
          BasedListSection(
            children: [
              ProfileCardTile(),
            ],
          ),
        ],
      ),
    );
  }
}
