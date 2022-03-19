import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String text;
  final GestureTapCallback? onTap;
  final bool isOutline;

  AppButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.isOutline = false})
      : super(key: key);

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) => MaterialButton(
        minWidth: double.infinity,
        hoverElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        onPressed: widget.onTap,
        elevation: 0,
        color: widget.isOutline ? Colors.white : Colors.black,
        child: Text(
          widget.text,
          style:
              TextStyle(color: widget.isOutline ? Colors.black : Colors.white),
        ),
        shape: widget.isOutline
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: Colors.black, width: 1, style: BorderStyle.solid))
            : StadiumBorder(),
      );
}
