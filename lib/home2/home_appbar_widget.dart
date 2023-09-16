import 'package:flutter/material.dart';
import 'package:spayindia/util/hex_color.dart';

class HomePage2AppBar extends StatelessWidget {
  const HomePage2AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Text("S Bazaar",style: TextStyle(
          fontSize: 22,
          fontWeight : FontWeight.w400,
          color: Colors.white
        ),),


        Spacer(),
        Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Colors.white70,
            )
          ),
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(Icons.refresh,color: Colors.white70,size: 20,),
              SizedBox(width: 5,),

              Text("Bal. ",
                style: TextStyle(
                    color: Colors.white70,
                  fontSize: 14
                ),),
              SizedBox(width: 8,),

              Text("₹123000",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                fontSize: 16
              ),),
              SizedBox(width: 8,),
              CircleAvatar(child: Icon(Icons.person))
            ],
          ),
        ),

      ],
    );
  }


}

class HomeMenuIconWidget extends StatelessWidget {
  const HomeMenuIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        menuLieWidget(22),
        const SizedBox(
          height: 5,
        ),
        menuLieWidget(18),
        const SizedBox(
          height: 4,
        ),
        menuLieWidget(13),
      ],
    );
  }

  Widget menuLieWidget(int width) {
    return Container(
      height: 2,
      width: width.toDouble(),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
    );
  }
}

