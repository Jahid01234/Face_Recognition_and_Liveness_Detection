import 'dart:io';
import 'package:face_recognition_and_detection/core/const/app_size.dart';
import 'package:face_recognition_and_detection/core/global_widgets/app_header_tile.dart';
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
              AppHeaderTile(title: "Registered Faces"),
              const SizedBox(height: 20),

              // Face List..........
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.faces.isEmpty) {
                    return Center(
                      child: Text(
                        "No faces registered yet",
                        style: globalTextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.faces.length,
                    itemBuilder: (context, index) {
                      final face = controller.faces[index];
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.10),
                              blurRadius: 3,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.green.shade200,
                              child:
                                  (face.imagePaths.isNotEmpty &&
                                      File(face.imagePaths).existsSync())
                                  ? ClipOval(
                                      child: SizedBox(
                                        width: 56,
                                        height: 56,
                                        child: Image.file(
                                          File(face.imagePaths),
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) {
                                            return const Icon(
                                              Icons.person,
                                              size: 28,
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : Icon(Icons.person, size: 28),
                            ),

                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    face.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: globalTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "ID: ${face.id}",
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
                                Icons.delete,
                                color: Colors.grey,
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

