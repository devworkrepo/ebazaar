import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeCarouselWidget extends StatefulWidget {
  const HomeCarouselWidget({Key? key}) : super(key: key);

  @override
  _HomeCarouselWidgetState createState() => _HomeCarouselWidgetState();
}

class _HomeCarouselWidgetState extends State<HomeCarouselWidget> {
  var images = [
    "https://en.pimg.jp/049/657/723/1/49657723.jpg",
    "https://media.istockphoto.com/vectors/employee-appreciation-day-concept-first-friday-in-march-holiday-for-vector-id1203206077?k=20&m=1203206077&s=612x612&w=0&h=g_L-DvoN9lxndV7T3RxnTpMSajsku17MoT9wMKDIH_4=",
    "https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=876&q=80",
    "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
    "https://thumbs.dreamstime.com/b/word-teamwork-banner-text-color-vector-illustration-113527269.jpg"
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
                viewportFraction: 0.8,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                height: 156,
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                })),
        SizedBox(
          height: 8,
        ),
        _buildIndicator()
      ],
    );
  }

  Widget _buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: images.length,
        /* effect: JumpingDotEffect(offset:0,
        dotWidth: 20,
        dotHeight: 20,
        paintStyle: PaintingStyle.stroke,
        verticalOffset: 1,
        activeDotColor: Theme.of(context).primaryColor,
      ),*/
        effect: WormEffect(dotHeight: 10, dotWidth: 10),
      );
}

class _BuildItem extends StatelessWidget {
  final String imageUrl;

  const _BuildItem(this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(5),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
