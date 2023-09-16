import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SuggestionWidget extends StatelessWidget {
  final String title;
  final String message;
  final List<Color> cardColors;
  final IconData actionIcon;
  final String actionTitle;

  const SuggestionWidget(
      {Key? key,
      required this.title,
      required this.message,
      required this.cardColors,
      required this.actionIcon,
      required this.actionTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.green.shade100,
                              spreadRadius: 5,
                              blurRadius: 20,
                              offset: Offset(5, 20))
                        ]),
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 8,
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                actionIcon,
                                size: 32,
                                color: Theme.of(context).colorScheme.secondary,
                              ))))
                ],
              ),
              Text(
                actionTitle,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
              child: Stack(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
              ),
              ClipPath(
                clipper: _MyClipper(),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: cardColors,
                      )),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            message,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.normal,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,

                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                      Positioned(

                        top : 25,
                        child: Image.asset(
                          "assets/image/abc2.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    ],),
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}

class _MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    var mWidth = width - 15;

    var path = Path();
    path.lineTo(0, height);
    path.lineTo(15, height - 10);

    path.quadraticBezierTo(
        mWidth * 0.10, height - 20, mWidth * 0.20, height - 10);
    path.quadraticBezierTo(mWidth * 0.30, height, mWidth * 0.40, height - 10);
    path.quadraticBezierTo(
        mWidth * 0.50, height - 20, mWidth * 0.60, height - 10);
    path.quadraticBezierTo(mWidth * 0.70, height, mWidth * 0.80, height - 10);
    path.quadraticBezierTo(mWidth * 0.90, height - 20, mWidth, height - 10);
    path.lineTo(width + 15, height);

    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
