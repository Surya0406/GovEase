import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'govease.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT,
        mobile TEXT,
        email TEXT,
        password TEXT
      )
    ''');
  }

  Future<int> registerUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> loginUser(String identifier, String password) async {
    Database db = await database;
    // User can login with either mobile number or email
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: '(mobile = ? OR email = ?) AND password = ?',
      whereArgs: [identifier, identifier, password],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}
