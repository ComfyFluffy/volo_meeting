import 'package:volo_meeting/index.dart';

class RTCVideoView extends StatelessWidget {
  const RTCVideoView(
    this.renderer, {
    super.key,
    this.filterQuality = FilterQuality.low,
    this.placeholderBuilder,
  });

  final RTCVideoRenderer renderer;
  final FilterQuality filterQuality;
  final WidgetBuilder? placeholderBuilder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ValueListenableBuilder(
          valueListenable: renderer,
          builder: (context, value, child) {
            return renderer.renderVideo
                ? AspectRatio(
                    aspectRatio: value.aspectRatio,
                    child: Texture(
                      textureId: renderer.textureId!,
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
