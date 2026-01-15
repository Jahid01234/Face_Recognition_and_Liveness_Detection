import 'package:face_recognition_and_detection/core/const/images_path.dart';
import 'package:face_recognition_and_detection/features/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          ImagesPath.appLogo,
          height: 120,
          width: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
