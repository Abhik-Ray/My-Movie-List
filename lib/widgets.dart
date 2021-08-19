import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_list/Database/movie_model.dart';
import 'package:my_movie_list/Database/database.dart';

import 'Screens/edit_movie.dart';

class MovieCardWidget extends StatelessWidget {
  final MovieModel movie;
  const MovieCardWidget({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueAccent,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ImageCard(
            height: 120,
            width: 80,
            image: movie.poster,
            noEdit: true,
          ),
          const SizedBox(
            width: 0,
            height: 80,
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(
                  movie.movieName,
                ),
                  Text(movie.movieDirector),
                  Text('${movie.movieRating}/10')
              ]
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditMovie(movie: this.movie,)
                    )
                );
              },
              child: Container(
                height: 130,
                color: Colors.green,
                child: const Icon(Icons.edit),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () async {
                print(movie.movieName);
                await MovieDatabase.instance.delete(movie.id);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: Colors.red,
                ),
                height: 130,
                child: const Icon(Icons.delete),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final double height;
  final double width;
  final String image;
  final bool noEdit;

  const ImageCard({
    Key? key,
    this.height = 250,
    this.width = 150,
    this.image = '',
    this.noEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.grey
                ),
                color: Colors.black,
              ),
              width: this.width,
              height: this.height,
              child: image.length == 0 ? Image.asset('assets/images/cinema.jpg', fit: BoxFit.scaleDown,) : Image.file(File(this.image), fit: BoxFit.scaleDown,),
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
