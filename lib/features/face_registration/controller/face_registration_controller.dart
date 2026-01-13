import 'dart:io';
import 'dart:typed_data';
import 'package:face_recognition_and_detection/core/global_widgets/app_primary_button.dart';
import 'package:face_recognition_and_detection/core/services/local_service/face_database.dart';
import 'package:face_recognition_and_detection/core/services/model/face_model.dart';
import 'package:face_recognition_and_detection/core/style/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRegistrationController extends GetxController {
  // =========================
  // OBSERVABLE STATES
  // =========================
  final Rx<File?> image = Rx<File?>(null);
  final RxList<Face> faces = <Face>[].obs;
  final RxBool isProcessing = false.obs;

  final TextEditingController nameController = TextEditingController();

  // =========================
  // INSTANCES
  // =========================
  final ImagePicker _picker = ImagePicker();
  late FaceDetector _faceDetector;
  late Interpreter _interpreter;

  bool _modelLoaded = false;

  // =========================
  // LIFECYCLE
  // =========================
  @override
  void onInit() {
    super.onInit();
    _initFaceDetector();
    _loadModel();
  }

  // =========================
  // INIT
  // =========================
  void _initFaceDetector() {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
        enableLandmarks: false,
        enableContours: false,
      ),
    );
  }

  Future<void> _loadModel() async {
    try {
      _interpreter =
      await Interpreter.fromAsset('assets/models/mobile_face_net.tflite');
      _modelLoaded = true;
    } catch (e) {
      _showError("Face model load failed");
    }
  }

  // =========================
  // IMAGE PICK
  // =========================
  void pickFromGallery() => _pickImage(ImageSource.gallery);
  void pickFromCamera() => _pickImage(ImageSource.camera);

  Future<void> _pickImage(ImageSource source) async {
    if (isProcessing.value) return;

    final XFile? picked =
    await _picker.pickImage(source: source, imageQuality: 100);

    if (picked == null) return;

    image.value = File(picked.path);
    faces.clear();

    await _detectFace();
  }

  // =========================
  // FACE DETECTION
  // =========================
  Future<void> _detectFace() async {
    if (image.value == null) return;

    try {
      isProcessing.value = true;

      final inputImage = InputImage.fromFile(image.value!);
      final detectedFaces =
      await _faceDetector.processImage(inputImage);

      if (detectedFaces.isEmpty) {
        _showError("No face detected");
        return;
      }

      faces.assignAll(detectedFaces);

      if (!_modelLoaded) {
        _showError("Face model not ready");
        return;
      }

      final embedding =
      await _generateEmbedding(detectedFaces.first);

      _showRegisterBottomSheet(embedding);
    } catch (e) {
      _showError("Face detection failed");
    } finally {
      isProcessing.value = false;
    }
  }

  // =========================
  // EMBEDDING GENERATION
  // =========================
  Future<List<double>> _generateEmbedding(Face face) async {
    final bytes = await image.value!.readAsBytes();
    final img.Image original = img.decodeImage(bytes)!;

    final rect = face.boundingBox;

    int x = rect.left.toInt().clamp(0, original.width - 1);
    int y = rect.top.toInt().clamp(0, original.height - 1);
    int w = rect.width.toInt();
    int h = rect.height.toInt();

    if (x + w > original.width) w = original.width - x;
    if (y + h > original.height) h = original.height - y;

    final img.Image cropped =
    img.copyCrop(original, x: x, y: y, width: w, height: h);

    final img.Image resized =
    img.copyResize(cropped, width: 112, height: 112);

    final Float32List input = Float32List(1 * 112 * 112 * 3);
    int index = 0;

    for (int y = 0; y < 112; y++) {
      for (int x = 0; x < 112; x++) {
        final pixel = resized.getPixel(x, y);
        input[index++] = (pixel.r - 128) / 128;
        input[index++] = (pixel.g - 128) / 128;
        input[index++] = (pixel.b - 128) / 128;
      }
    }

    final output = List.filled(192, 0.0).reshape([1, 192]);
    _interpreter.run(input.reshape([1, 112, 112, 3]), output);

    return List<double>.from(output[0]);
  }

  // =========================
  // REGISTER UI
  // =========================
  void _showRegisterBottomSheet(List<double> embedding) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Register Face",
              style: globalTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 15),
            ClipOval(
              child: Image.file(
                image.value!,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Enter Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            AppPrimaryButton(
              text: "Register",
              textColor: Colors.white,
              bgColor: Colors.grey.shade600,
              onTap: () => _registerFace(embedding),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // =========================
  // SAVE TO SQLITE
  // =========================
  Future<void> _registerFace(List<double> embedding) async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      _showError("Name is required");
      return;
    }

    try {
      isProcessing.value = true;

      final face = FaceModel(
        name: name,
        embedding: embedding,
        imagePaths: image.value!.path,
      );

      await FaceDatabase.insertFace(face);

      nameController.clear();
      Get.back();

      Get.snackbar(
        "Success",
        "Face registered successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _showError("Failed to save face");
    } finally {
      isProcessing.value = false;
    }
  }

  // =========================
  // HELPERS
  // =========================
  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    _faceDetector.close();
    _interpreter.close();
    nameController.dispose();
    super.onClose();
  }
}