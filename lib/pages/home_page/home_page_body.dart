import 'package:volo_meeting/index.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({
    super.key,
  });

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              width: 360,
              child: BasedListSection(
                mainAxisSize: MainAxisSize.min,
                itemPadding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '请输入会议号',
                      border: OutlineInputBorder(),
                      labelText: '会议号',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: FilledButton(
            onPressed: () {
              if (_controller.text.isInt) {
                context.push(
                  JoinMeetPage(
                    meetingId: _controller.text,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请检查会议号')),
                );
              }
            },
            child: const Text('加入会议'),
          ),
        ),
      ],
    );
  }
}
