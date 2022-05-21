import 'package:cuidapet_mobile/app/core/ui/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class CuidapetDefaultButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double borderRadius;
  final Color? color;
  final String label;
  final Color? labelColor;
  final double? labelSize;
  final double padding;
  final double width;
  final double height;
  const CuidapetDefaultButton(
      {Key? key,
      required this.onPressed,
      this.borderRadius = 10.0,
      this.color,
      required this.label,
      this.labelColor,
      this.labelSize = 20.0,
      this.padding = 10.0,
      this.width = double.infinity,
      this.height = 66.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              primary: color ?? context.primaryColor),
          child: Text(
            label,
            style: TextStyle(
                fontSize: labelSize, color: labelColor ?? Colors.white),
          ),
        ),
      ),
    );
  }
}
