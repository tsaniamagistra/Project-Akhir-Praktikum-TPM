import 'network.dart';

class ApiDataSource{
  static const apiKey = '0a05c3dd86c6b10498cb780cefb12d12'; // api key untuk akses data tmdb
  static const imagePath = 'https://image.tmdb.org/t/p/w500'; // image path untuk akses poster film

  static ApiDataSource instance = ApiDataSource();

  Future<Map<String, dynamic>> loadTrending(){
    return BaseNetwork.get("trending/movie/day?api_key=${apiKey}");
  } // akses data movie trending

  Future<Map<String, dynamic>> loadTopRated(){
    return BaseNetwork.get("movie/top_rated?api_key=${apiKey}");
  } // akses data movie top rated

  Future<Map<String, dynamic>> loadUpcoming(){
    return BaseNetwork.get("movie/upcoming?api_key=${apiKey}");
  } // akses data movie upcoming

  Future<Map<String, dynamic>> loadMovieById(int movieId){
    return BaseNetwork.get("movie/$movieId?api_key=${apiKey}");
  } // akses data movie berdasarkan id

  Future<Map<String, dynamic>> searchMovie(String movieTitle){
    return BaseNetwork.get("search/movie?api_key=${apiKey}&query=$movieTitle");
  } // akses data movie berdasarkan id
}