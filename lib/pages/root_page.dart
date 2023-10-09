import 'package:volo_meeting/index.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({
    super.key,
  });

  @override
  ConsumerState<RootPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<RootPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const destinationModel = _NavigationDestinationModel(
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.videocam_rounded),
          label: '会议',
        ),
        NavigationDestination(
          icon: Icon(Icons.history_rounded),
          label: '历史',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month_rounded),
          label: '预订',
        ),
      ],
      bodies: [
        HomePage(key: ValueKey(HomePage)),
        HistoryPage(key: ValueKey(HistoryPage)),
        SchedulePage(key: ValueKey(SchedulePage)),
      ],
    );

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: destinationModel.bodies[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: destinationModel.destinations,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (value) =>
            setState(() => _selectedIndex = value),
      ),
    );
  }
}

class _NavigationDestinationModel {
  const _NavigationDestinationModel({
    required this.destinations,
    required this.bodies,
  });
  final List<NavigationDestination> destinations;
  final List<Widget> bodies;
}
