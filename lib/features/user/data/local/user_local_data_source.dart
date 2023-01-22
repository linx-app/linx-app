import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/model/user_dto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final userLocalDataSourceProvider = Provider((ref) => UserLocalDataSource());

class UserLocalDataSource {
  static const _dbName = "users_db";
  static const _tableName = "users_table";
  static const _dbVersion = 1;
  static const _userId = "id";
  static const _name = "name";
  static const _email = "email";
  static const _type = "type";
  static const _location = "location";
  static const _phoneNumber = "phone_number";
  static const _biography = "biography";
  static const _interests = "interests";
  static const _descriptors = "descriptors";
  static const _packages = "packages";
  static const _profileImages = "profile_images";
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<void> insertUser(final UserDTO user) async {
    final db = await database;
    await db.insert(
        _tableName,
        _toMap(user),
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteUser(final String uid) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [uid],
    );
  }

  Future<UserDTO?> fetchUser(final String uid) async {
    final db = await database;
    var user = await db.query(_tableName, where: "id = ?", whereArgs: [uid]);

    if (user.isEmpty) {
      return null;
    } else {
      return _fromMap(uid, user.first);
    }
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, _) {
        db.execute("""
          CREATE TABLE $_tableName(
            $_userId TEXT PRIMARY KEY NOT NULL,
            $_name TEXT,
            $_type TEXT,
            $_location TEXT,
            $_phoneNumber TEXT,
            $_biography TEXT,
            $_interests TEXT,
            $_descriptors TEXT,
            $_packages TEXT,
            $_profileImages TEXT
          )
        """);
      }
    );
  }

  Map<String, dynamic> _toMap(UserDTO user) {
    return {
      _userId: user.uid,
      _name: user.displayName,
      _email: user.email,
      _location: user.location,
      _phoneNumber: user.phoneNumber,
      _biography: user.biography,
      _interests: user.interests.join("|"),
      _descriptors: user.descriptors.join("|"),
      _type: user.type,
      _packages: user.packages.join("|"),
      _profileImages: user.profileImageUrls.join("|")
    };
  }

  UserDTO _fromMap(String uid, Map<String, dynamic> user) {
    return UserDTO(
      uid: uid,
      displayName: user[_name],
      email: user[_email],
      location: user[_location],
      phoneNumber: user[_phoneNumber],
      biography: user[_biography],
      interests: (user[_interests] as String).split("|"),
      descriptors: (user[_descriptors] as String).split("|"),
      type: user[_type],
      packages: (user[_packages] as String).split("|"),
      profileImageUrls: (user[_profileImages] as String).split("|")
    );
  }
}