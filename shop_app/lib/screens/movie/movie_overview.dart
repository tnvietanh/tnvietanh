import 'package:flutter/material.dart';
import '/models/movie_model.dart';

class MovieOverview extends StatelessWidget {
  static const routeName = '/movie_overview';
  const MovieOverview({Key? key, required this.movie}) : super(key: key);
  final Result movie;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.dstATop),
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${movie.backdropPath}'),
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              height: 400,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromRGBO(3, 37, 65, 0.5),
                          child: Text(
                            ('${(movie.voteAverage * 10).toStringAsFixed(0)}%')
                                .toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 8),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromRGBO(3, 37, 65, 0.5),
                          child: IconButton(
                            icon: const Icon(
                              Icons.list,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 8),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromRGBO(3, 37, 65, 0.5),
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 8),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromRGBO(3, 37, 65, 0.5),
                          child: IconButton(
                            icon: const Icon(
                              Icons.bookmark,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 8),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromRGBO(3, 37, 65, 0.5),
                          child: IconButton(
                            icon: const Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 25,
              left: 5,
              child: IconButton(
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            const SizedBox(height: 20),
            Positioned(
              top: 400,
              height: deviceSize.height - 420,
              width: deviceSize.width,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.originalTitle,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                        ),
                      ),
                      Text(
                        '${movie.releaseDate} (US)',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Overview',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.overview,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
