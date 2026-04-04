import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/sanpham.dart';

class SanPhamDatabaseHelper {
  static final SanPhamDatabaseHelper _instance =
  SanPhamDatabaseHelper._internal();
  static Database? _database;

  factory SanPhamDatabaseHelper() => _instance;
  SanPhamDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'sanpham.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sanphams(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            maSP TEXT NOT NULL,
            tenSP TEXT NOT NULL,
            donGia REAL NOT NULL,
            giamGia REAL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> insertSanPham(SanPham sp) async {
    final db = await database;
    return await db.insert('sanphams', sp.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SanPham>> getSanPhams() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sanphams');
    return List.generate(maps.length, (i) => SanPham.fromMap(maps[i]));
  }

  Future<int> updateSanPham(SanPham sp) async {
    final db = await database;
    return await db.update(
      'sanphams',
      sp.toMap(),
      where: 'id = ?',
      whereArgs: [sp.id],
    );
  }

  Future<int> deleteSanPham(int id) async {
    final db = await database;
    return await db.delete(
      'sanphams',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}