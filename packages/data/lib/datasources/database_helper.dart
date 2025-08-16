import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:readian_domain/domain.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _usersTable = 'users';
  static const String _postsTable = 'posts';
  static const String _tagsTable = 'tags';
  static const String _subscriptionsTable = 'subscriptions';
  static const String _savedPostsTable = 'saved_posts';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConfig.databaseName);

    return await openDatabase(
      path,
      version: AppConfig.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE $_usersTable (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        username TEXT NOT NULL,
        full_name TEXT,
        avatar_url TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Posts table
    await db.execute('''
      CREATE TABLE $_postsTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT,
        author_id TEXT NOT NULL,
        author_name TEXT NOT NULL,
        author_avatar TEXT,
        image_url TEXT,
        like_count INTEGER DEFAULT 0,
        user_like_status INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_saved INTEGER DEFAULT 0
      )
    ''');

    // Tags table
    await db.execute('''
      CREATE TABLE $_tagsTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL UNIQUE,
        description TEXT,
        post_count INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL
      )
    ''');

    // Subscriptions table
    await db.execute('''
      CREATE TABLE $_subscriptionsTable (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        tag_id TEXT NOT NULL,
        tag_name TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (tag_id) REFERENCES $_tagsTable (id)
      )
    ''');

    // Saved posts table
    await db.execute('''
      CREATE TABLE $_savedPostsTable (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        post_id TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (post_id) REFERENCES $_postsTable (id)
      )
    ''');

    // Create indexes
    await db.execute(
      'CREATE INDEX idx_posts_created_at ON $_postsTable (created_at)',
    );
    await db.execute(
      'CREATE INDEX idx_subscriptions_user_id ON $_subscriptionsTable (user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_saved_posts_user_id ON $_savedPostsTable (user_id)',
    );
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Add migration logic for version 2
    }
  }

  // Generic CRUD operations
  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  static Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  static Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  // Table name getters
  static String get usersTable => _usersTable;
  static String get postsTable => _postsTable;
  static String get tagsTable => _tagsTable;
  static String get subscriptionsTable => _subscriptionsTable;
  static String get savedPostsTable => _savedPostsTable;
}
