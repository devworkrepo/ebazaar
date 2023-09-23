import 'package:flutter/material.dart';

import '../res/color.dart';
import '../util/hex_color.dart';
import '../widget/image.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).primaryColorDark,
          Theme.of(context).primaryColorDark,
          Theme.of(context).colorScheme.secondary,
        ]
      ),
       borderRadius: BorderRadius.only(bottomRight: Radius.circular(24))
     ),
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomPaint(
        painter: BluePainter(color : Colors.white24),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  _UserProfileAndCompanyName(),
                  Spacer(),
                  Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black.withOpacity(0.4),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                      Icon(Icons.message,color: Colors.white.withOpacity(0.9),size: 32,),

                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 18,
                          width: 18,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100)
                          ),
                          child: Text("1",style: TextStyle(
                          fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold


                        ),),),
                      )

                    ],),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfileAndCompanyName extends StatelessWidget {
  const _UserProfileAndCompanyName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(

          child: Stack(
            fit: StackFit.loose,
            children: [

             /* Positioned(
                  bottom: -5,
                  left: 0,
                  right: 0,
                  child: Image.asset("assets/image/welcome_board.png",height: 42,)),
              */
              AppCircleNetworkImage("https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"),


            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(width: 12,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [



            Text(
              "Akash Kumar Das",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            SizedBox(height: 4,),
            Text(
              "ARB Communication",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            Text(
              "Retailer - SPI20212",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
          ],
        )
      ],
    );
  }
}

class BluePainter extends CustomPainter {

  final Color color;

  const BluePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;


    Paint paint = Paint();
    Path ovalPath = Path();
    ovalPath.moveTo(width, 0);
    ovalPath.quadraticBezierTo(width -50, height * 0.1, width - 45, height * 0.5);
    ovalPath.quadraticBezierTo(width -40, height * 0.8, width, height);
    ovalPath.close();
    paint.color =color.withOpacity(0.1);
    canvas.drawPath(ovalPath, paint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
