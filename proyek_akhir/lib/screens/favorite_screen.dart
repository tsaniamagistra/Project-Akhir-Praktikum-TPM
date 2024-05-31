import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyek_akhir/models/movie.dart';
import 'package:proyek_akhir/screens/detail_screen.dart';
import 'package:proyek_akhir/services/user_manager.dart';
import 'package:proyek_akhir/services/session_manager.dart';
import 'package:proyek_akhir/widgets/bottom_navbar.dart';
import 'package:proyek_akhir/api/api.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<int> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final username = await SessionManager.getUsername();
    if (username != null) {
      final favorites = await UserManager.getFavorites(username);
      if (favorites != null) {
        setState(() {
          favoriteMovies = favorites;
        });
      }
    }
  }

  void _refreshFavorites() {
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Movies',
          style: GoogleFonts.aBeeZee(
            fontSize: 25,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: _buildFavoritesGrid(),
      ),
    );
  }

  Widget _buildFavoritesGrid() {
    if (favoriteMovies.isEmpty) {
      return Center(
        child: Text(
          'No favorites yet!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.80,
          ),
          itemCount: favoriteMovies.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildFavoriteItem(favoriteMovies[index]);
          },
        ),
      );
    }
  }

  Widget _buildFavoriteItem(int movieId) {
    return FutureBuilder(
      future: ApiDataSource.instance.loadMovieById(movieId),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          Results result = Results.fromJson(snapshot.data);
          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    movie: result,
                    onRefresh: _refreshFavorites,
                  ),
                ),
              );
              _refreshFavorites();
            },
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                          '${ApiDataSource.imagePath}${result.posterPath}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _removeFavorite(movieId, result.title!);
                            },
                            iconSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${result.title}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }

  Future<void> _removeFavorite(int movieId, String title) async {
    final username = await SessionManager.getUsername();
    if (username != null) {
      final removed = await UserManager.removeFavorite(username, movieId);
      if (removed) {
        setState(() {
          favoriteMovies.remove(movieId);
        });
        if (favoriteMovies.isEmpty) {
          _loadFavorites();
        }
      }

      SnackBar snackBar = SnackBar(
        content: Text("The movie $title has been unfavourited!", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
