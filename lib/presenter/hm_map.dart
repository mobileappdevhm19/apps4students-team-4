import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:photo_view/photo_view.dart';

class HmMap extends StatelessWidget {
  final controller = PageController(initialPage: 0);
  final currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              PageView(
                  controller: controller,
                  children: <Widget>[
                    PhotoView(
                        imageProvider:
                            AssetImage('graphics/campus_lothstr.jpg')),
                    PhotoView(
                        imageProvider:
                            AssetImage('graphics/campus_karlstr.jpg')),
                    PhotoView(
                        imageProvider: AssetImage('graphics/campus_pasing.jpg'))
                  ],
                  onPageChanged: (int index) {
                    currentPageNotifier.value = index;
                  }),
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CirclePageIndicator(
                    itemCount: 3,
                    currentPageNotifier: currentPageNotifier,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
