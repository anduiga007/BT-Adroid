import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        dateOfBirth TEXT NOT NULL,
        country TEXT NOT NULL,
        avatarPath TEXT
      )
    ''');

    // Thêm dữ liệu mẫu
    await db.insert('users', {
      'name': 'Melissa Peters',
      'email': 'melpeters@gmail.com',
      'password': '••••••••••••',
      'dateOfBirth': '23/05/1995',
      'country': 'Nigeria',
      'avatarPath': null,
    });
    await db.insert('users', {
      'name': 'John Smith',
      'email': 'johnsmith@gmail.com',
      'password': '••••••••',
      'dateOfBirth': '10/01/1990',
      'country': 'USA',
      'avatarPath': null,
    });
    await db.insert('users', {
      'name': 'Nguyen Van A',
      'email': 'nguyenvana@gmail.com',
      'password': '••••••••',
      'dateOfBirth': '15/08/2000',
      'country': 'Vietnam',
      'avatarPath': null,
    });
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query('users');
    return maps.map((m) => User.fromMap(m)).toList();
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
