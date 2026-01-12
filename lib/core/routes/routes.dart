import 'package:face_recognition_and_detection/features/home/view/home_screen.dart';
import 'package:get/get.dart';


class AppRoutes {
  // Get routes name here.......
  static const String home = '/home';





  // Get routes here.......
  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: ()=> HomeScreen(),
      transition: Transition.leftToRight,
    ),


  ];
}