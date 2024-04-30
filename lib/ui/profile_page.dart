import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class User_Profile extends StatefulWidget {
  const User_Profile({super.key});

  @override
  State<User_Profile> createState() => _User_ProfileState();
}

class _User_ProfileState extends State<User_Profile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<XFile?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      return pickedFile;
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
      return null;
    }
  }

  Future<String> saveImageToFirebaseStorage(
      String userId, File imageFile) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('avatars/$userId/avatar.jpg');
    final UploadTask uploadTask = storageRef.putFile(imageFile);
    await uploadTask;
    final String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateAvatarInFirestore(String userId, String avatarUrl) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');
    await usersCollection.doc(userId).update({'avatar': avatarUrl});
  }

  Future<void> _showEditProfileDialog(
      String currentName, String currentDescription) async {
    String newName = currentName;
    String newDescription = currentDescription;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Редактирование профиля'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: newName),
                onChanged: (value) => newName = value,
                decoration: InputDecoration(labelText: 'Имя'),
              ),
              TextField(
                controller: TextEditingController(text: newDescription),
                onChanged: (value) => newDescription = value,
                decoration: InputDecoration(labelText: 'Описание'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newName.trim().isNotEmpty) { // Проверяем, что имя пользователя не пустое после удаления начальных и конечных пробелов
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(currentUser.uid)
                      .update({
                    'name': newName,
                    'description': newDescription,
                  });
                  Navigator.of(context).pop();
                } else {
                  // Отображаем сообщение об ошибке, если имя пользователя пустое
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Имя пользоватея не может быть пустым'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16))),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                    radius: 88,
                                    backgroundImage: (userData["avatar"] !=
                                            null)
                                        ? NetworkImage(userData["avatar"])
                                        : const NetworkImage(
                                            "https://picsum.photos/250?image=9")),
                                Positioned(
                                    bottom: 1,
                                    right: 5,
                                    child: IconButton(
                                        onPressed: () async {
                                          XFile? pickedImage =
                                              await pickImageFromGallery();
                                          if (pickedImage != null) {
                                            setState(() {});
                                            String imageUrl =
                                                await saveImageToFirebaseStorage(
                                                    currentUser.uid,
                                                    File(pickedImage.path));
                                            await updateAvatarInFirestore(
                                                currentUser.uid, imageUrl);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.cached,
                                          color: Colors.white,
                                          size: 50,
                                        )))
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              userData["name"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                              child: Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              userData["description"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Создал",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                    Text(
                                      userData["problemsCreated"].toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    )
                                  ],
                                ),
                                const VerticalDivider(
                                  color: Colors.red,
                                  thickness: 20,
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Помощи",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                    Text(
                                      userData["problemsDesided"].toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            _showEditProfileDialog(
                                userData["name"], userData["description"]);
                          },
                          child: Text(
                            "Изменить",
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          )),
                      TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushNamed(context, "/");
                          },
                          child: const Text("Выйти",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24)))
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error" + snapshot.error.toString()),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
