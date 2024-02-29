class Student {
  int? id;
  String? name;
  String? clas;
  String? age;
  String? Roll;
  String? selectedImage;
  //String? address;
  studentMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['name'] = name!;
    mapping['clas'] = clas!;
    mapping['age'] = age!;
    mapping['Roll'] = Roll!;
    // mapping['address'] = address!;
    mapping['selectedImage'] = selectedImage!;
    return mapping;
  }
}
