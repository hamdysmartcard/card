import 'package:flutter/material.dart';

class AppLightTextFormField extends StatefulWidget {
  final String hintText,initialValue;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool isPassword, isEnabled;

  AppLightTextFormField(
      {Key? key,
      required this.hintText,
      required this.onChanged,
      this.isPassword = false,
      this.keyboardType,
      this.isEnabled = true,
      this.initialValue = ''})
      : super(key: key);

  @override
  _AppLightTextFormFieldState createState() => _AppLightTextFormFieldState();
}

class _AppLightTextFormFieldState extends State<AppLightTextFormField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(
              color: const Color(0x1a000000),
              offset: Offset(0,4),
              blurRadius: 25,
              spreadRadius: 0
          )] ,
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: widget.initialValue,
              enabled: widget.isEnabled,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPassword ? !_isPasswordVisible : false,
              enableSuggestions: !widget.isPassword,
              autocorrect: !widget.isPassword,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
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
