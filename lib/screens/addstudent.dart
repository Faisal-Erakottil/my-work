import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student/db_helper/db_helper.dart';
import 'package:student/model/students.dart';
import 'package:image_picker/image_picker.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  var studentNameController = TextEditingController();
  var studentClassController = TextEditingController();
  var studentAgeController = TextEditingController();
  var studentRollController = TextEditingController();
  // var studentaddressController = TextEditingController();
  bool validateName = false;
  bool validateClass = false;
  bool validateAge = false;
  bool validateRoll = false;
  //bool validateaddress = false;

  // var userService = UserService();
  File? Imagepath;
  String? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
            child: const Text(
              'ADD STUDENT',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            //====================image preview=================
            CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: selectedImage != null
                    ? FileImage(
                        File(selectedImage!),
                      )
                    : null), //display selected image if available
            //==================================================
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Add New Student',
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
                  // TextField(
                  //   controller: studentaddressController,
                  //   decoration: InputDecoration(
                  //     prefixIcon: Icon(Icons.person),
                  //     border: OutlineInputBorder(
                  // borderRadius:BorderRadius.circular(25),),
                  //     hintText: 'Enter Your Address',
                  //     labelText: 'Addess',
                  //     errorText: validateaddress ? 'Address is Empty' : null,
                  //   ),
                  // ),

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          // foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(fontSize: 15),
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
                            // studentaddressController.text.isEmpty
                            //     ? validateaddress = true
                            //     : validateaddress = false;
                          });
                          if (validateName == false &&
                              validateClass == false &&
                              validateAge == false &&
                              validateRoll == false &&
                              //validateaddress == false &&
                              selectedImage != null) {
                            // print('data can save');
                            var student = Student();
                            student.name = studentNameController.text;
                            student.clas = studentClassController.text;
                            student.age = studentAgeController.text;
                            student.Roll = studentRollController.text;
                            //student.address = studentaddressController.text;
                            student.selectedImage = selectedImage;
                            // var result = await userService.SaveUser(student);
                            // print(result);  var result = await DatabaseHelper()

                            var result = await DatabaseHelper.instance
                                .insertData('students', student.studentMap());
                            Navigator.pop(context, result);
                          }
                        },
                        child: const Text(
                          'SAVE DETAILS',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            textStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () {
                            studentNameController.text = '';
                            studentClassController.text = '';
                            studentAgeController.text = '';
                            studentRollController.text = '';
                            // studentaddressController.text = '';
                          },
                          child: const Text('CLEAR'),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }

//==================================================================image picker
  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      Imagepath = File(returnedImage!.path);
      selectedImage = returnedImage.path.toString();
    });
  }
}
