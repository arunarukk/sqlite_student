import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqfligth_students/db/functions/db_functions.dart';
import 'package:sqfligth_students/profile.dart';
import 'package:sqfligth_students/widget/add_student.dart';

import 'db/model/data_model.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {


// List<Map<String, dynamic>> _foundUsers = [];
//   @override
//   initState() {
//     // at the beginning, all users are shown
//     _foundUsers = ;
//     super.initState();
//   }

//   // This function is called whenever the text field changes
//   void _runFilter(String enteredKeyword) {
//     List<Map<String, dynamic>> results = [];
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = _allUsers;
//     } else {
//       results = _allUsers
//           .where((user) =>
//               user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
//           .toList();
//       // we use the toLowerCase() method to make it case-insensitive
//     }

//     // Refresh the UI
//     setState(() {
//       _foundUsers = results;
//     });
//   }


  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Card(
                  child:  ListTile(
                    leading:  Icon(Icons.search),
                    title:  TextField(
                      //controller: controller,
                      decoration:  InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      //   onChanged: onSearchTextChanged,
                    ),
                    trailing:  IconButton(
                      icon:  Icon(Icons.cancel),
                      onPressed: () {
                        // controller.clear();
                        //   onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: studentListNotifier,
                builder: (BuildContext ctx, List<StudentModel> studentList,
                    Widget? child) {
                  return ListView.separated(
                    itemBuilder: (ctx, index) {
                      final data = studentList[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) {
                              return ProfileStudent(
                                data: studentList[index],
                              );
                            }),
                          );
                        },
                        title: Text(data.name),
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: Image.file(File(data.image)).image,
                          //child: Image.memory(bytes) ,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            if (data.id != null) {
                              deleteStudent(data.id!);
                            } else {
                              print('Student_id is null, unable to delete');
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return const Divider();
                    },
                    itemCount: studentList.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AddStudent();
              });
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (ctx) {
          //     return AddStudent();
          //   }),
          // );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
