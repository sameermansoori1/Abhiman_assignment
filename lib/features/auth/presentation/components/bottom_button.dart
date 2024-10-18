import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  const BottomButton(
      {super.key,
      this.title = "",
      required this.onPressed,
      this.borderRadius = 50,
      this.isOutlinedButton = false,
      this.showPadding = true,
      this.childWidget,
      this.width,
      this.height,
      this.color,
      this.textColor});

  final String? title;
  final Widget? childWidget;
  final double borderRadius;
  final Color? textColor;
  final Color? color;
  final bool isOutlinedButton;
  final bool showPadding;
  final double? width;
  final double? height;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: showPadding
          ? const EdgeInsets.fromLTRB(30, 22, 30, 22)
          : EdgeInsets.zero,
      child: SizedBox(
        height: height ?? 50,
        width: width ?? double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(isOutlinedButton
                  ? Colors.white
                  : color ?? Colors.deepPurpleAccent),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  // side:
                  // const BorderSide(color: Color(0xffF79633)),
                  borderRadius: BorderRadius.circular(borderRadius)))),
          onPressed: onPressed,
          child: title == ""
              ? childWidget
              : Text(
                  title ?? "",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: isOutlinedButton
                          ? Colors.deepPurpleAccent
                          : textColor ?? Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
        ),
      ),
    );
  }
}
