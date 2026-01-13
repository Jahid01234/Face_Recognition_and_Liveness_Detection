import 'dart:io';
import 'package:face_recognition_and_detection/core/const/app_size.dart';
import 'package:face_recognition_and_detection/core/style/global_text_style.dart';
import 'package:face_recognition_and_detection/features/registered_faces/controller/registered_faces_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisteredFacesScreen extends StatelessWidget {
  RegisteredFacesScreen({super.key});

  final RegisteredFacesController controller = Get.put(
    RegisteredFacesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 🔙 Header
              Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Registered Faces",
                    style: globalTextStyle(
                      fontSize: 22,
                      color: Colors.black45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 20),

              /// 📋 Face List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.faces.isEmpty) {
                    return const Center(
                      child: Text(
                        "No faces registered yet",
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.faces.length,
                    itemBuilder: (context, index) {
                      final face = controller.faces[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            /// Avatar
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.green.shade200,
                              child:
                                  (face.imagePaths.isNotEmpty &&
                                      File(face.imagePaths).existsSync())
                                  ? ClipOval(
                                      child: Image.file(
                                        File(face.imagePaths),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(Icons.person, size: 28),
                            ),

                            const SizedBox(width: 15),

                            /// Name + Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    face.name,
                                    style: globalTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Id: ${face.id}",
                                    style: globalTextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                controller.deleteFace(face.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: getHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
