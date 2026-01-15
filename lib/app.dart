import 'package:face_recognition_and_detection/core/const/app_size.dart';
import 'package:face_recognition_and_detection/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return GetMaterialApp(
      title: 'Face recognition and detection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}