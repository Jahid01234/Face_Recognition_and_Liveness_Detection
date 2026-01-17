import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:face_recognition_and_detection/core/services/local_service/face_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionController extends GetxController {
  final Rx<File?> image = Rx<File?>(null);
  final RxList<Face> faces = <Face>[].obs;
  final RxBool isProcessing = false.obs;
  final RxString recognizedName = "".obs;
  final ImagePicker _picker = ImagePicker();
  late FaceDetector _faceDetector;
  late Interpreter _interpreter;
  bool _modelLoaded = false;

  final Rx<Size?> imageSize = Rx<Size?>(null);


  @override
  void onInit() {
    super.onInit();
    _initFaceDetector();
    _loadModel();
  }

  void _initFaceDetector() {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<void> _loadModel() async {
    _interpreter =
    await Interpreter.fromAsset('assets/models/mobile_face_net.tflite');
    _modelLoaded = true;
  }

  /// ================= IMAGE PICK =================
  void pickFromGallery() => _pick(ImageSource.gallery);
  void pickFromCamera() => _pick(ImageSource.camera);

  Future<void> _pick(ImageSource source) async {
    if (isProcessing.value) return;

    final XFile? picked =
    await _picker.pickImage(source: source, imageQuality: 100);

    if (picked == null) return;

    image.value = File(picked.path);
    faces.clear();
    imageSize.value = null;

    await _detectAndRecognize();
  }

  /// ================= FACE DETECT + RECOGNIZE =================
  Future<void> _detectAndRecognize() async {
    if (!_modelLoaded || image.value == null) return;

    try {
      isProcessing.value = true;

      final bytes = await image.value!.readAsBytes();
      final decodedImage = img.decodeImage(bytes);

      if (decodedImage == null) {
        _showError("Invalid image");
        return;
      }

      imageSize.value = Size(
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble(),
      );

      final inputImage = InputImage.fromFile(image.value!);
      final detectedFaces =
      await _faceDetector.processImage(inputImage);

      if (detectedFaces.isEmpty) {
        _showError("No face detected");
        return;
      }

      faces.assignAll(detectedFaces);

      final embedding =
      await _generateEmbedding(detectedFaces.first);

      final name = await _recognizeFace(embedding);
      recognizedName.value = name;

      _showResult(name);
    } catch (e) {
      _showError("Recognition failed");
    } finally {
      isProcessing.value = false;
    }
  }

  /// ================= EMBEDDING =================
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

  /// ================= FACE MATCH =================
  Future<String> _recognizeFace(List<double> embedding) async {
    final faces = await FaceDatabase.getAllFaces();

    double minDistance = double.infinity;
    String result = "Unknown";

    for (final face in faces) {
      final dist = _euclideanDistance(embedding, face.embedding);
      if (dist < minDistance) {
        minDistance = dist;
        result = face.name;
      }
    }

    return minDistance < 1.1 ? result : "Unknown";
  }

  double _euclideanDistance(List<double> e1, List<double> e2) {
    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += math.pow(e1[i] - e2[i], 2);
    }
    return math.sqrt(sum);
  }


  void _showResult(String name) {
    if (name == "Unknown") {
      Get.snackbar(
        "Not Recognized",
        "Face not matched with database",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } else {
      Get.snackbar(
        "Success",
        "Hello, $name 👋",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.verified, color: Colors.white),
      );
    }
  }

  void _showError(String msg) {
    Get.snackbar(
      "Error",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    _faceDetector.close();
    _interpreter.close();
    super.onClose();
  }
}

