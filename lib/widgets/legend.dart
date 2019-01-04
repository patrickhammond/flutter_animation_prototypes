import 'dart:math';
import 'package:expanding_page_prototype/widgets/layout.dart';
import 'package:flutter/material.dart';

// Behavior associated with the legend color and label
class LegendItem extends StatelessWidget {
  static const DEFAULT_HEIGHT = 48.0;

  static _doNothingTapDown() {}

  final String text;
  final Color color;
  final double transitionPercent; // 0.0 to 1.0
  final double shortDistanceFromTop;
  final double longDistanceFromTop;
  final Function onSharedElementAnimationComplete;
  final GestureTapCallback onTap;
  final GestureTapCallback onLongPress;

  LegendItem(
      {Key key,
      @required this.text,
      @required this.color,
      this.transitionPercent = 0.0,
      this.shortDistanceFromTop = 80.0,
      this.longDistanceFromTop = 100.0,
      this.onSharedElementAnimationComplete,
      this.onTap = _doNothingTapDown,
      this.onLongPress = _doNothingTapDown});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var height = DEFAULT_HEIGHT + (screenHeight - DEFAULT_HEIGHT) * transitionPercent;

    return GestureDetector(
      child: Hero(
        child: SizedBox(
          height: height,
          child: _LegendWidget(
            text: text,
            color: color,
            transitionPercent: transitionPercent,
            shortDistanceFromTop: shortDistanceFromTop,
            longDistanceFromTop: longDistanceFromTop,
          ),
        ),
        tag: text + "_indicator",
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) {
          animation.addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              Function.apply(onSharedElementAnimationComplete, []);
            }
          });

          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) => LegendItem(
                  text: text,
                  color: color,
                  transitionPercent: animation.value,
                  shortDistanceFromTop: shortDistanceFromTop,
                  longDistanceFromTop: longDistanceFromTop,
                ),
          );
        },
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

// Legend color and label
class _LegendWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double transitionPercent; // 0.0 to 1.0
  final double shortDistanceFromTop;
  final double longDistanceFromTop;

  _LegendWidget(
      {Key key,
      @required this.text,
      @required this.color,
      @required this.transitionPercent,
      @required this.shortDistanceFromTop,
      @required this.longDistanceFromTop});

  @override
  Widget build(BuildContext context) {
    // 1.0 --> 0.0
    var inverseTransitionPercent = 1.0 - transitionPercent;

    // 24.0 --> 0.0
    var borderRadius = Radius.circular(LegendItem.DEFAULT_HEIGHT / 2.0 * inverseTransitionPercent);

    // 1.0 --> 0.0 (@ 8x)
    var labelOpacity = max(0.0, 1.0 - 8 * transitionPercent);

    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(borderRadius),
        child: Stack(
          children: [
            CustomSingleChildLayout(
              child: _LegendIndicator(
                circleSize: 20.0,
                color: color,
                transitionPercent: transitionPercent,
                shortDistanceFromTop: shortDistanceFromTop,
                longDistanceFromTop: longDistanceFromTop,
              ),
              delegate: BiasLayoutChildDelegate(
                leftOffset: 16.0 * inverseTransitionPercent,
                horizontalBias: 0.5 * transitionPercent,
                verticalBias: 0.5 * inverseTransitionPercent,
              ),
            ),
            CustomSingleChildLayout(
              child: Opacity(
                opacity: labelOpacity,
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              delegate: BiasLayoutChildDelegate(
                leftOffset: 46.0 * inverseTransitionPercent,
                horizontalBias: 0.5 * transitionPercent,
                verticalBias: 0.5 * inverseTransitionPercent,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(0xFF, 0xEA, 0xEA, 0xEA),
            blurRadius: 3.0,
            spreadRadius: 3.0,
          ),
        ],
      ),
    );
  }
}

// Sizees the legend color
class _LegendIndicator extends StatelessWidget {
  final double circleSize;
  final Color color;
  final double transitionPercent; // 0.0 to 1.0
  final double shortDistanceFromTop;
  final double longDistanceFromTop;

  _LegendIndicator(
      {Key key,
      @required this.circleSize,
      @required this.color,
      @required this.transitionPercent,
      @required this.shortDistanceFromTop,
      @required this.longDistanceFromTop});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    // We want to display a circle where the top and part of the sides are clipped offscreen
    // Do you remember trig? Well, here is a refresher...

    // We know:
    // - device screen width
    // - how far we want the circle to sit in the middle
    // - and how far we want the circle to sit at the sides
    //
    // Imagine a circle sitting in it's final position and then draw a radial line
    // from the center of the circle to the bottom center and the left side of the clipped circle.
    // Those lines will be the same length, but we don't know what those lengths are yet (and we
    // really need that to figure out the vertical offset and radius of our circle).
    //
    // If we connect all of the points of our triangle (center, bottom, left) we'll end up with a
    // isosceles triangle. Draw a temporary line from the left corner line to the center radial line
    // so that we now have two right triangles.
    //
    // The bottom triangle is easy to figure out some useful info about. We can get the length of the
    // short side by finding the difference between the height of how far down we want the circle to sit
    // at the sides and middle.
    var rightShortSide = longDistanceFromTop - shortDistanceFromTop;
    // We know the lenght of the other non-hypotenuse line because that is half of the screen width.
    var rightNonHypotenuse = screenWidth / 2.0;
    //To get the angle descending from the horizontal line we can take the inverse tangent of the opposite
    // length divided by the adjacent length.
    var rightArctanAngle = atan(rightShortSide / rightNonHypotenuse);
    // Since every triangle's angles must
    // add to 180, we can find the difference between 180 and our right angle (90) and the angle we just
    // calculated. We care about this angle.
    var equalAngle = 180 - 90 - rightArctanAngle;
    // To get the length of the hypotenuse we can just apply the pythagorean theorum and take the square
    // root of the sum of the opposite side squared and the adjacent side squared. We care about this length.
    // We know everything about this bottom triangle.
    var hypotenuse = sqrt(rightShortSide * rightShortSide + rightNonHypotenuse * rightNonHypotenuse);
    //
    // Remove our temporary line from above and go back to this being an isoceles triangle where we know
    // the length of the non-equal side and the angles of the triangle (because this is isoceles the angle
    // from the vertical line to the non-equal side will be the same on both sides, and because all of the
    // angles must add up to 180, we can figure out the center angle).
    var nonequalAngle = 180 - 2.0 * equalAngle;
    //
    // Now we can use the law of sines ( a / sin(A) = b / sin(B) ) to figure out the total length of our
    // vertical radius. Assume that the unequal lenth is called 'a' and the center angle is called 'A'
    // and the left side angle is 'B' and we want to find b. Solve for b and now we know how big to make
    // our circle can calculate where it should be placed. *whew*
    var radius = (hypotenuse / sin(nonequalAngle)) * sin(equalAngle);

    var drawnRadius = max(circleSize, (circleSize + ((radius * 2 - circleSize) * transitionPercent))) / 2.0;

    var width = min(screenWidth, drawnRadius * 2);
    var height = min(longDistanceFromTop, drawnRadius * 2);

    return Container(
      child: CustomPaint(
        painter: _LegendPainter(
          color: color,
          transitionPercent: transitionPercent,
          drawnRadius: drawnRadius,
        ),
      ),
      width: width,
      height: height,
    );
  }
}

/// Draws the painted legend color circle/oval
class _LegendPainter extends CustomPainter {
  final Color color;
  final double transitionPercent;
  final double drawnRadius;

  final Paint _paint = Paint();

  _LegendPainter({Key key, @required this.color, @required this.transitionPercent, @required this.drawnRadius}) {
    _paint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;

    var sides = max(0.0, drawnRadius * 2 - rect.width) / 2.0;
    var adjusted = Rect.fromLTRB(
      -sides,
      size.height - 2 * drawnRadius,
      size.width + sides,
      size.height,
    );
    canvas.drawOval(adjusted, _paint);
  }

  @override
  bool shouldRepaint(_LegendPainter oldDelegate) {
    return color != oldDelegate.color ||
        transitionPercent != oldDelegate.transitionPercent ||
        drawnRadius != oldDelegate.drawnRadius;
  }
}
