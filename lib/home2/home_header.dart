import 'package:flutter/material.dart';

import '../util/hex_color.dart';
import '../widget/image.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(

        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(5)
        ),

        width: double.infinity,
        padding: EdgeInsets.all(12),
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white70,
              child: Icon(Icons.person),
            ),
            SizedBox(width: 12,),
            Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
                Text("Akash Kumar Das",style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  fontWeight: FontWeight.w500
                ),),

                Text("(A. Communication)",style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _MyClipper extends CustomClipper<Path> {


  @override
  Path getClip(Size size) {

    double height = size.height;
    double width = size.width;

    var path = Path();


      path.moveTo(0, height);
      path.lineTo(width/2,0);
      path.lineTo(width, height);

      path.lineTo(width, height);



    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
