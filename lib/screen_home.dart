import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqfligth_students/db/functions/db_functions.dart';
import 'package:sqfligth_students/profile.dart';
import 'package:sqfligth_students/widget/add_student.dart';
import 'package:sqflite/sqflite.dart';

import 'db/model/data_model.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

//late final database = getAllStudents();

class _ScreenHomeState extends State<ScreenHome> {
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> searchItems = [];
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _refreshStudents();
  }

  void _refreshStudents() async {
    try {
      final h = getAllStudents().then((value) {
        setState(() {
          _students = value;
          searchItems = value;
        });
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void filterSearch(String query) async {
    List<Map<String, dynamic>> studentList = _students;
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> studentData = [];
      for (var item in studentList) {
        var student = StudentModel.fromMap(item);
        if (student.name.toLowerCase().contains(query.toLowerCase())) {
          studentData.add(item);
        }
      }
      setState(() {
        searchItems = [];
        searchItems.addAll(studentData);
      });
      return;
    } else {
      setState(() {
        searchItems = [];
        searchItems = _students;
      });
    }
  }

  // Database? database;

  // @override
  // void initState() {
  //   // open the database
  //   openDatabase('', version: 1, onCreate: (Database db, int version) async {
  //     database = db;
  //     // When creating the db, create the table
  //   });

  //   super.initState();
  // }

// void __refreshStudents() async {
//     try {
//         setState(() {
//           _students = database;
//           searchItems = database;

//       });
//     } catch (err) {
//       // ignore: avoid_print
//       print("Exception caught: $err");
//     }
//   }
  // dynamic data;

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    _refreshStudents();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.search),
                    title: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      onChanged: (String text) {
                        // _students = searchStudent(text);
                        // _students.isEmpty
                        //     ? print("student from database is empty")
                        //     : setState(() {
                        //         searchItems = _students;
                        //         filterSearch(text);
                        //         print(searchItems);
                        //       });

                        setState(() {
                          filterSearch(text);
                        });

                        // print(database);
                        // if (database != null) {
                        //   List<Map> res = await database!.query("student.db",
                        //       where: "name LIKE ?", whereArgs: ['%$text%']);
                        //   print(text);
                        //   print(res);
                        // }
                        // setState(() {
                        //   print('in search setstate');
                        //   data = searchStudent(text);
                        //   //filterSearch(text);
                        //   Search(
                        //     text: text,
                        //   );
                        //   //print(data.name);
                        // });
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(builder: (ctx) {
                        //     return Search(
                        //       text: text,
                        //     );
                        //   }),
                        // );
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        controller.clear();
                        //   onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Expanded(
            //   child: ValueListenableBuilder(
            //     valueListenable: studentListNotifier,
            //     builder: (BuildContext ctx, List<StudentModel> studentList,
            //         Widget? child) {
            //       return ListView.separated(
            //         itemBuilder: (ctx, index) {
            //           final data = studentList[index];

            //           return ListTile(
            //             onTap: () {
            //               Navigator.of(context).push(
            //                 MaterialPageRoute(builder: (ctx) {
            //                   return ProfileStudent(
            //                     data: data,
            //                   );
            //                 }),
            //               );
            //             },
            //             title: Text(data.name),
            //             leading: CircleAvatar(
            //               radius: 40,
            //               backgroundImage: Image.file(File(data.image)).image,
            //               //child: Image.memory(bytes) ,
            //             ),
            //             trailing: IconButton(
            //               onPressed: () {
            //                 if (data.id != null) {
            //                   deleteStudent(data.id!);
            //                 } else {
            //                   print('Student_id is null, unable to delete');
            //                 }
            //               },
            //               icon: Icon(
            //                 Icons.delete,
            //                 color: Colors.red,
            //               ),
            //             ),
            //           );
            //         },
            //         separatorBuilder: (ctx, index) {
            //           return const Divider();
            //         },
            //         itemCount: studentList.length,
            //       );
            //     },
            //   ),
            // ),
            Container(
              height: 620,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  final data = StudentModel.fromMap(searchItems[index]);
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) {
                              return ProfileStudent(
                                data: data,
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
                              _refreshStudents();
                            } else {
                              print('Student_id is null, unable to delete');
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider()
                    ],
                  );
                },
                itemCount: searchItems.length,
              ),
            )
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
