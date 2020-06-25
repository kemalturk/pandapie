
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'util.dart';


final bool debugMode = false;

class PandaPie extends StatelessWidget {

  final double size;
  final String selectedKey;
  final List<PandaPieData> data;
  final bool lowHardwareMode;

  PandaPie({
    Key key,
    this.size = 300,
    this.selectedKey,
    @required this.data,
    this.lowHardwareMode = false,
  }):
  assert(data != null),
  super(key: key);

  @override
  Widget build(BuildContext context) {

    bool drawSelectedLayer = false;

    try {
      final selectedItem = data.firstWhere((element) => element.key == selectedKey);
      if (selectedItem != null) drawSelectedLayer = true;
    } catch (e) {}

    final clipper = _PieChartClipper(data: data);

    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _PieShadowPainter(
              clipper: clipper,
              shadows: [
                BoxShadow(
                  offset: Offset(-3,-3),
                  blurRadius: 10,
                  color: Colors.white.withOpacity(.3)
                ),
                BoxShadow(
                  offset: Offset(3,3),
                  blurRadius: 10,
                  color: Colors.black87
                ),
              ]
            ),
            child: Container(
              width: size,
              height: size,
              child: ClipPath(
                clipper: clipper,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF303336),
                        Color(0xFF222427),
                      ],
                    ),
                  ),
                ),
              )
            ),
          ),
          drawSelectedLayer ?
          Container(
            width: size,
            height: size,
            child: ClipPath(
              clipper: _PieChartClipper(
                data: data,
                drawSelectedOnly: true,
                selectedKey: selectedKey,
              ),
              child: Container(
                color: Colors.orange
              ),
            ),
          ) : Container(),
          Container(
            width: size * (3/10),
            height: size * (3/10),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFE51A1B).withOpacity(.3),
              shape: BoxShape.circle
            ),
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Color(0xFFE51A1B),
                shape: BoxShape.circle,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE51A1B),
                  shape: BoxShape.circle,
                  gradient: !lowHardwareMode ? LinearGradient(
                    colors: [
                      Color(0xFFE51A1B),
                      Color(0xFFEC4127),
                      Color(0xFFE51A1B),
                      Color(0xFFEC4127),
                      Color(0xFFE51A1B),
                      Color(0xFFEC4127),
                      Color(0xFFE51A1B),
                      Color(0xFFEC4127),
                    ]
                  ) : null,
                ),
                child: Center(
                  child: Icon(Icons.compare_arrows, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );

  }
}

class _PieChartClipper extends CustomClipper<Path> {

  final List<PandaPieData> data;

  final double borderRadius = 15;
  final double innerPadding = .1;
  final double outerPadding = 20;

  final bool drawSelectedOnly;
  final String selectedKey;

  _PieChartClipper({
    @required this.data,
    this.drawSelectedOnly = false,
    this.selectedKey,
  });

  @override
  Path getClip(Size size) {

    final double radius = ((size.width > size.height ?
      size.height : size.width) / 2);
    final center = Point(size.width / 2, size.height / 2);

    final roundedArcRadius = radius - outerPadding;

    final outerPath = Path()
    ..addOval(
      Rect.fromCircle(
        center: Offset(center.x, center.y),
        radius: radius
      ),
    )..close();

    FpcUtil.init(
      center: center,
      radius: roundedArcRadius,
      width: roundedArcRadius / 1.8,
    );

    final innerPath = Path();

    double total = 0;
    data.forEach((e) {
      total += e.value;
    });

    double start = 0;

    for(var e in data) {

      double value = e.value;

      double valuePercent = (100 * value) / total;

      // print(valuePercent);

      double radian = (value * 2 * pi / total);
      double startRadian = start + innerPadding;
      double sweepRadian = radian - innerPadding;

      // print('startRadian: $startRadian');
      // print('sweepRadian: $sweepRadian');
      // print('diff: ${sweepRadian - startRadian}');

      if(drawSelectedOnly) {
        if(e.key == selectedKey) {
          FpcUtil(
            startRadian: startRadian,
            sweepRadian: sweepRadian,
          ).drawRoundedArc(innerPath);
          innerPath.close();
          return FpcUtil.combineWithCenterCircle(innerPath)..close();
        }
      } else {
        FpcUtil(
          startRadian: startRadian,
          sweepRadian: sweepRadian,
        ).drawRoundedArc(innerPath);
      }

      start += radian;

    }

    innerPath.close();

    final innerCompletePath =
      FpcUtil.combineWithCenterCircle(innerPath)..close();
    

    return Path.combine(
      PathOperation.difference,
      outerPath,
      innerCompletePath
    );
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;

}

class _PieShadowPainter extends CustomPainter {

  final List<Shadow> shadows;
  final CustomClipper<Path> clipper;

  _PieShadowPainter({
    @required this.shadows,
    @required this.clipper,
  });

  @override
  void paint(Canvas canvas, Size size) {

    shadows.forEach((shadow) {
      var paint = shadow.toPaint();
      var clipPath = clipper.getClip(size).shift(shadow.offset);
      canvas.drawPath(clipPath, paint);
    });

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => debugMode;
}

class PandaPieData {

  final String key;
  final double value;

  PandaPieData({
    @required this.key,
    @required this.value
  });

}
