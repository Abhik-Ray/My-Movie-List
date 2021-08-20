import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_movie_list/Database/movie_model.dart';

import '../widgets.dart';

class MovieDetails extends StatelessWidget {
  final MovieModel movie;

  const MovieDetails({Key? key, required this.movie}) : super(key: key);

  customTextField(String label, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.7)),
            ),
            children: <TextSpan>[
              TextSpan(
                text: label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: text),
            ]),
      ),
    );
  }

  String getDate(DateTime date) {
    String dateString = '';
    dateString += '${date.day}';
    if (dateString == '11' || dateString == '12') {
      dateString += 'th ';
    } else if (dateString.endsWith('1')) {
      dateString += 'st ';
    } else if (dateString.endsWith('2')) {
      dateString += 'nd ';
    } else if (dateString.endsWith('3')) {
      dateString += 'rd ';
    } else {
      dateString += 'th ';
    }

    if (date.month == 1) {
      dateString += 'January';
    } else if (date.month == 2) {
      dateString += 'February';
    } else if (date.month == 3) {
      dateString += 'March';
    } else if (date.month == 4) {
      dateString += 'April';
    } else if (date.month == 5) {
      dateString += 'May';
    } else if (date.month == 6) {
      dateString += 'June';
    } else if (date.month == 7) {
      dateString += 'July';
    } else if (date.month == 8) {
      dateString += 'August';
    } else if (date.month == 9) {
      dateString += 'September';
    } else if (date.month == 10) {
      dateString += 'October';
    } else if (date.month == 11) {
      dateString += 'November';
    } else if (date.month == 12) {
      dateString += 'December';
    }

    dateString += ' ${date.year}';
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(movie.poster),
              fit: BoxFit.cover,
            ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0x5f0071bc),
                      border: Border.all(color: Color(0xff0071bc), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  movie.movieName,
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.7)),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: ImageCard(
                                image: movie.poster,
                                noEdit: true,
                              ),
                            ),
                            customTextField("Director: ", movie.movieDirector),
                            customTextField(
                                "Runtime: ", "${movie.movieRuntime} minutes"),
                            customTextField("You watched this movie at ",
                                "${getDate(movie.movieWatchDate)}"),
                            customTextField(
                                "Your Review: ", "${movie.movieReview}"),
                            customTextField("You rated this movie a ",
                                "${movie.movieRating} out of 10"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
