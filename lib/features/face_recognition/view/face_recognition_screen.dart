import 'package:face_recognition_and_detection/core/const/app_size.dart';
import 'package:face_recognition_and_detection/core/const/images_path.dart';
import 'package:face_recognition_and_detection/core/global_widgets/app_header_tile.dart';
import 'package:face_recognition_and_detection/core/global_widgets/app_primary_button.dart';
import 'package:face_recognition_and_detection/core/global_widgets/face_painter.dart';
import 'package:face_recognition_and_detection/core/style/global_text_style.dart';
import 'package:face_recognition_and_detection/features/face_recognition/controller/face_recognition_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FaceRecognitionScreen extends StatelessWidget {
  FaceRecognitionScreen({super.key});

  final FaceRecognitionController controller = Get.put(
    FaceRecognitionController(),
  );

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
              AppHeaderTile(title: "Face Recognition"),
              SizedBox(height: getHeight(150)),

              // Image card.......
              Obx(() {
                if (controller.image.value == null ||
                    controller.imageSize.value == null) {
                  return _emptyCard();
                }

                final file = controller.image.value!;

                return Center(
                  child: Container(
                    height: 300,
                    width: 280,
                    padding: const EdgeInsets.all(12),
                    decoration: _cardDecoration(),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(
                            file,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // 🔹 FACE BOX
                        CustomPaint(
                          painter: FacePainter(
                            controller.faces,
                            controller.imageSize.value!,
                          ),
                        ),

                        if (controller.isProcessing.value)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),


              const SizedBox(height: 30),

              // NAME RESULT........
              Obx(
                    () {
                  if (controller.recognizedName.value.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Result: ",
                          style: globalTextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        TextSpan(
                          text: controller.recognizedName.value,
                          style: globalTextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

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


