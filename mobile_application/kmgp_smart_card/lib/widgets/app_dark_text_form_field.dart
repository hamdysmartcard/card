import 'package:flutter/material.dart';

class AppDarkTextFormField extends StatefulWidget {
  final IconData iconData;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool isPassword, isEnabled;

  AppDarkTextFormField(
      {Key? key,
      required this.iconData,
      required this.hintText,
      required this.onChanged,
      this.isPassword = false,
      this.keyboardType,
      this.isEnabled = true})
      : super(key: key);

  @override
  _AppDarkTextFormFieldState createState() => _AppDarkTextFormFieldState();
}

class _AppDarkTextFormFieldState extends State<AppDarkTextFormField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: const Color(0xffdadada),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              enabled: widget.isEnabled,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPassword ? !_isPasswordVisible : false,
              enableSuggestions: !widget.isPassword,
              autocorrect: !widget.isPassword,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                icon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(widget.iconData),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Field is required';
                return null;
              },
            ),
          ),
          if (widget.isPassword)
            TextButton(
                onPressed: () => setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    }),
                child: Text(_isPasswordVisible ? 'Hide' : 'Show',
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Manrope",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                    textAlign: TextAlign.right))
        ],
      ),
    );
  }
}
