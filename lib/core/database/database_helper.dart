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

  // Normalize phone number to strip all spaces/dashes/parentheses
  static String normalizePhone(String input) {
    return input.replaceAll(RegExp(r'[^\d+]'), '');
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'govease.db');
    return await openDatabase(
      path,
      version: 2, // Version 2 triggers schema migration
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS users');
        await _onCreate(db, newVersion);
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        mobile TEXT UNIQUE NOT NULL,
        email TEXT,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<int> registerUser(Map<String, dynamic> user) async {
    Database db = await database;
    
    String rawMobile = user['mobile'] ?? '';
    String cleanMobile = normalizePhone(rawMobile);
    
    if (cleanMobile.isEmpty) {
      throw Exception('Please enter a valid mobile number');
    }

    Map<String, dynamic> userMap = {
      'fullName': user['fullName'] ?? '',
      'mobile': cleanMobile,
      'email': (user['email'] ?? '').toString().trim(),
      'password': user['password'] ?? '',
    };

    // Check if mobile number is already registered
    List<Map<String, dynamic>> existing = await db.query(
      'users',
      where: 'mobile = ?',
      whereArgs: [cleanMobile],
    );

    if (existing.isNotEmpty) {
      throw Exception('Mobile number is already registered. Please log in.');
    }

    return await db.insert('users', userMap);
  }

  Future<Map<String, dynamic>?> loginUser(String identifier, String password) async {
    Database db = await database;
    String cleanIdentifier = normalizePhone(identifier);

    // Match normalized mobile, raw mobile, or email
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: '(mobile = ? OR mobile = ? OR email = ?) AND password = ?',
      whereArgs: [cleanIdentifier, identifier, identifier, password],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }
}
