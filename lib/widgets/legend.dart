import 'dart:math';
import 'package:expanding_page_prototype/widgets/layout.dart';
import 'package:flutter/material.dart';

// Behavior associated with the legend color and label
class LegendItem extends StatelessWidget {
  static _doNothing() {}

  final String text;
  final Color color;
  final double transitionPercent; // 0.0 to 1.0
  final GestureTapCallback onTap;

  LegendItem(
      {Key key,
      @required this.text,
      @required this.color,
      this.transitionPercent = 0.0,
      this.onTap = _doNothing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        child: _LegendWidget(
          text: text,
          color: color,
          transitionPercent: transitionPercent,
        ),
        tag: text + "_indicator",
        flightShuttleBuilder: (BuildContext flightContext,
            Animation<double> animation,
            HeroFlightDirection flightDirection,
            BuildContext fromHeroContext,
            BuildContext toHeroContext) {
          return AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) => LegendItem(
                  text: text,
                  color: color,
                  transitionPercent: animation.value,
                ),
          );
        },
      ),
      onTap: onTap,
    );
  }
}

// Legend color and label
class _LegendWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double transitionPercent; // 0.0 to 1.0

  _LegendWidget(
      {Key key,
      @required this.text,
      @required this.color,
      this.transitionPercent = 0.0});

  @override
  Widget build(BuildContext context) {
    // 1.0 --> 0.0
    var inverseTransitionPercent = 1.0 - transitionPercent;

    // 24.0 --> 0.0
    var borderRadius = Radius.circular(24.0 * inverseTransitionPercent);

    // 1.0 --> 0.0 (@ 8x)
    var labelOpacity = max(0.0, 1.0 - 8 * transitionPercent);

    return Container(
      child: ClipRRect(
          borderRadius: BorderRadius.all(borderRadius),
          child: Stack(
            children: [
              CustomSingleChildLayout(
                child: _LegendIndicator(
                  color: color,
                  transitionPercent: transitionPercent,
                ),
                delegate: BiasLayoutChildDelegate(
                    leftOffset: 16.0 * inverseTransitionPercent,
                    horizontalBias: 0.5 * transitionPercent,
                    verticalBias: 0.5 * inverseTransitionPercent),
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
                    verticalBias: 0.5 * inverseTransitionPercent),
              ),
            ],
          )),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(borderRadius),
        boxShadow: [
          const BoxShadow(
            color: Color(0xFFE0E0E0),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
    );
  }
}

// Sizees the legend color
class _LegendIndicator extends StatelessWidget {
  final Color color;
  final double transitionPercent; // 0.0 to 1.0

  _LegendIndicator(
      {Key key, @required this.color, @required this.transitionPercent});

  @override
  Widget build(BuildContext context) {
    // 1.0 --> 0.0
    var inverseTransitionPercent = 1.0 - transitionPercent;

    var screenWidth = MediaQuery.of(context).size.width;
    var circleSize = 20.0 * inverseTransitionPercent; // 20.0 --> 0.0
    var width = circleSize + screenWidth * transitionPercent; // 20.0 --> sw
    var height = circleSize + (400.0 * transitionPercent); // 20.0 --> 400.0

    return Container(
      child: CustomPaint(
        painter:
            _LegendPainter(color: color, transitionPercent: transitionPercent),
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

  final Paint _paint = Paint();

  _LegendPainter(
      {Key key, @required this.color, @required this.transitionPercent}) {
    _paint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;

    var overScaleWidth = size.width * .6 * transitionPercent;
    var translateHeight = size.height * .65 * transitionPercent;
    var adjusted = Rect.fromLTRB(
        rect.left - overScaleWidth,
        rect.top - translateHeight,
        rect.right + overScaleWidth,
        rect.bottom - translateHeight);

    canvas.drawOval(adjusted, _paint);
  }

  @override
  bool shouldRepaint(_LegendPainter oldDelegate) {
    return transitionPercent != oldDelegate.transitionPercent;
  }
}
