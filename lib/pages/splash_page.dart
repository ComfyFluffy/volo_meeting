import 'package:volo_meeting/index.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final colorFilter = ColorFilter.mode(
      context.colorScheme.outline,
      BlendMode.srcIn,
    );

    return BasedSplashPage(
      rootPage: settings.username.isBlank ? const UserPage() : const HomePage(),
      appIcon: context.brightness == Brightness.dark
          ? SvgPicture.asset(
              'assets/images/fill_icon.svg',
              width: 144,
              colorFilter: colorFilter,
            )
          : SvgPicture.asset('assets/images/outline_icon.svg'),
      appName: SvgPicture.asset(
        'assets/images/logo.svg',
        width: 288,
        colorFilter: colorFilter,
      ),
    );
  }
}
