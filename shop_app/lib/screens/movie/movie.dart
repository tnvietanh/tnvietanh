import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/drawer_menu.dart';
import '/models/movie_model.dart';
import '/provider/list_movie.dart';
import '/screens/movie/movie_overview.dart';
import '/widgets/loading.dart';

class MoviesPage extends StatefulWidget {
  static const routeName = '/movies_page';
  const MoviesPage({Key? key}) : super(key: key);

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late Future<MovieModel> movie;

  @override
  void didChangeDependencies() {
    movie = Provider.of<Movies>(context, listen: false).fetchMovie();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: FutureBuilder<MovieModel>(
        future: movie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final results = snapshot.data!.results;
            return GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 2 / 3,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridTile(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieOverview(
                              movie: results[index],
                            ),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${results[index].posterPath}',
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: ColorLoader2(
                                color1: Colors.redAccent,
                                color2: Colors.green,
                                color3: Colors.amber),
                          ),
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    footer: GridTileBar(
                      backgroundColor: Colors.black87,
                      title: Text(
                        results[index].originalTitle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
              child: ColorLoader2(
                  color1: Colors.redAccent,
                  color2: Colors.green,
                  color3: Colors.amber));
        },
      ),
    );
  }
}
