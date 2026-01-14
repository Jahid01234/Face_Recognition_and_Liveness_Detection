import 'package:face_recognition_and_detection/core/const/app_size.dart';
import 'package:face_recognition_and_detection/core/const/images_path.dart';
import 'package:face_recognition_and_detection/core/global_widgets/app_primary_button.dart';
import 'package:face_recognition_and_detection/core/routes/routes.dart';
import 'package:face_recognition_and_detection/core/style/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getHeight(30)),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Face Recognition",
                      style: globalTextStyle(
                        fontSize: 22,
                        color: Colors.black45,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: getHeight(130)),
                    Image.asset(ImagesPath.appLogo, width: 200, height: 200),
                  ],
                ),
              ),
              SizedBox(height: getHeight(100)),
              AppPrimaryButton(
                text: "Register Face",
                bgColor: Colors.grey.shade400,
                icon: Icons.account_circle_outlined,
                textColor: Colors.white,
                onTap: () {
                  Get.toNamed(AppRoutes.faceRegistration);
                },
              ),
              SizedBox(height: getHeight(20)),
              AppPrimaryButton(
                text: "Recognition Face",
                bgColor: Colors.grey.shade400,
                icon: Icons.account_circle,
                textColor: Colors.white,
                onTap: () {
                  Get.toNamed(AppRoutes.faceRecognition);
                },
              ),
              SizedBox(height: getHeight(20)),
              AppPrimaryButton(
                text: "Registered Faces",
                bgColor: Colors.grey.shade400,
                icon: Icons.list_alt,
                textColor: Colors.white,
                onTap: () {
                  Get.toNamed(AppRoutes.registeredFaces);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
