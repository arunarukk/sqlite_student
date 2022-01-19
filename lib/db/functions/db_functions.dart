import 'package:flutter/cupertino.dart';

import 'package:sqfligth_students/db/model/data_model.dart';
import 'package:sqflite/sqflite.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);
late Database _db;
Future<void> initializeDataBase() async {
  _db = await openDatabase(
    'student.db',
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE student (id INTEGER PRIMARY KEY, name TEXT, age TEXT,clas TEXT,roll TEXT,image TEXT)');
    },
  );
}

Future<StudentModel> addStudent(StudentModel value) async {
  // print({value.age, value.clas, value.name, value.roll});
  // final studentDB = await Hive.openBox<StudentModel>('student_db');
  // final _id = await studentDB.add(value);
  // value.id = _id;

  await _db.rawInsert(
      'INSERT INTO student (name,age,clas,roll,image) VALUES (?,?,?,?,?)',
      [value.name, value.age, value.clas, value.roll, value.image]);
      
  getAllStudents();
  //studentListNotifier.value.add(value);
  // print({value.id, value.name});
  studentListNotifier.notifyListeners();
  return value;
}

Future<dynamic> getAllStudents() async {
  // final studentDB = await Hive.openBox<StudentModel>('student_db');

  final _values = await _db.rawQuery('SELECT * FROM student');
  //print(_values);
  studentListNotifier.value.clear();

  _values.forEach((map) {
    final student = StudentModel.fromMap(map);
    studentListNotifier.value.add(student);
    studentListNotifier.notifyListeners();
  });
  return _values;
  //studentListNotifier.value.addAll(studentDB.values);
}

Future<void> deleteStudent(int id) async {
  // final studentDB = await Hive.openBox<StudentModel>('student_db');
  // await studentDB.delete(id);
  await _db.rawDelete('DELETE FROM student WHERE id = ?', [id]);
  //await _db.close();
  getAllStudents();
  
}

Future<void> editStudent(int id, String name, String age, String clas,
    String roll, String image) async {
  // final studentDB = await Hive.openBox<StudentModel>('student_db');
  //await studentDB.delete(id);
  print('edit');
  final data = {
    'name': name,
    'age': age,
    'clas': clas,
    'roll': roll,
    'image': image,
  };
  final result =
      await _db.update("student", data, where: "id = ?", whereArgs: [id]);
  // await _db.rawUpdate(
  //     'UPDATE student SET name = ?, age = ?,clas = ?,roll=?,image = ? WHERE id=?',
  //     [name, age, clas, roll, image]);

  studentListNotifier.notifyListeners();
  //await _db.close();
  getAllStudents();
}

searchStudent(String text) async {
  final _values = await _db.rawQuery('SELECT * FROM student');
  print(text);

  List<Map> res =
      await _db.query("student", where: "name LIKE ?", whereArgs: ['%$text%']);
  print(res);
  return res;
}
