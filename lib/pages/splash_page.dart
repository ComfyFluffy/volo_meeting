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
      rootPage:
          settings.username.isBlank ? const LoginPage() : const RootPage(),
      appIcon: SvgPicture.asset(
        context.brightness == Brightness.dark
            ? 'assets/images/fill_icon.svg'
            : 'assets/images/outline_icon.svg',
        width: 144,
        colorFilter: colorFilter,
      ),
      appName: SvgPicture.asset(
        'assets/images/logo.svg',
        width: 288,
        colorFilter: colorFilter,
      ),
    );
  }
}
