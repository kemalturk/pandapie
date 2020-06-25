import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


class FpcUtil {

  static Point center;
  static double radius;
  static double width;

  final double startRadian;
  final double sweepRadian;

  
  FpcUtil({
    @required this.startRadian,
    @required this.sweepRadian
  }) :
  assert(startRadian != null),
  assert(sweepRadian != null);

  static init({
    Point center,
    double radius,
    double width,
  }) {
    FpcUtil.center = center;
    FpcUtil.radius = radius;
    FpcUtil.width = width;
  }

  Point radianPoint({double radius, double radian}) {
    return Point(center.x + (radius ?? FpcUtil.radius) * cos(radian), center.y + (radius ?? FpcUtil.radius) * sin(radian));
  }

  Offset get centerOffset => Offset(center.x, center.y);

  double get outerArcLength => (radius*(sweepRadian - startRadian));

  double get innerArcLength =>
    ((radius - width) * (sweepRadian - startRadian));


  drawRoundedArc(Path path) {

    final double borderRadius = 15;

    final double verticalBorderRadiusValue = borderRadius;
    final double horizontalBorderRadiusValue = borderRadius / 100;

    final cornerA = Corner(
      center: FpcUtil.center,
      radius: FpcUtil.radius,
      radian: startRadian,
    );
    final cornerB = Corner(
      center: FpcUtil.center,
      radius: FpcUtil.radius,
      radian: startRadian + sweepRadian,
    );
    final cornerC = Corner(
      center: FpcUtil.center,
      radius: FpcUtil.radius - FpcUtil.width,
      radian: sweepRadian + startRadian,
    );
    final cornerD = Corner(
      center: FpcUtil.center,
      radius: FpcUtil.radius - FpcUtil.width,
      radian: startRadian,
    );


    final cornerAPoint = cornerA.point;
    final cornerAPoint1 = cornerA.move(
      radius: -verticalBorderRadiusValue
    ).point;
    final cornerAPoint2 = cornerA.move(
      radian: horizontalBorderRadiusValue
    ).point;

    path.moveTo(cornerAPoint2.x, cornerAPoint2.y);

    path.arcTo(
      Rect.fromCircle(center: centerOffset, radius: radius),
      startRadian + horizontalBorderRadiusValue,
      sweepRadian - (horizontalBorderRadiusValue * 2),
      false
    );

    final cornerBPoint = cornerB.point;
    final cornerBPoint2 = cornerB.move(
      radius: -verticalBorderRadiusValue
    ).point;

    path.quadraticBezierTo(
      cornerBPoint.x, cornerBPoint.y,
      cornerBPoint2.x, cornerBPoint2.y
    );

    final cornerCPoint = cornerC.point;
    final cornerCPoint1 = cornerC.move(
      radius: verticalBorderRadiusValue
    ).point;
    final cornerCPoint2 = cornerC.move(
      radian: -horizontalBorderRadiusValue
    ).point;

    path.lineTo(cornerCPoint1.x, cornerCPoint1.y);

    path.quadraticBezierTo(
      cornerCPoint.x, cornerCPoint.y,
      cornerCPoint2.x, cornerCPoint2.y
    );

    final cornerDPoint = cornerD.point;
    final cornerDPoint1 = cornerD.move(
      radian: horizontalBorderRadiusValue
    ).point;
    final cornerDPoint2 = cornerD.move(
      radius: verticalBorderRadiusValue
    ).point;

    path.lineTo(cornerDPoint1.x, cornerDPoint1.y);

    path.quadraticBezierTo(
      cornerDPoint.x, cornerDPoint.y,
      cornerDPoint2.x, cornerDPoint2.y
    );

    path.lineTo(cornerAPoint1.x, cornerAPoint1.y);

    path.quadraticBezierTo(
      cornerAPoint.x, cornerAPoint.y,
      cornerAPoint2.x, cornerAPoint2.y
    );

  }

  static Path combineWithCenterCircle(Path path) {
    final centerCirclePath = Path();
    centerCirclePath.addOval(
      Rect.fromCircle(
        center: Offset(center.x, center.y),
        radius: radius - width
      )
    );
    centerCirclePath.close();
    return Path.combine(
      PathOperation.difference,
      path,
      centerCirclePath,
    );
  }

}

class Corner {

  final Point center;
  final double radian;
  final double radius;

  Corner({@required this.center, @required this.radian, @required this.radius});

  Point get point =>
    Point(center.x + radius * cos(radian), center.y + radius * sin(radian));

  Corner move({Point center, double radian, double radius}) {
    return Corner(
      center: center ?? this.center,
      radius: radius != null ? (this.radius + radius) : this.radius,
      radian: radian != null ? (this.radian + radian) : this.radian,
    );
  }

}