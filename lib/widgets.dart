import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_movie_list/Database/movie_model.dart';
import 'package:my_movie_list/Database/database.dart';
import 'package:my_movie_list/Screens/movie_details.dart';
import 'package:provider/provider.dart';

import 'Screens/edit_movie.dart';
import 'Tools/google_sign_in.dart';

class MovieCardWidget extends StatelessWidget {
  final MovieModel movie;

  const MovieCardWidget({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetails(
                  movie: this.movie,
                ),
            ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0x550071bc),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ImageCard(
              height: 120,
              width: 80,
              image: movie.poster,
              noEdit: true,
              border: false,
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.title,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        movie.movieName,
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.movie,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(movie.movieDirector)
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text('${movie.movieRating}/10'),
                      ]),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1.5),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditMovie(
                                movie: this.movie,
                              )));
                    },
                    child: const Icon(Icons.edit),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 1.5),
                  ),
                  child: InkWell(
                    onTap: () async {
                      print(movie.movieName);
                      await MovieDatabase.instance.delete(movie.id);
                    },
                    child: const Icon(Icons.delete),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final double height;
  final double width;
  final String image;
  final bool noEdit;
  final bool border;

  const ImageCard({
    Key? key,
    this.height = 250,
    this.width = 150,
    this.image = '',
    this.noEdit = false,
    this.border = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              border: border ? Border.all(width: 5, color: Colors.grey) : Border.all(width: 0.5, color: Colors.black),
              color: Colors.black,
            ),
            width: this.width,
            height: this.height,
            child: image.length == 0
                ? Image.asset(
                    'assets/images/cinema.jpg',
                    fit: BoxFit.scaleDown,
                  )
                : Image.file(
                    File(this.image),
                    fit: BoxFit.scaleDown,
                  ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            color: Colors.transparent,
            child: Icon(
              Icons.image_outlined,
              color: noEdit ? Colors.transparent : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Container(
          color: Color(0x320071bc),
          child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            Image.asset('assets/images/logo_small.png', width: 100, height: 80,),
            SizedBox(
              width: 60,
              child: OutlinedButton(
                child: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                onPressed: () {
                  final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.login();
                },
              ),
            ),
          SizedBox(height: 10,),
            Text('Sign In to Continue'),
          ],
      ),
        ),
    );
  }
}
