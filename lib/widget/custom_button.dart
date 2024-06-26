import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dailyduties/config/textstyle.dart';

enum ButtonChildType { text, icon }

class CustomButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final ButtonChildType type;
  final Color? bgColor;
  final Color? textColor;
  final VoidCallback onTap;
  final double? size;
  final bool showBorder;

  const CustomButton({
    Key? key,
    this.title,
    this.icon,
    required this.type,
    this.bgColor,
    required this.onTap,
    this.textColor,
    this.size,
    required this.showBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 45,
        width: Get.width,
        decoration: BoxDecoration(
          color: bgColor ?? HexColor(AppTheme.primaryColorString),
          borderRadius: BorderRadius.circular(5),
          border: showBorder == true ? Border.all(
            color: Theme.of(context).shadowColor,
            width: 4,
          ) : Border.all(width: 0),
        ),
        child: Center(
          child: (type == ButtonChildType.text)
              ? Text(
                  title!,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: size ?? 18,
                        fontWeight: FontWeight.w700,
                        color: textColor ?? Colors.white,
                      ),
                )
              : Icon(
                  icon!,
                  color: textColor ?? Colors.white,
                  size: 28.0,
                ),
        ),
      ),
    );
  }
}
