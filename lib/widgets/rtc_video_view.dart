import 'package:volo_meeting/index.dart';

class RTCVideoView extends StatelessWidget {
  const RTCVideoView(
    this._renderer, {
    super.key,
    this.filterQuality = FilterQuality.low,
    this.placeholderBuilder,
  });

  final RTCVideoRenderer _renderer;
  final FilterQuality filterQuality;
  final WidgetBuilder? placeholderBuilder;

  RTCVideoRenderer get videoRenderer => _renderer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ValueListenableBuilder(
          valueListenable: videoRenderer,
          builder: (context, value, child) {
            VoloMeeting.printLog('$videoRenderer $value');
            return videoRenderer.renderVideo
                ? AspectRatio(
                    aspectRatio: value.aspectRatio,
                    child: Texture(
                      textureId: videoRenderer.textureId!,
                      filterQuality: filterQuality,
                    ),
                  )
                : placeholderBuilder?.call(context) ?? const SizedBox();
          },
        ),
      ),
    );
  }
}
