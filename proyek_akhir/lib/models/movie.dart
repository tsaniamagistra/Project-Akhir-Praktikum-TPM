class Movie {
  final int? page;
  final List<Results>? results;
  final int? totalPages;
  final int? totalResults;

  Movie({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  Movie.fromJson(Map<String, dynamic> json)
      : page = json['page'] as int?,
        results = (json['results'] as List?)?.map((dynamic e) => Results.fromJson(e as Map<String,dynamic>)).toList(),
        totalPages = json['total_pages'] as int?,
        totalResults = json['total_results'] as int?;

  Map<String, dynamic> toJson() => {
    'page' : page,
    'results' : results?.map((e) => e.toJson()).toList(),
    'total_pages' : totalPages,
    'total_results' : totalResults
  };
}

class Results {
  final String? backdropPath;
  final int? id;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final String? mediaType;
  final bool? adult;
  final String? title;
  final String? originalLanguage;
  final List<int>? genreIds;
  final double? popularity;
  final String? releaseDate;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  Results({
    this.backdropPath,
    this.id,
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.mediaType,
    this.adult,
    this.title,
    this.originalLanguage,
    this.genreIds,
    this.popularity,
    this.releaseDate,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  Results.fromJson(Map<String, dynamic> json)
      : backdropPath = json['backdrop_path'] as String?,
        id = json['id'] as int?,
        originalTitle = json['original_title'] as String?,
        overview = json['overview'] as String?,
        posterPath = json['poster_path'] as String?,
        mediaType = json['media_type'] as String?,
        adult = json['adult'] as bool?,
        title = json['title'] as String?,
        originalLanguage = json['original_language'] as String?,
        genreIds = (json['genre_ids'] as List?)?.map((dynamic e) => e as int).toList(),
        popularity = json['popularity'] as double?,
        releaseDate = json['release_date'] as String?,
        video = json['video'] as bool?,
        voteAverage = json['vote_average'] as double?,
        voteCount = json['vote_count'] as int?;

  Map<String, dynamic> toJson() => {
    'backdrop_path' : backdropPath,
    'id' : id,
    'original_title' : originalTitle,
    'overview' : overview,
    'poster_path' : posterPath,
    'media_type' : mediaType,
    'adult' : adult,
    'title' : title,
    'original_language' : originalLanguage,
    'genre_ids' : genreIds,
    'popularity' : popularity,
    'release_date' : releaseDate,
    'video' : video,
    'vote_average' : voteAverage,
    'vote_count' : voteCount
  };
}