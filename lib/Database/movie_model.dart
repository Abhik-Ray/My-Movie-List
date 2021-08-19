import 'dart:io';

final String tableMovies = 'movies';

class MovieFields{

  static final List<String> values = [
    id, movieName, movieDirector, movieWatchDate, movieRuntime, movieRating, movieReview, poster
  ];

  static final String id = '_id';
  static final String movieName = 'movieName';
  static final String movieDirector = 'movieDirector';
  static final String movieWatchDate = 'movieWatchDate';
  static final String movieRuntime = 'movieRuntime';
  static final String movieRating = 'movieRating';
  static final String movieReview = 'movieReview';
  static final String poster = 'poster';
}

class MovieModel {
  final int? id;
  final String movieName;
  final String movieDirector;
  final DateTime movieWatchDate;
  final int movieRuntime;
  final num movieRating;
  final String movieReview;
  final String poster;

  const MovieModel({
    this.id,
    required this.movieName,
    required this.movieDirector,
    required this.movieWatchDate,
    required this.movieReview,
    required this.movieRating,
    required this.movieRuntime,
    required this.poster
});

  MovieModel copy({
    int? id,
    String? movieName,
    String? movieDirector,
    DateTime? movieWatchDate,
    int? movieRuntime,
    double? movieRating,
    String? movieReview,
    File? poster
}) => MovieModel(
      id: this.id,
      movieName: this.movieName,
      movieDirector: this.movieDirector,
      movieWatchDate: this.movieWatchDate,
      movieReview: this.movieReview,
      movieRating: this.movieRating,
      movieRuntime: this.movieRuntime,
      poster: this.poster
  );

  static MovieModel fromJson(Map<String, Object?> json) => MovieModel(
      id: json[MovieFields.id] as int?,
      movieName: json[MovieFields.movieName] as String,
      movieDirector: json[MovieFields.movieDirector] as String,
      movieWatchDate: DateTime.parse(json[MovieFields.movieWatchDate] as String),
      movieReview: json[MovieFields.movieReview] as String,
      movieRating: json[MovieFields.movieRating] as num,
      movieRuntime: json[MovieFields.movieRuntime] as int,
      poster: json[MovieFields.poster] as String
  );

  Future<Map<String, Object?>> toJson() async => {
    MovieFields.id: id,
    MovieFields.movieName: movieName,
    MovieFields.movieDirector: movieDirector,
    MovieFields.movieRuntime: movieRuntime,
    MovieFields.movieRating: movieRating,
    MovieFields.movieWatchDate: movieWatchDate.toIso8601String(),
    MovieFields.movieReview: movieReview,
    MovieFields.poster: poster
  };
}
