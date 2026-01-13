import 'package:face_recognition_and_detection/core/services/local_service/face_database.dart';
import 'package:face_recognition_and_detection/core/services/model/face_model.dart';
import 'package:get/get.dart';


class RegisteredFacesController extends GetxController {
  final RxList<FaceModel> faces = <FaceModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRegisteredFaces();
  }

  Future<void> loadRegisteredFaces() async {
    try {
      isLoading.value = true;
      final result = await FaceDatabase.getAllFaces();
      faces.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteFace(int id) async {
    try {
      isLoading.value = true;
      await FaceDatabase.deleteFace(id);
      faces.removeWhere((face) => face.id == id);
    } finally {
      isLoading.value = false;
    }
  }

}