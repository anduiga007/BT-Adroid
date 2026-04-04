import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/chitieu.dart';

class ChiTieuDatabaseHelper {
  static final ChiTieuDatabaseHelper _instance =
  ChiTieuDatabaseHelper._internal();
  static Database? _database;

  factory ChiTieuDatabaseHelper() => _instance;
  ChiTieuDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'chitieu.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chitieus(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            noiDung TEXT NOT NULL,
            soTien REAL NOT NULL,
            ghiChu TEXT,
            ngay TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertChiTieu(ChiTieu ct) async {
    final db = await database;
    return await db.insert('chitieus', ct.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ChiTieu>> getChiTieus() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('chitieus', orderBy: 'id DESC');
    return List.generate(maps.length, (i) => ChiTieu.fromMap(maps[i]));
  }

  Future<int> updateChiTieu(ChiTieu ct) async {
    final db = await database;
    return await db.update(
      'chitieus',
      ct.toMap(),
      where: 'id = ?',
      whereArgs: [ct.id],
    );
  }

  Future<int> deleteChiTieu(int id) async {
    final db = await database;
    return await db.delete(
      'chitieus',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}