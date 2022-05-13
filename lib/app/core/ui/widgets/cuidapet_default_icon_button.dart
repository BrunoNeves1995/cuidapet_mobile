import 'package:cuidapet_mobile/app/core/ui/extensions/size_scren_extension.dart';
import 'package:flutter/material.dart';

class CuidapetDefaultIconButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final double width;
  final Color color;
  final IconData icon;
  final String label;
  const CuidapetDefaultIconButton(
      {Key? key,
      required this.onPressed,
      required this.width,
      required this.color,
      required this.icon,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 45.0.h,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 1.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20.0.w,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: VerticalDivider(
                color: Colors.white,
                thickness: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Text(
                label,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
