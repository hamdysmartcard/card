import 'package:flutter/material.dart';

class AppSquareButton extends StatefulWidget {
  final String text;
  final GestureTapCallback? onTap;

  AppSquareButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  _AppSquareButtonState createState() => _AppSquareButtonState();
}

class _AppSquareButtonState extends State<AppSquareButton> {
  @override
  Widget build(BuildContext context) {
    var squareSize = MediaQuery.of(context).size.width * .75;

    return InkWell(
      child: Container(
        width: squareSize,
        height: squareSize,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_square_button.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: squareSize / 3,
              right: squareSize / 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.text,
                      style: const TextStyle(
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0),
                      textAlign: TextAlign.left),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset('assets/images/ic_next.png',
                      width: 16, height: 16)
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: widget.onTap,
    );
  }
}
