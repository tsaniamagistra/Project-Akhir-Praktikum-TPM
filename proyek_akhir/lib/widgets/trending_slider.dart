import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:proyek_akhir/api/api.dart';
import 'package:proyek_akhir/models/movie.dart';
import 'package:proyek_akhir/screens/detail_screen.dart';

class TrendingSlider extends StatelessWidget {
  const TrendingSlider({
    super.key, required this.data,
  });

  final Map<String, dynamic> data; // deklarasi data

  @override
  Widget build(BuildContext context) {
    Movie resultTrending = Movie.fromJson(data); // konversi data json ke objek Movie
    List<Results> results = resultTrending.results ?? []; // ekstrak daftar result

    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: resultTrending.results!.length,
        options: CarouselOptions( // untuk autoplay slider
          height: 300,
          autoPlay: true,
          viewportFraction: 0.25,
          enlargeCenterPage: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(seconds: 1),
        ),
        itemBuilder: (context, itemIndex, PageViewIndex){
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context, MaterialPageRoute(
                    builder: (context) => DetailScreen(movie: results[itemIndex])
                )
              );
            },
            child: ClipRRect( // untuk border container
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 300,
                width: 200,
                child: Image.network(
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                  '${ApiDataSource.imagePath}${results[itemIndex].posterPath}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// untuk slider umum