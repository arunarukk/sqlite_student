class StudentModel {
  int? id;

  final String name;

  final String age;

  final String clas;

  final String roll;

  final String image;

  StudentModel(
      {required this.name,
      required this.age,
      required this.clas,
      required this.roll,
      this.id,
      required this.image});

  static StudentModel fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final age = map['age'] as String;
    final clas = map['clas'] as String;
    final roll = map['roll'] as String;
    final image = map['image'] as String;

    return StudentModel(
        id: id, name: name, age: age, clas: clas, roll: roll, image: image);
  }
}
