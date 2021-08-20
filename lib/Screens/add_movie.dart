import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_movie_list/Database/database.dart';
import 'package:my_movie_list/Database/movie_model.dart';
import 'package:my_movie_list/widgets.dart';
import 'package:url_launcher/url_launcher.dart';


class AddMovie extends StatefulWidget {
  const AddMovie({Key? key}) : super(key: key);

  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  DateTime selectedDate = new DateTime.now();
  num rate = 0.0;
  File? _image;
  final nameController = TextEditingController();
  final directorController = TextEditingController();
  final runtimeController = TextEditingController();
  final reviewController = TextEditingController();
  String _url = '';

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  launchURL() async{
      nameController.text.isEmpty ? _url='https://www.imdb.com/' : _url = 'https://www.imdb.com/find?q=${nameController.text}';
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  Future<MovieModel> addMovie(String name, String director, DateTime watchDate, int runtime, num rating, String review, File? file) async {
    final movie = MovieModel(
        movieName: name,
        movieDirector: director,
        movieWatchDate: watchDate,
        movieReview: review,
        movieRating: rating,
        movieRuntime: runtime,
        poster: file == null ? ' ' : file.path
    );
    await MovieDatabase.instance.create(movie);
    return movie;
  }

  showWarning(String text){
    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.lightBlue,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  fieldsAreEmpty(){
    if(nameController.text.isEmpty){
      showWarning('Please provide a title');
      return true;
    }
    else if(directorController.text.isEmpty){
      showWarning('Please provide a director name');
      return true;
    }
    else if(selectedDate.toIso8601String().isEmpty){
      showWarning('Please select a date');
      return true;
    }
    else if(reviewController.text.isEmpty){
      showWarning('Please provide a short review');
      return true;
    }
    else if(runtimeController.text.isEmpty){
      showWarning('Please provide a runtime. 90 is the most common runtime!');
      return true;
    }
    else if(int.tryParse(runtimeController.text)==null){
      showWarning('Runtime must be in an integer');
      return true;
    }
    else{
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    directorController.dispose();
    reviewController.dispose();
    runtimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
        backgroundColor: Color(0xff0071bc),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Color(0x550071bc),
          padding: EdgeInsets.only(left: 15, top: 22, right: 15),
          child: Stack(children: [
            ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title TextInput
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 50,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Movie Title',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //IMDB button
                          Material(
                            color: Color(0x00ADD8E6),
                            child: InkWell(
                              onTap: () => launchURL(),
                              child: Card(
                                color: Color(0xff0071bc),
                                child: Container(
                                  child: Text('Search in \n  IMDB'),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                ),
                              ),
                            ),
                          ),
                          // Thumbnail ImageInput
                          Material(
                            child: InkWell(
                              onTap: () => getImage(),
                              child: _image == null
                                  ? ImageCard()
                                  : ImageCard(image: _image!.path),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: TextFormField(
                        controller: directorController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 50,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Director',
                            suffixIcon: Icon(Icons.movie_creation_outlined)),
                      ),
                    ),
                    // Date Input
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: DateTimeFormField(
                        decoration: const InputDecoration(
                            hintText: 'Watch Date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today)),
                        mode: DateTimeFieldPickerMode.date,
                        onDateSelected: (DateTime value) {
                          setState(() {
                            selectedDate = value;
                          });
                        },
                      ),
                    ),
                    // Runtime Input
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: TextFormField(
                          controller: runtimeController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Runtime',
                            suffixText: 'minutes',
                            suffixIcon: Icon(Icons.access_time),
                          ),
                        ),
                      ),
                    ),
                    // Rating:
                    Container(
                      child: Text('Rating:'),
                    ),
                    // Rating Bar
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: RatingBar.builder(
                        initialRating: 3.2,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 10,
                        itemSize: 34.0,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            rate = rating;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: IntrinsicHeight(
                        child: TextFormField(
                          controller: reviewController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 500,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Your Review',
                              suffixIcon: Icon(Icons.edit)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: FloatingActionButton(
                      heroTag: 'cancel',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: FloatingActionButton(
                      heroTag: 'add',
                      onPressed: () async {
                        if(!fieldsAreEmpty()) {
                          MovieModel obj = await addMovie(
                              nameController.text,
                              directorController.text,
                              selectedDate,
                              int.parse(runtimeController.text),
                              rate,
                              reviewController.text,
                              _image
                          );
                          Navigator.pop(
                            context,
                            obj,
                          );
                        }
                      },
                      child: Icon(Icons.check),
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
