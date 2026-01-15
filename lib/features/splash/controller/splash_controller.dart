import 'package:face_recognition_and_detection/core/routes/routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{
  @override
  void onInit() {
    super.onInit();
    redirectToNextScreen();
  }


  Future<void> redirectToNextScreen()async{
    await Future.delayed( const Duration(seconds: 2));
      Get.offAllNamed(AppRoutes.home);
  }
}