import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_ecommerce_app/models/home_carosel_item_model.dart';

class CustomCarouselOptions extends StatelessWidget {
  const CustomCarouselOptions({
    super.key,
    required this.dummyHomeCarouselItems1,
  });

  final List<HomeCarouselItemModel> dummyHomeCarouselItems1;

  @override
  Widget build(BuildContext context) {
    return FlutterCarousel.builder(
      options: FlutterCarouselOptions(
        autoPlay: true,
        height: 200,
        showIndicator: false,
        slideIndicator: CircularWaveSlideIndicator(),
      ),
      itemCount: dummyHomeCarouselItems1.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 12.0, start: 0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: dummyHomeCarouselItems1[index].imgUrl,
                placeholder: (context, url) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
                errorWidget: (context, url, error) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
