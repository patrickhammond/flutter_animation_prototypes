import 'package:flutter/material.dart';

// Controls how the label is positioned along with an offset for the indicator
class BiasLayoutChildDelegate extends SingleChildLayoutDelegate {
  final double leftOffset;
  final double topOffset;

  final double horizontalBias; // 0.0 = left, 1.0 = right, 0.5 = center
  final double verticalBias; // 0.0 = top, 0.5 = middle, 1.0 = bottom

  BiasLayoutChildDelegate(
      {Key key,
      @required this.horizontalBias,
      @required this.verticalBias,
      this.leftOffset = 0.0,
      this.topOffset = 0.0});

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    var x = leftOffset + ((size.width - childSize.width) * horizontalBias);
    var y = topOffset + (size.height - childSize.height) * verticalBias;
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(BiasLayoutChildDelegate oldDelegate) {
    return ((leftOffset != oldDelegate.leftOffset) ||
        (verticalBias != oldDelegate.verticalBias) ||
        (horizontalBias != oldDelegate.horizontalBias));
  }
}