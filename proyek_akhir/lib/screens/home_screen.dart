import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyek_akhir/api/api.dart';
import 'package:proyek_akhir/widgets/movies_slider.dart';
import 'package:proyek_akhir/widgets/trending_slider.dart';
import 'package:proyek_akhir/widgets/bottom_navbar.dart';
import '../models/movie.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  late Future<Map<String, dynamic>> trendingmovies;
  late Future<Map<String, dynamic>> topratedmovies;
  late Future<Map<String, dynamic>> upcomingmovies;
  // inisiasi pengambilan data api

  late TextEditingController _searchController = TextEditingController();
  List<Results> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState(){
    super.initState();
    trendingmovies = ApiDataSource.instance.loadTrending();
    topratedmovies = ApiDataSource.instance.loadTopRated();
    upcomingmovies = ApiDataSource.instance.loadUpcoming();
  } // pengambilan data api

  void _onSearchTextChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    ApiDataSource.instance.searchMovie(value).then((results) {
      final List<dynamic> resultsList = results['results'];
      setState(() {
        _searchResults = resultsList.map((json) => Results.fromJson(json)).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search movies',
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
          onChanged: _onSearchTextChanged,
        )
            : Image.asset(
          'assets/getplix.png',
          fit: BoxFit.cover,
          height: 180,
          filterQuality: FilterQuality.high,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _searchResults.clear();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(selectedIndex: 1),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _isSearching
                ? _buildSearchResults()
                : _buildDefaultContent(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDefaultContent() {
    return [
      Text(
        'Trending Movies',
        style: GoogleFonts.aBeeZee(fontSize: 25),
      ),
      SizedBox(height: 40),
      SizedBox(
        child: FutureBuilder(
          future: trendingmovies,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              return TrendingSlider(data: snapshot.data!);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      SizedBox(height: 40),
      Text(
        'Top rated movies',
        style: GoogleFonts.aBeeZee(fontSize: 25),
      ),
      SizedBox(height: 40),
      SizedBox(
        child: FutureBuilder(
          future: topratedmovies,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              return MoviesSlider(data: snapshot.data!);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      SizedBox(height: 40),
      Text(
        'Upcoming movies',
        style: GoogleFonts.aBeeZee(fontSize: 25),
      ),
      SizedBox(height: 40),
      SizedBox(
        child: FutureBuilder(
          future: upcomingmovies,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              return MoviesSlider(data: snapshot.data!);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    ];
  }

  List<Widget> _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return [
        Center(
          child: Text(
            'No results found!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ];
    }

    return _searchResults.map((movie) {
      return ListTile(
        leading: Image.network(
          '${ApiDataSource.imagePath}${movie.posterPath}',
          fit: BoxFit.cover,
        ),
        title: Text(movie.title ?? 'No title'),
        subtitle: Text(movie.releaseDate ?? 'No release date'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(movie: movie),
            ),
          );
        },
      );
    }).toList();
  }

  Widget _buildErrorSection(){
    return Text("Error");
  }
}

// tampilan homescreen