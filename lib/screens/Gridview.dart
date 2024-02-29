import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student/db_helper/db_helper.dart';
import 'package:student/model/students.dart';
import 'package:student/screens/viewStudent.dart';

class Gridview extends StatefulWidget {
  const Gridview({Key? key});
  @override
  State<Gridview> createState() => _Gridview();
}

class _Gridview extends State<Gridview> {
  late List<dynamic> userList = [];

  getAllUserDetails() async {
    var users = await DatabaseHelper.instance.readAllUsers();
    setState(() {
      userList = users.map((user) {
        var userModel = Student();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.clas = user['clas'];
        userModel.age = user['age'];
        userModel.Roll = user['Roll'];
        userModel.selectedImage = user['selectedImage'];
        return userModel;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 198, 196, 196),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.list_outlined),
            padding: EdgeInsets.only(right: 30),
          )
        ],
        backgroundColor: Colors.green,
        title: const Text('GRID VIEW'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 18,
        ),
        itemCount: userList.length,
        itemBuilder: (context, index) => Card(
          elevation: 0,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => viewStudent(
                  user: userList[index],
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: userList[index].selectedImage != null &&
                            File(userList[index].selectedImage!).existsSync()
                        ? FileImage(File(userList[index].selectedImage!))
                            as ImageProvider<Object>?
                        : NetworkImage(
                            'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_1280.png'),
                  ),
                  SizedBox(height: 8),
                  Text(userList[index].name ?? 'No Name'),
                  Text(userList[index].clas ?? 'No class'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
