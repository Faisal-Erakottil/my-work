import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student/db_helper/db_helper.dart';
import 'package:student/model/students.dart';
import 'package:image_picker/image_picker.dart';

class EditUser extends StatefulWidget {
  final Student user;
  const EditUser({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  var studentNameController = TextEditingController();
  var studentClassController = TextEditingController();
  var studentAgeController = TextEditingController();
  var studentRollController = TextEditingController();
  bool validateName = false;
  bool validateClass = false;
  bool validateAge = false;
  bool validateRoll = false;
  File? Imagepath;
  String? selectedImage;
  // var userService = UserService();
  @override
  void initState() {
    setState(() {
      studentNameController.text = widget.user.name ?? '';
      studentClassController.text = widget.user.clas ?? '';
      studentAgeController.text = widget.user.age ?? '';
      studentRollController.text = widget.user.Roll ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            'ADD STUDENT',
            style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Edit Student Details',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 6, 6, 6),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: studentNameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      hintText: 'Enter Your Name',
                      labelText: 'Name',
                      errorText: validateName ? 'Name is Empty' : null,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: studentClassController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.class_),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      hintText: 'Enter Your Class',
                      labelText: 'Class',
                      errorText: validateClass ? 'class is Empty' : null,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    controller: studentAgeController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.cake_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      hintText: 'Enter Your Age',
                      labelText: 'Age',
                      errorText: validateAge ? 'Age is Empty' : null,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    controller: studentRollController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      hintText: 'Enter Your Roll Number',
                      labelText: 'Roll Number',
                      errorText: validateRoll ? 'Roll Number is Empty' : null,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  MaterialButton(
                      color: Colors.green,
                      child: const Text("Add your image"),
                      onPressed: () {
                        pickImageFromGallery();
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          // foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            studentNameController.text.isEmpty
                                ? validateName = true
                                : validateName = false;
                            studentClassController.text.isEmpty
                                ? validateClass = true
                                : validateClass = false;
                            studentAgeController.text.isEmpty
                                ? validateAge = true
                                : validateAge = false;
                            studentRollController.text.isEmpty
                                ? validateRoll = true
                                : validateRoll = false;
                          });
                          if (validateName == false &&
                              validateClass == false &&
                              validateAge == false &&
                              validateRoll == false &&
                              selectedImage != null) {
                            // print('data can save');
                            var student = Student();
                            student.id = widget.user.id;
                            student.name = studentNameController.text;
                            student.clas = studentClassController.text;
                            student.age = studentAgeController.text;
                            student.Roll = studentRollController.text;
                            student.selectedImage = selectedImage;
                            var result = await DatabaseHelper.instance
                                .updateData('students', student.studentMap());
                            Navigator.pop(context, result);
                          }
                        },
                        child: const Text(
                          'UPDATE DETAILS',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () {
                          studentNameController.text = '';
                          studentClassController.text = '';
                          studentAgeController.text = '';
                          studentRollController.text = '';
                        },
                        child: const Text('CLEAR'),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      Imagepath = File(returnedImage!.path);
      selectedImage = returnedImage.path.toString();
    });
  }
}
