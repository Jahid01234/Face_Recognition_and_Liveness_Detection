import 'package:face_recognition_and_detection/core/const/app_size.dart';
import 'package:face_recognition_and_detection/core/const/images_path.dart';
import 'package:face_recognition_and_detection/core/global_widgets/app_primary_button.dart';
import 'package:face_recognition_and_detection/core/style/global_text_style.dart';
import 'package:face_recognition_and_detection/features/face_recognition/controller/face_recognition_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';


class FaceRecognitionScreen extends StatelessWidget {
  FaceRecognitionScreen({super.key});

  final FaceRecognitionController controller =
  Get.put(FaceRecognitionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 40),
                  Text(
                    "Face Recognition",
                    style: globalTextStyle(
                      fontSize: 22,
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

             SizedBox(height: getHeight(150)),

              // Image card.......
              Obx(() {
                if (controller.image.value == null) {
                  return _emptyCard();
                }
                return Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 300,
                        width: 280,
                        decoration: _cardDecoration(),
                        padding: EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CustomPaint(
                            painter: FacePainter(controller.faces),
                            child: Image.file(
                              controller.image.value!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (controller.isProcessing.value)
                      const Positioned.fill(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              }),

              const SizedBox(height: 30),

              // NAME RESULT........
              Obx(() => Text(
                controller.recognizedName.value.isEmpty
                    ? ""
                    : "Result: ${controller.recognizedName.value}",
                style: globalTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),

              const Spacer(),
              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppPrimaryButton(
                      width: 150,
                      height: 50,
                      radius: 12,
                      text: "Gallery",
                      icon: Icons.photo,
                      bgColor: Colors.grey.shade400,
                      textColor: Colors.white,
                      onTap: controller.isProcessing.value
                          ? () {}
                          : controller.pickFromGallery,
                    ),
                    AppPrimaryButton(
                      width: 150,
                      height: 50,
                      radius: 12,
                      text: "Camera",
                      icon: Icons.camera_alt,
                      bgColor: Colors.grey.shade400,
                      textColor: Colors.white,
                      onTap: controller.isProcessing.value
                          ? () {}
                          : controller.pickFromCamera,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }


  Widget _emptyCard() {
    return Center(
      child: Container(
        height: 300,
        width: 280,
        padding: EdgeInsets.all(10),
        decoration: _cardDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            ImagesPath.appLogo,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}

// Face Bounding Box Painter
class FacePainter extends CustomPainter {
  final List<Face> faces;
  FacePainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.height.isNaN || size.width.isNaN) return;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.green;

    for (final face in faces) {
      canvas.drawRect(face.boundingBox, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}