import 'package:flutter/material.dart';
import '../common/style/colors.dart';

class SeparatorWidget extends StatelessWidget {
  final double left, right;

  SeparatorWidget({this.left = 15, this.right = 15});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: this.left, right: this.right),
        child: Container(height: 1.0, color: MyColors.divider));
  }
}
