import 'package:face_recognition_and_detection/core/style/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppHeaderTile extends StatelessWidget {
  final String title;

  const AppHeaderTile({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: Get.back,
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
            size: 20,
          ),
        ),
        const SizedBox(width: 40),
        Text(
          title,
          style: globalTextStyle(
            fontSize: 22,
            color: Colors.black45,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
