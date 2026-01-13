import 'package:face_recognition_and_detection/features/face_registration/view/face_registration_screen.dart';
import 'package:face_recognition_and_detection/features/home/view/home_screen.dart';
import 'package:face_recognition_and_detection/features/registered_faces/view/registered_faces.dart';
import 'package:get/get.dart';


class AppRoutes {
  // Get routes name here.......
  static const String home = '/home';
  static const String faceRegistration = '/faceRegistration';
  static const String registeredFaces = '/registeredFaces';





  // Get routes here.......
  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: ()=> HomeScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: faceRegistration,
      page: ()=> FaceRegistrationScreen(),
      transition: Transition.leftToRight,
    ),
   GetPage(
        name: registeredFaces,
        page: ()=> RegisteredFacesScreen(),
        transition: Transition.leftToRight,
      ),
  ];
}