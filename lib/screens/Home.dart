import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student/db_helper/db_helper.dart';
import 'package:student/model/students.dart';
import 'package:student/screens/Gridview.dart';
import 'package:student/screens/SearchScrean.dart';
import 'package:student/screens/addstudent.dart';
import 'package:student/screens/viewStudent.dart';
import 'package:student/screens/EditUser.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Student> userlist = [];
  // final userService = UserService();
  getAllUserDetails() async {
    var users = await DatabaseHelper.instance.readAllUsers();
    userlist.clear();
    // userlist = <Student>[];
    users.forEach((user) {
      setState(() {
        var userModel = Student();

        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.clas = user['clas'];
        userModel.age = user['age'];
        userModel.Roll = user['Roll'];
        // userModel.address = user['address'];

        userModel.selectedImage = user['selectedImage'];
        userlist.add(userModel);
      });
    });
  }

  @override
  void initState() {
    getAllUserDetails();
    super.initState();
  }

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text('Are you sure you want to delete this profile?'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.green),
                  onPressed: () async {
                    var result = await DatabaseHelper.instance
                        .deleteDataById('students', userId);
                    if (result != null) {
                      getAllUserDetails();
                      Navigator.pop(context);
                      showSnackBar('Deleted succesfully');
                    }
                  },
                  child: const Text('DELETE'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightGreen),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL')),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'STUDENTS RECORD',
          style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
            icon: Icon(Icons.search),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Gridview()),
              );
            },
            icon: Icon(Icons.grid_view_rounded),
            color: Colors.white,
          )
        ],
      ),
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: userlist.isEmpty
              //==Empty Home page management with Text==
              ? Center(
                  child: Text(
                    "No student records availavle",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              //========================================
              : ListView.builder(
                  itemCount: userlist.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => viewStudent(
                                  user: userlist[index],
                                ),
                              ));
                        },
                        leading: CircleAvatar(
                          backgroundImage: userlist[index].selectedImage !=
                                      null &&
                                  File(userlist[index].selectedImage!)
                                      .existsSync()
                              ? FileImage(File(userlist[index].selectedImage!))
                                  as ImageProvider<Object>?
                              : NetworkImage(
                                  'https://i.pngimg.me/thumb/f/720/m2H7K9A0Z5m2G6b1.jpg'),
                        ),
                        title: Text(userlist[index].name ?? ''),
                        subtitle: Text(userlist[index].clas ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditUser(
                                          user: userlist[index],
                                        ),
                                      )).then((data) {
                                    if (data != null) {
                                      getAllUserDetails();
                                      showSnackBar('Updated succesfully');
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                )),
                            IconButton(
                                onPressed: () {
                                  deleteFormDialog(context, userlist[index].id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStudent(),
            ),
          ).then((data) {
            if (data != null) {
              getAllUserDetails();
              showSnackBar('Saved succesfully');
            }
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
