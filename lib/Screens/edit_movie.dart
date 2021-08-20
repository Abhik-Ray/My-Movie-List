import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_movie_list/Database/database.dart';
import 'package:my_movie_list/Database/movie_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets.dart';
class EditMovie extends StatefulWidget {
  final MovieModel movie;
  const EditMovie({Key? key, required this.movie}) : super(key: key);

  @override
  _EditMovieState createState() => _EditMovieState();
}

class _EditMovieState extends State<EditMovie> {

  DateTime selectedDate = new DateTime.now();
  num rate = 0.0;
  late String _image;
  late var nameController;
  late var directorController;
  late var runtimeController;
  late var reviewController;
  String _url = '';


  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image!.path;
    });
  }

  launchURL() async{
    nameController.text.isEmpty ? _url='https://www.imdb.com/' : _url = 'https://www.imdb.com/find?q=${nameController.text}';
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  showWarning(String text){
    final snackBar = SnackBar(content: Text(text), backgroundColor: Color(0xff0071bc),);
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

  editMovie(int? iD, String name, String director, DateTime watchDate, int runtime, num rating, String review, String file) async{
    final movie = MovieModel(
        id: iD,
        movieName: name,
        movieDirector: director,
        movieWatchDate: watchDate,
        movieReview: review,
        movieRating: rating,
        movieRuntime: runtime,
        poster: file
    );
    await MovieDatabase.instance.update(movie);
  }

  @override
  void initState() {
    rate = widget.movie.movieRating;
    selectedDate = widget.movie.movieWatchDate;
    _image = widget.movie.poster;
    nameController = TextEditingController(text: widget.movie.movieName);
    directorController = TextEditingController(text: widget.movie.movieDirector);
    runtimeController = TextEditingController(text: widget.movie.movieRuntime.toString());
    reviewController = TextEditingController(text: widget.movie.movieReview);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit'),
        backgroundColor: Color(0xff0071bc),
      ),
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
                            color: Color(0x550071bc),
                            child: InkWell(
                              onTap: () => launchURL(),
                              child: Card(
                                color: Color(0xff0071bc),
                                child: Container(
                                  child: Text('Search in \n    IMDB'),
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
                              child: ImageCard(image: _image),
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
                      onPressed: () {
                        if(!fieldsAreEmpty()) {
                          editMovie(
                              widget.movie.id,
                              nameController.text,
                              directorController.text,
                              selectedDate,
                              int.parse(runtimeController.text),
                              rate,
                              reviewController.text,
                              _image
                          );
                          Navigator.pop(context);
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
