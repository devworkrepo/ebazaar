import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ebazaar/model/banner.dart';
import 'package:ebazaar/util/app_constant.dart';

class HomeCarouselWidget extends StatefulWidget {
  const HomeCarouselWidget({Key? key}) : super(key: key);

  @override
  _HomeCarouselWidgetState createState() => _HomeCarouselWidgetState();
}

class _HomeCarouselWidgetState extends State<HomeCarouselWidget> {
  int activeIndex = 0;

  List<AppBanner> bannerList = [
    AppBanner(rawPicName: "https://spayindia.in/images/spay_features.png"),
    AppBanner(rawPicName: "https://spayindia.in/images/spay_features.png"),
    AppBanner(rawPicName: "https://spayindia.in/images/spay_features.png"),
    AppBanner(rawPicName: "https://spayindia.in/images/spay_features.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 4,
        ),
        (bannerList.isEmpty)
            ? const SizedBox()
            : CarouselSlider.builder(
                itemCount: bannerList.length,
                itemBuilder: (context, index, realIndex) {
                  final banner = bannerList[index];
                  return _BuildItem(banner);
                },
                options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 0.88,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    height: 176,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    })),
        const SizedBox(
          height: 8,
        ),
        _buildIndicator()
      ],
    );
  }

  Widget _buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: bannerList.length,
        effect: const WormEffect(
          dotHeight: 10,
          dotWidth: 10,
        ),
      );
}

class _BuildItem extends StatelessWidget {
  final AppBanner appBanner;

  const _BuildItem(this.appBanner, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = (appBanner.picName != null)
        ? AppConstant.bannerBaseUrl + appBanner.picName!
        : appBanner.rawPicName!;
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColorDark,
                  Theme.of(context).primaryColorDark,
                  Theme.of(context).colorScheme.secondary
                ]
              ),
              borderRadius: BorderRadius.circular(8)
            ),

            margin: const EdgeInsets.all(4),
            child: CachedNetworkImage(
              placeholder: (context, url) => const Center(
                  child: Icon(
                Icons.image_search,
                color: Colors.black45,
                size: 100,
              )),
              errorWidget: (context, url, error) => const Center(
                  child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.black45,
                size: 100,
              )),
              imageUrl: imageUrl,
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}
