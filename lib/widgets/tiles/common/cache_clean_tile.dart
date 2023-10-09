import 'package:volo_meeting/index.dart';

class CacheCleanTile extends StatelessWidget {
  const CacheCleanTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BasedListTile(
      leadingIcon: Icons.cleaning_services_rounded,
      titleText: '应用缓存清理',
      onTap: () {},
    );
  }
}
