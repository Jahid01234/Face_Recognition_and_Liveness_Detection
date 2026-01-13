import 'package:face_recognition_and_detection/core/const/app_size.dart';
import 'package:face_recognition_and_detection/core/const/images_path.dart';
import 'package:face_recognition_and_detection/core/global_widgets/app_primary_button.dart';
import 'package:face_recognition_and_detection/core/style/global_text_style.dart';
import 'package:face_recognition_and_detection/features/face_registration/controller/face_registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';



class FaceRegistrationScreen extends StatelessWidget {
  FaceRegistrationScreen({super.key});

  final FaceRegistrationController controller =
  Get.put(FaceRegistrationController());

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
              //
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
                    "Face Registration",
                    style: globalTextStyle(
                      fontSize: 22,
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

             SizedBox(height: getHeight(150)),

              /// 📸 Image Preview Card
              Obx(() {
                if (controller.image.value == null) {
                  return _emptyPreview();
                }

                final file = controller.image.value!;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 300,
                        width: 280,
                        padding: const EdgeInsets.all(12),
                        decoration: _cardDecoration(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CustomPaint(
                            painter: FacePainter(
                              controller.faces,
                              const Size(300, 300),
                            ),
                            child: Image.file(
                              file,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// ⏳ Loading
                    if (controller.isProcessing.value)
                      Center(
                        child: Container(
                          height: 300,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
               },
              ),

              const Spacer(),

              /// 🎛 Buttons
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

  /// Empty State
  Widget _emptyPreview() {
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

/// 🎯 Face Bounding Box Painter
class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;

  FacePainter(this.faces, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.greenAccent;

    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    for (final face in faces) {
      final rect = Rect.fromLTRB(
        face.boundingBox.left * scaleX,
        face.boundingBox.top * scaleY,
        face.boundingBox.right * scaleX,
        face.boundingBox.bottom * scaleY,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}