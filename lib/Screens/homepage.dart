import 'package:flutter/material.dart';
import 'package:my_movie_list/Database/movie_model.dart';
import 'package:my_movie_list/Screens/add_movie.dart';
import 'package:my_movie_list/widgets.dart';
import 'package:my_movie_list/Database/database.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<MovieModel> movieList = [];
  bool isLoading = false;

  movieCards(){
    refreshMovies();
    List<MovieCardWidget> movieCardList = [];
    for(int i = 0; i<movieList.length; i++){
      movieCardList.add(MovieCardWidget(movie: movieList[i]));
    }
    return movieCardList;
  }

  Future refreshMovies() async{
    setState(() => isLoading = true);

    this.movieList = await MovieDatabase.instance.readAllMovies();

    setState(() => isLoading = false);
  }

  @override
  initState() {
    super.initState();
    refreshMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xaaADD8E6),
      body: SafeArea(
        child: Container(
          color: Color(0xaaADD8E6),
          width: double.infinity,
          padding: EdgeInsets.all(24.0),
          margin: EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:130,
                width: 330,
                child: Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.symmetric(vertical: 25.0),
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
              Container(
                child: movieList.length == 0 ? Text('No Movies yet') : Column(children: movieCards(),)
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddMovie(),
            ),
          );
          refreshMovies();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
