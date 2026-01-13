import 'package:face_recognition_and_detection/core/services/model/face_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FaceDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'faces.db');

    return openDatabase(
      path,
      version: 2, // version 2 for imagePaths
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE faces(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            embedding TEXT,
            imagePaths TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // old database upgrade
          await db.execute('ALTER TABLE faces ADD COLUMN imagePaths TEXT');
        }
      },
    );
  }

  static Future<void> insertFace(FaceModel face) async {
    final db = await database;
    await db.insert('faces', face.toMap());
  }

  static Future<void> deleteFace(int id) async {
    final db = await database;
    await db.delete('faces', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<FaceModel>> getAllFaces() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('faces', orderBy: 'id DESC');

    return maps.map((e) => FaceModel.fromMap(e)).toList();
  }
}
