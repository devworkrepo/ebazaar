import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeServiceCard extends StatelessWidget {
  final String title;
  final List<HomeCardItem> items;

  const HomeServiceCard({Key? key, required this.title, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Expanded> renderExpandedWidget(int itemCount) {
    var count = 4 - itemCount;
      List<Expanded> mList = [];
      for (int i = 0; i < count; i++) {
        mList.add(const Expanded(
          child: SizedBox(),
        ));
      }
      return mList;
    }

    Widget renderRowItems() {
      if (items.length > 4) {
        var firstRow = items.sublist(0, 4);
        var secondRow = items.sublist(4);
        var mList = renderExpandedWidget(secondRow.length);
        return Column(
          children: [
            Row(
              children: [...firstRow],
            ),
            const SizedBox(height: 16,),
            Row(
              children: [...secondRow, if (mList.isNotEmpty) ...mList],
            ),
          ],
        );
      } else {

        var mList = renderExpandedWidget(items.length);
        return Row(
          children: [...items, if (mList.isNotEmpty) ...mList],
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 2,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleText(title),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                   renderRowItems()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _buildTitleText(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.blueGrey[900]),
    );
  }
}

class HomeCardItem extends StatelessWidget {
  final String iconName;
  final String title;

  const HomeCardItem({Key? key, required this.iconName, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
               gradient: LinearGradient(
                 colors: [
                    Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
                 ]
               ),
          borderRadius: BorderRadius.circular(5)),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: SvgPicture.asset(
                "assets/svg/$iconName.svg",
                width: 48,
                height: 48,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            title,
            style:  TextStyle(
                color: Colors.blueGrey.shade900,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          )
        ],
      ),
    );
  }
}
