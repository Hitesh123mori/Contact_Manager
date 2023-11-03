class Contact {
  Contact({
    required this.name,
    required this.email,
    required this.number,
    required this.about,
  });
  late  String name;
  late  String email;
  late  String number;
  late  String about;

  Contact.fromJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    number = json['contact'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['email'] = email;
    _data['contact'] = number;
    _data['about'] = about;
    return _data;
  }
}