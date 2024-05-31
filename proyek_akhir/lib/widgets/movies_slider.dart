import 'package:flutter/material.dart';
import 'package:proyek_akhir/api/api.dart';
import 'package:proyek_akhir/models/movie.dart';
import 'package:proyek_akhir/screens/detail_screen.dart';

class MoviesSlider extends StatelessWidget {
  const MoviesSlider({
    super.key, required this.data,
  });

  final Map<String, dynamic> data; // deklarasi data

  @override
  Widget build(BuildContext context) {
    Movie result = Movie.fromJson(data); // konversi data json ke objek Movie
    List<Results> results = result.results ?? []; // ekstrak daftar result

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: result.results!.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => DetailScreen(movie: results[index])
                )
                );
              },
              child: ClipRRect( // untuk border container
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 200,
                  width: 150,
                  child: Image.network(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    '${ApiDataSource.imagePath}${results[index].posterPath}',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// untuk slider trending