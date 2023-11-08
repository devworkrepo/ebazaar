import 'package:flutter/material.dart';
import 'package:ebazaar/util/app_util.dart';

import '../main.dart';

class RouteAwareWidget extends StatefulWidget {
  final Widget child;
  final Function? didPop;
  final Function? didPopNext;
  final Function? didPush;
  final Function? didPushNext;

  const RouteAwareWidget(
      {required this.child,
      this.didPop,
      this.didPopNext,
      this.didPush,
      this.didPushNext,
      Key? key})
      : super(key: key);

  @override
  _RouteAwareWidgetState createState() => _RouteAwareWidgetState();
}

class _RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }



  @override
  void didPush() {
    super.didPush();
    if (widget.didPush != null) widget.didPush!();

  }

  @override
  void didPop() {
    super.didPop();
    if (widget.didPop != null) widget.didPop!();

  }

  @override
  void didPopNext() {
    super.didPopNext();
    if (widget.didPopNext != null) widget.didPopNext!();

  }

  @override
  void didPushNext() {
    super.didPushNext();
    if (widget.didPushNext != null) widget.didPushNext!();

  }

}
