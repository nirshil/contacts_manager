import 'package:contacts_manager/modal/contactModel.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbDatabase {
  static Database? _database;

  Future<void> initDatabase() async {
    try {
      _database =
          await openDatabase(join(await getDatabasesPath(), 'contact_list'),
              onCreate: (db, version) {
        return db.execute(
            '  CREATE TABLE contacts ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, email TEXT, address TEXT, tags TEXT, image BLOB)');
      }, version: 1);
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> insertData(ContactModel contacts) async {
    await _database!.insert('contacts', contacts.tomap());
  }

  Future<List<ContactModel>> contact() async {
    // Get a reference to the database.
    final db = await _database;

    // Query the table for all the dogs.
    final List<Map<String, Object?>> contactMaps = await db!.query('contacts');

    // Convert the list of each dog's fields into a list of `Dog` objects.
    return [
      for (final {
            'id': id as int,
            'name': name as String,
            'phone': phone as String,
            'email': email as String,
            'address': address as String,
            'tags': tags as String,
            'image': image as Uint8List?
          } in contactMaps)
        ContactModel(
            name: name,
            id: id,
            phoneNumber: phone,
            email: email,
            address: address,
            tags: tags,
            image: image),
    ];
  }

  Future<void> deleteContact(int id) async {
    // Get a reference to the database.
    final db = await _database;

    // Remove the Dog from the database.
    await db!.delete(
      'contacts',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void> updateContact(ContactModel contact) async {
    // Get a reference to the database.
    final db = await _database;

    // Update the given Dog.
    await db!.update(
      'contacts',
      contact.tomap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [contact.id],
    );
  }
}
