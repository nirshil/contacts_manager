import 'dart:typed_data';

class ContactModel {
  int? id;
  String name;
  String phoneNumber;
  String? email;
  String? address;
  String? tags;
  Uint8List? image;

  ContactModel(
      {required this.name,
      this.id,
      required this.phoneNumber,
      this.email,
      this.address,
      this.tags,
      this.image});

  Map<String, Object?> tomap() {
    return {
      'name': name,
      'phone': phoneNumber,
      'email': email,
      'address': address,
      'tags': tags,
      'image': image
    };
  }

  @override
  String toString() {
    return '{name: $name, phoneNumber: $phoneNumber, email: $email, address: $address,id:$id tags: $tags}';
  }
}
