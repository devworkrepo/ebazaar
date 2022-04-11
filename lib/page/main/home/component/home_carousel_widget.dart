import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spayindia/util/app_util.dart';

class HomeCarouselWidget extends StatefulWidget {
  const HomeCarouselWidget({Key? key}) : super(key: key);

  @override
  _HomeCarouselWidgetState createState() => _HomeCarouselWidgetState();
}

class _HomeCarouselWidgetState extends State<HomeCarouselWidget> {
  var images = [
    "https://spayindia.in/images/spay_features.png",
    "https://spayindia.in/images/spay_features.png",
    "https://spayindia.in/images/spay_features.png",
    "https://spayindia.in/images/spay_features.png",
  ];

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
            itemCount: images.length,
            itemBuilder: (context, index, realIndex) {
              final urlImage = images[index];
              return _BuildItem(urlImage);
            },
            options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 0.95,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                height: 156,
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
    count: images.length,
    effect: const WormEffect(dotHeight: 10, dotWidth: 10,),
  );
}

class _BuildItem extends StatelessWidget {
  final String imageUrl;

  const _BuildItem(this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(builder: (context,constraint){
        return Card(
          color: Colors.blue[900],
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.all(4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
              placeholder: (context, url) => const Center(
                  child: Icon(
                    Icons.image_search,
                    color: Colors.black45,
                    size: 100,
                  )),
              errorWidget: (context,url,error)=>const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.black45,
                    size: 100,
                  )),
              imageUrl: imageUrl,
              fit: BoxFit.fill,
            ),
          ),
        );
      },),
    );
  }
}
