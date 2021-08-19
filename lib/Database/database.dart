import 'package:my_movie_list/Database/movie_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MovieDatabase{
  static final MovieDatabase instance = MovieDatabase._init();
  static Database? _database;
  MovieDatabase._init();

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 3, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {

    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final stringType = 'TEXT NOT NULL';
    final intType = 'INTEGER NOT NULL';
    final doubleType = 'REAL NOT NULL';
    // final blobType = 'BLOB NOT NULL';

    await db.execute('''
    CREATE TABLE $tableMovies (
    ${MovieFields.id} $idType,
    ${MovieFields.movieName} $stringType,
    ${MovieFields.movieDirector} $stringType,
    ${MovieFields.movieWatchDate} $stringType,
    ${MovieFields.movieRuntime} $intType,
    ${MovieFields.movieRating} $doubleType,
    ${MovieFields.movieReview} $stringType,
    ${MovieFields.poster} $stringType
    ) 
    ''');
  }

  Future<MovieModel> create(MovieModel movie) async{
    final db = await instance.database;
    var json = await movie.toJson();
    final id = await db.insert(tableMovies, json);
    return movie.copy(id: id);
  }

  Future<MovieModel> readMovie(int id) async{
    final db = await instance.database;
    final maps =  await db.query(
      tableMovies,
      columns: MovieFields.values,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );
    if(maps.isNotEmpty){
      return MovieModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<MovieModel>> readAllMovies() async{
    final db = await instance.database;
    final result = await db.query(tableMovies);
    return result.map((json) => MovieModel.fromJson(json)).toList();
  }

  Future<int> update(MovieModel movie) async{
    final db = await instance.database;
    var json = await movie.toJson();
    return db.update(
        tableMovies,
        json,
        where: '${MovieFields.id} = ?',
        whereArgs: [movie.id],
    );
  }

  Future<int> delete(int? id) async{
    final db = await instance.database;
    return await db.delete(
      tableMovies,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }

}