import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mentos_flutter/src/util/color/color_style.dart';

class BorderLineButton extends StatelessWidget {
  const BorderLineButton({
    Key? key,
    required this.title,
    this.fontSize = 18,
    this.color = const Color(0xFF1F5CD1),
    this.width = double.infinity,
    this.height = double.infinity,
    required this.onPressed
  }) : super(key: key);

  final String title;
  final double fontSize;
  final Color color;
  final double width;
  final double height;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: ColorStyles.white,
      padding: const EdgeInsets.all(0),
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color
            )
        ),
        child: Text(
          title,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: color,
              decoration: null
          )
        ),
      ),
    );
  }
}
