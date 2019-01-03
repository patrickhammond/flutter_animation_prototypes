import 'dart:math';

import 'package:flutter/material.dart';

// Controls how a child is positioned along with an offset
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

/// Children must all be the same width and height
class FixedGridLayout extends StatelessWidget {
  final int columns;
  final double childHeight;
  final double horizontalPadding;
  final double verticalPadding;
  final List<Widget> children;

  FixedGridLayout(
      {Key key,
      @required this.columns,
      @required this.childHeight,
      this.horizontalPadding = 0.0,
      this.verticalPadding = 0.0,
      @required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _UnboundedFixedGridLayout(
        columns: columns,
        childHeight: childHeight,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        children: children,
      ),
      height: _calcMaxHeight(),
    );
  }

  double _calcMaxHeight() {
    var rows = (children.length.toDouble() / columns.toDouble()).ceil();
    return rows * (childHeight + 2 * verticalPadding);
  }
}

class _UnboundedFixedGridLayout extends CustomMultiChildLayout {
  _UnboundedFixedGridLayout(
      {Key key,
      @required int columns,
      @required double childHeight,
      @required double horizontalPadding,
      @required double verticalPadding,
      @required List<LayoutId> children})
      : super(
            key: key,
            delegate: _FixedGridLayoutDelegate(
              itemIds: children.map((child) {
                return child.id;
              }).toList(),
              childHeight: childHeight,
              horizontalPadding: horizontalPadding,
              verticalPadding: verticalPadding,
              columns: columns,
            ),
            children: children);
}

class _FixedGridLayoutDelegate extends MultiChildLayoutDelegate {
  final List<Object> itemIds;
  final int columns;
  final double childHeight;
  final double horizontalPadding;
  final double verticalPadding;

  _FixedGridLayoutDelegate(
      {@required this.itemIds,
      @required this.columns,
      @required this.childHeight,
      @required this.horizontalPadding,
      @required this.verticalPadding});

  @override
  void performLayout(Size size) {
    final totalPaddingWidth = ((horizontalPadding * 2) * (columns + 1));
    final maxChildWidth = (size.width - totalPaddingWidth) / columns.toDouble();
    final childConstraintSize = Size(maxChildWidth, double.infinity);

    double lastYOffset = 0;
    int row = 0;
    int column = 0;
    double childHeight = double.negativeInfinity;

    for (int i = 0; i < itemIds.length; i++) {
      String childId = itemIds[i];

      BoxConstraints constraints = BoxConstraints.loose(childConstraintSize);
      Size childSize = layoutChild(childId, constraints);
      childHeight = max(childHeight, childSize.height);

      double horizontalPaddingOffset = (2 * horizontalPadding) * (column + 1);
      double verticalPaddingOffset = (2 * verticalPadding) * (row + 1);

      double xPos = (column * maxChildWidth) + horizontalPaddingOffset;
      double yPos = lastYOffset + verticalPaddingOffset;
      positionChild(childId, Offset(xPos, yPos));

      column++;
      if (column == columns) {
        row++;
        column = 0;
        lastYOffset += childHeight;
        childHeight = double.negativeInfinity;
      }
    }
  }

  @override
  bool shouldRelayout(_FixedGridLayoutDelegate oldDelegate) {
    return (itemIds != oldDelegate.itemIds || columns != oldDelegate.columns);
  }
}
