import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_ecommerce_app/models/home_carosel_item_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCarouselOptions extends StatelessWidget {
  const CustomCarouselOptions({
    super.key,
    required this.dummyHomeCarouselItems1,
  });

  final List<HomeCarouselItemModel> dummyHomeCarouselItems1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: FlutterCarousel.builder(
        options: FlutterCarouselOptions(
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          viewportFraction: 0.9,
          height: 180.h,
          showIndicator: true,
          slideIndicator: CircularWaveSlideIndicator(
            slideIndicatorOptions: SlideIndicatorOptions(
              currentIndicatorColor: Colors.deepPurple,
              indicatorBackgroundColor: Colors.grey.shade300,
              indicatorRadius: 4.r,
              itemSpacing: 16.w,
            ),
          ),
        ),
        itemCount: dummyHomeCarouselItems1.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: dummyHomeCarouselItems1[index].imgUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.deepPurple,
                            ),
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 40.sp,
                        ),
                      );
                    },
                  ),
                  // Gradient Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
