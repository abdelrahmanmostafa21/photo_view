import 'package:flutter/material.dart';
import 'package:photo_view/src/controller/photo_view_controller.dart';
import 'package:photo_view/src/core/photo_view_core.dart';
import 'package:photo_view/src/photo_view_computed_scale.dart';
import 'package:photo_view/src/photo_view_wrappers.dart';
import 'package:photo_view/src/utils/photo_view_hero_attributes.dart';

export 'src/controller/photo_view_controller.dart';
export 'src/core/photo_view_gesture_detector.dart'
    show PhotoViewGestureDetectorScope;
export 'src/photo_view_computed_scale.dart';
export 'src/utils/photo_view_hero_attributes.dart';

/// A type definition for a callback to show a widget while the image is loading, a [ImageChunkEvent] is passed to inform progress
typedef LoadingBuilder = Widget Function(
  BuildContext context,
  ImageChunkEvent? event,
);

class PhotoView extends StatefulWidget {
  const PhotoView({
    super.key,
    required this.imageProvider,
    this.loadingBuilder,
    this.backgroundDecoration = const BoxDecoration(color: Color(0xff000000)),
    this.wantKeepAlive = false,
    this.semanticLabel,
    this.gaplessPlayback = false,
    this.heroAttributes,
    this.enableRotation = false,
    this.controller,
    this.maxScale,
    this.minScale,
    this.initialScale,
    this.basePosition,
    this.onTapUp,
    this.onTapDown,
    this.onScaleEnd,
    this.customSize,
    this.gestureDetectorBehavior,
    this.tightMode = false,
    this.filterQuality,
    this.disableGestures = false,
    this.errorBuilder,
    this.enablePanAlways = false,
    this.strictScale = false,
  })  : child = null,
        childSize = null;

  const PhotoView.customChild({
    super.key,
    required this.child,
    this.childSize,
    this.backgroundDecoration = const BoxDecoration(color: Color(0xff000000)),
    this.wantKeepAlive = false,
    this.heroAttributes,
    this.enableRotation = false,
    this.controller,
    this.maxScale,
    this.minScale,
    this.initialScale,
    this.basePosition,
    this.onTapUp,
    this.onTapDown,
    this.onScaleEnd,
    this.customSize,
    this.gestureDetectorBehavior,
    this.tightMode = false,
    this.filterQuality,
    this.disableGestures = false,
    this.enablePanAlways = false,
    this.strictScale = false,
  })  : errorBuilder = null,
        imageProvider = null,
        semanticLabel = null,
        gaplessPlayback = false,
        loadingBuilder = null;

  /// Given a [imageProvider] it resolves into an zoomable image widget using. It
  /// is required
  final ImageProvider? imageProvider;

  /// While [imageProvider] is not resolved, [loadingBuilder] is called by [PhotoView]
  /// into the screen, by default it is a centered [CircularProgressIndicator]
  final LoadingBuilder? loadingBuilder;

  /// Show loadFailedChild when the image failed to load
  final ImageErrorWidgetBuilder? errorBuilder;

  /// Changes the background behind image.
  final BoxDecoration backgroundDecoration;

  /// This is used to keep the state of an image in the gallery (e.g. scale state).
  /// `false` -> resets the state (default)
  /// `true`  -> keeps the state
  final bool wantKeepAlive;

  /// A Semantic description of the image.
  ///
  /// Used to provide a description of the image to TalkBack on Android, and VoiceOver on iOS.
  final String? semanticLabel;

  /// This is used to continue showing the old image (`true`), or briefly show
  /// nothing (`false`), when the `imageProvider` changes. By default it's set
  /// to `false`.
  final bool gaplessPlayback;

  /// Attributes that are going to be passed to [PhotoViewCore]'s
  /// [Hero]. Leave this property undefined if you don't want a hero animation.
  final PhotoViewHeroAttributes? heroAttributes;

  /// Defines the size of the scaling base of the image inside [PhotoView].
  final Size? customSize;

  /// A flag that enables the rotation gesture support
  final bool enableRotation;

  /// The specified custom child to be shown instead of a image
  final Widget? child;

  /// The size of the custom [child]. [PhotoView] uses this value to compute the relation between the child and the container's size to calculate the scale value.
  final Size? childSize;

  /// Defines the maximum size in which the image will be allowed to assume, it
  /// is proportional to the original image size. Can be either a double (absolute value) or a
  /// [PhotoViewComputedScale], that can be multiplied by a double
  final dynamic maxScale;

  /// Defines the minimum size in which the image will be allowed to assume, it
  /// is proportional to the original image size. Can be either a double (absolute value) or a
  /// [PhotoViewComputedScale], that can be multiplied by a double
  final dynamic minScale;

  /// Defines the initial size in which the image will be assume in the mounting of the component, it
  /// is proportional to the original image size. Can be either a double (absolute value) or a
  /// [PhotoViewComputedScale], that can be multiplied by a double
  final dynamic initialScale;

  /// A way to control PhotoView transformation factors externally and listen to its updates
  final PhotoViewController? controller;

  /// The alignment of the scale origin in relation to the widget size. Default is [Alignment.center]
  final Alignment? basePosition;

  /// A pointer that will trigger a tap has stopped contacting the screen at a
  /// particular location.
  final GestureTapUpCallback? onTapUp;

  /// A pointer that might cause a tap has contacted the screen at a particular
  /// location.
  final GestureTapDownCallback? onTapDown;

  /// A pointer that will trigger a scale has stopped contacting the screen at a
  /// particular location.
  final GestureScaleEndCallback? onScaleEnd;

  /// [HitTestBehavior] to be passed to the internal gesture detector.
  final HitTestBehavior? gestureDetectorBehavior;

  /// Enables tight mode, making background container assume the size of the image/child.
  /// Useful when inside a [Dialog]
  final bool tightMode;

  /// Quality levels for image filters.
  final FilterQuality? filterQuality;

  // Removes gesture detector if `true`.
  // Useful when custom gesture detector is used in child widget.
  final bool disableGestures;

  /// Enable pan the widget even if it's smaller than the hole parent widget.
  /// Useful when you want to drag a widget without restrictions.
  final bool enablePanAlways;

  /// Enable strictScale will restrict user scale gesture to the maxScale and minScale values.
  final bool strictScale;

  @override
  State<StatefulWidget> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView>
    with AutomaticKeepAliveClientMixin {
  late PhotoViewController _controller;

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? PhotoViewController();
  }

  @override
  void didUpdateWidget(PhotoView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _controller.dispose();
      }

      _controller = widget.controller ?? PhotoViewController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final computedOuterSize = widget.customSize ?? constraints.biggest;

        return widget.child != null
            ? CustomChildWrapper(
                childSize: widget.childSize,
                backgroundDecoration: widget.backgroundDecoration,
                heroAttributes: widget.heroAttributes,
                enableRotation: widget.enableRotation,
                controller: _controller,
                maxScale: widget.maxScale,
                minScale: widget.minScale,
                initialScale: widget.initialScale,
                basePosition: widget.basePosition,
                onTapUp: widget.onTapUp,
                onTapDown: widget.onTapDown,
                onScaleEnd: widget.onScaleEnd,
                outerSize: computedOuterSize,
                gestureDetectorBehavior: widget.gestureDetectorBehavior,
                tightMode: widget.tightMode,
                filterQuality: widget.filterQuality,
                disableGestures: widget.disableGestures,
                enablePanAlways: widget.enablePanAlways,
                strictScale: widget.strictScale,
                child: widget.child!,
              )
            : ImageWrapper(
                imageProvider: widget.imageProvider!,
                loadingBuilder: widget.loadingBuilder,
                backgroundDecoration: widget.backgroundDecoration,
                semanticLabel: widget.semanticLabel,
                gaplessPlayback: widget.gaplessPlayback,
                heroAttributes: widget.heroAttributes,
                enableRotation: widget.enableRotation,
                controller: _controller,
                maxScale: widget.maxScale,
                minScale: widget.minScale,
                initialScale: widget.initialScale,
                basePosition: widget.basePosition,
                onTapUp: widget.onTapUp,
                onTapDown: widget.onTapDown,
                onScaleEnd: widget.onScaleEnd,
                outerSize: computedOuterSize,
                gestureDetectorBehavior: widget.gestureDetectorBehavior,
                tightMode: widget.tightMode,
                filterQuality: widget.filterQuality,
                disableGestures: widget.disableGestures,
                errorBuilder: widget.errorBuilder,
                enablePanAlways: widget.enablePanAlways,
                strictScale: widget.strictScale,
              );
      },
    );
  }
}
