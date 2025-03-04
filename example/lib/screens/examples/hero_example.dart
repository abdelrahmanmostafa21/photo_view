import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view_example/screens/common/app_bar.dart';

class HeroExample extends StatelessWidget {
  const HeroExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ExampleAppBarLayout(
      title: "Hero",
      showGoBack: true,
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HeroPhotoViewRouteWrapper(
                  imageProvider: NetworkImage(
                    "https://source.unsplash.com/4900x3600/?camera,paper",
                  ),
                ),
              ),
            );
          },
          child: Hero(
            tag: "someTag",
            child: Image.network(
              "https://source.unsplash.com/4900x3600/?camera,paper",
              width: 350.0,
              loadingBuilder: (_, child, chunk) =>
                  chunk != null ? const Text("loading") : child,
            ),
          ),
        ),
      ),
    );
  }
}

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    super.key,
    required this.imageProvider,
    this.backgroundDecoration = const BoxDecoration(color: Color(0xff000000)),
    this.minScale = const PhotoViewScale.value(0),
    this.maxScale = const PhotoViewScale.value(double.infinity),
  });

  final ImageProvider imageProvider;
  final BoxDecoration backgroundDecoration;
  final PhotoViewScale minScale;
  final PhotoViewScale maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        minScale: minScale,
        maxScale: maxScale,
        decoration: PhotoViewDecoration(
          backgroundDecoration: backgroundDecoration,
          heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
        ),
      ),
    );
  }
}
