import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqfligth_students/db/functions/db_functions.dart';
import 'package:sqfligth_students/db/model/data_model.dart';
import 'package:sqfligth_students/screen_home.dart';
//import 'package:sqflite/sqflite.dart';

class AddStudent extends StatefulWidget {
  late final data;
  AddStudent({Key? key, this.data}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final values = getAllStudents();
    print("the id in addstate is ${widget.data}");
    if (widget.data != null) {
      initEditButton(widget.data);
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final _nameController = TextEditingController();

  final _ageController = TextEditingController();

  final _classController = TextEditingController();

  final _rollController = TextEditingController();

  dynamic imageTemporary = '';

  initEditButton(final data) async {
    print("inside initEdit$data");

    setState(() {
      _nameController.text = data.name;
      _ageController.text = data.age;
      _classController.text = data.clas;
      _rollController.text = data.roll;
      imageTemporary = data.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z]+([a-zA-Z ]+)*')),
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter student name";
                        }
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Name',
                          label: Text('Name')),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Age';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Age',
                          label: Text('Age')),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _classController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Class';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Class',
                          label: Text('Class')),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _rollController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Roll-No';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Roll-No',
                          label: Text('Roll-No')),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Upload Photo"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            pickCamera();
                            print('camera');
                          },
                          icon: const Icon(Icons.camera),
                          label: Text('Camera'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            pickImage();
                            print('gallery');
                          },
                          icon: const Icon(Icons.photo_album),
                          label: Text('Gallery'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (widget.data == null) {
                            await onAddStudentButtonClicked(context);
                            //Navigator.of(context).pop();
                          }
                        }
                        if (widget.data != null) {
                          await update();
                        }
                        // widget.data == null
                        //     ? onAddStudentButtonClicked(context)
                        //     : update();
                      },
                      icon: const Icon(Icons.add),
                      label:
                          Text(widget.data != null ? "Update" : "ADD STUDENT"),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<void> pickCamera() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.camera);
      if (img == null) {
        return;
      }
      imageTemporary = img.path;

//       setState(){
// this.image = imageTemporary;
//       }

    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  Future<void> pickImage() async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) {
        return;
      }
      imageTemporary = img.path;
//       setState(){
// this.image = imageTemporary;
//       }

    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  Future<void> onAddStudentButtonClicked(BuildContext context) async {
    final _name = _nameController.text.trim();
    final _age = _ageController.text.trim();
    final _class = _classController.text.trim();
    final _roll = _rollController.text.trim();
    final _img = imageTemporary;
    if (_name.isEmpty ||
        _age.isEmpty ||
        _class.isEmpty ||
        _roll.isEmpty ||
        _img.isEmpty) {
      return;
    }
    final _student = StudentModel(
        name: _name, age: _age, clas: _class, roll: _roll, image: _img);
    addStudent(_student);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.greenAccent,
        content: Text("Student added successfully")));
    //Navigator.of(context).push();
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ScreenHome(),
    //   ),
    // );
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (ctx) => ScreenHome()), (route) => false);
    //print(_student);
  }

  Future<void> update() async {
    String name = _nameController.text;
    String age = _ageController.text;
    String clas = _classController.text;
    String roll = _rollController.text;
    String image = imageTemporary;
    editStudent(widget.data.id!, name, age, clas, roll, image);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Student Updated successfully")));

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ScreenHome(),
    //   ),
    // );
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (ctx) => ScreenHome()), (route) => false);
  }
}
