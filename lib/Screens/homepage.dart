import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_list/Database/movie_model.dart';
import 'package:my_movie_list/Screens/add_movie.dart';
import 'package:my_movie_list/Tools/google_sign_in.dart';
import 'package:my_movie_list/widgets.dart';
import 'package:my_movie_list/Database/database.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<MovieModel> movieList = [];
  bool isLoading = false;

  movieCards() {
    refreshMovies();
    List<MovieCardWidget> movieCardList = [];
    for (int i = 0; i < movieList.length; i++) {
      movieCardList.add(MovieCardWidget(movie: movieList[i]));
    }
    return movieCardList;
  }

  Future refreshMovies() async {
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
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              maxRadius: 20,
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            Image.asset(
              'assets/images/logo_small.png',
              width: 80,
              height: 40,
            ),
            SizedBox(
              width: 80,
              height: 30,
              child: OutlinedButton(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                },
                style: ButtonStyle(
                  side:
                      MaterialStateProperty.all(BorderSide(color: Colors.blue)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xff0071bc),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Color(0x320071bc),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  child: movieList.length == 0
                      ? Center(child: Text('No Movies yet'))
                      : Expanded(
                        child: ListView(
                          children: [
                              Column(
                                children: movieCards(),
                              ),
                            ],
                        ),
                      )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0071bc),
        foregroundColor: Colors.white,
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
