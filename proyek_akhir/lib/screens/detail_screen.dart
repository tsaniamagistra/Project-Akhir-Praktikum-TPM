import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyek_akhir/api/api.dart';
import 'package:proyek_akhir/colors.dart';
import 'package:proyek_akhir/models/movie.dart';
import 'package:proyek_akhir/widgets/back_button.dart';
import 'package:proyek_akhir/services/user_manager.dart';
import 'package:proyek_akhir/services/session_manager.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.movie, this.onRefresh}) : super(key: key);

  final Results movie;
  final VoidCallback? onRefresh;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIsFavorite();
  }

  Future<void> _checkIsFavorite() async {
    final isLoggedIn = await SessionManager.isLoggedIn();
    if (isLoggedIn) {
      final username = await SessionManager.getUsername();
      final isFavorite = await UserManager.isFavorite(username!, widget.movie.id!);
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavoriteStatus() async {
    final isLoggedIn = await SessionManager.isLoggedIn();
    if (isLoggedIn) {
      String text = "";
      final username = await SessionManager.getUsername();
      if (_isFavorite) {
        text = "The movie ${widget.movie.title} has been unfavourited!";
        await UserManager.removeFavorite(username!, widget.movie.id!);
      } else {
        text = "Successfully added to favourite!";
        await UserManager.addFavorite(username!, widget.movie.id!);
      }

      setState(() {
        _isFavorite = !_isFavorite;
      });

      SnackBar snackBar = SnackBar(
        content: Text(text, style: TextStyle(color: Colors.white)),
        backgroundColor: _isFavorite ? Colors.green : Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      if (widget.onRefresh != null) {
        widget.onRefresh!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: const BackBtn(),
            backgroundColor: Colours.scaffoldBgColor,
            expandedHeight: 500,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.movie.title}',
                style: GoogleFonts.belleza(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.network(
                  '${ApiDataSource.imagePath}${widget.movie.backdropPath}',
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overview',
                        style: GoogleFonts.openSans(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleFavoriteStatus,
                        icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                        color: _isFavorite ? Colors.red : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${widget.movie.overview}',
                    style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Release date: ',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${widget.movie.releaseDate}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Rating ',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(
                                '${widget.movie.voteAverage!.toStringAsFixed(1)}/10',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}