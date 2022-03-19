import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final bool isLoading;

  AppLoading({Key? key, required this.isLoading}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0x4dc4c4c4),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}