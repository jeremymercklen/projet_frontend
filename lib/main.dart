import 'package:projet_frontend/components.dart';
import 'package:projet_frontend/pages/login_page.dart';
import 'package:projet_frontend/pages/page_anime.dart';
import 'package:projet_frontend/services/anime_api.dart';
import 'package:projet_frontend/services/list_anime_api.dart';
import 'package:projet_frontend/services/login_state.dart';
import 'package:projet_frontend/widgets/drawer.dart';
import 'package:projet_frontend/models/anime.dart';

import 'package:flutter/material.dart';
import 'package:projet_frontend/widgets/search_bar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (loginState) => LoginState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Anime',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer<LoginState>(builder: (context, loginState, child) {
          return loginState.connected
              ? MyHomePage(title: 'Anime')
              : LoginPage();
        }));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  var animeAPI = AnimeAPI();
  final animeRoutes = AnimeListRoutes();
  final userRoutes = UserAccountRoutes();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, String>> _response;
  late Future<List<String>> _genres;
  final ScrollController _scrollController = ScrollController();
  Map<String, List<Anime>> _animesByGenre = {};
  Map<String, bool> _isLoadingMore = {};
  Map<String, int> _currentPage = {};
  final int _itemsPerPage = 10;
  bool _initialLoading = true;
  Map<String, bool> _isRequestInProgress = {};

  @override
  void initState() {
    super.initState();
    _response = widget.userRoutes.refreshToken(context);
    _genres = widget.animeRoutes.getGenresByMostViewed(context);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      List<String> genres = await _genres;
      for (String genre in genres) {
        _animesByGenre[genre] = [];
        _currentPage[genre] = 1;
        _isLoadingMore[genre] = true;
        _isRequestInProgress[genre] = false;
        await _loadMoreAnimes(genre);
      }
      setState(() {
        _initialLoading = false;
      });
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  Future<void> _loadMoreAnimes(String genre) async {
    if (_isRequestInProgress[genre] == true || _isLoadingMore[genre] != true) {
      return;
    }

    _isRequestInProgress[genre] = true;

    try {
      List<Anime> newAnimes = await widget.animeAPI.animes(
          genre,
          context,
          page: _currentPage[genre] ?? 1,
          limit: _itemsPerPage
      );

      if (mounted) {
        setState(() {
          // Update the anime list
          _animesByGenre[genre] = [..._animesByGenre[genre] ?? [], ...newAnimes];

          // Always increment the page counter
          _currentPage[genre] = (_currentPage[genre] ?? 1) + 1;

          // Stop loading if we get fewer items than requested
          _isLoadingMore[genre] = newAnimes.length >= _itemsPerPage;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore[genre] = false;
        });
      }
      print('Error loading more animes: $e');
    } finally {
      _isRequestInProgress[genre] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          MyPadding(
            child: AnimeSearchBar(
              searchAnimes: (query) =>
                  widget.animeAPI.searchAnimes(query, context),
            ),
          ),
          FutureBuilder(
              future: Future.wait([_response, _genres]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Provider.of<LoginState>(context, listen: false).token =
                      (snapshot.data![0] as Map)["token"];
                  List<String> genres = snapshot.data![1] as List<String>;

                  if (_initialLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: genres.length,
                      itemBuilder: (context, index) {
                        String genre = genres[index];
                        List<Anime> animes = _animesByGenre[genre] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyPadding(child: MyText(genre)),
                            SizedBox(
                              height: 220,
                              child: NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (scrollInfo.metrics.pixels >=
                                      scrollInfo.metrics.maxScrollExtent -
                                          200) {
                                    if (_isLoadingMore[genre] == true) {
                                      _loadMoreAnimes(genre);
                                    }
                                  }
                                  return true;
                                },
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: animes.length +
                                      (_isLoadingMore[genre] == true ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == animes.length) {
                                      if (_isLoadingMore[genre] == true) {
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => PageAnime(
                                                    anime: animes[index])));
                                      },
                                      child: Card(
                                        child: Column(
                                          children: [
                                            MyPadding(
                                              child: Image.network(
                                                animes[index].info.picture,
                                                height: 150,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                },
                                              ),
                                            ),
                                            MyPadding(
                                                child: MyText(
                                                    animes[index].info.name)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  );
                }
                if (snapshot.hasError) {
                  Future.delayed(Duration.zero, () {
                    Provider.of<LoginState>(context, listen: false)
                        .disconnect();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  });
                }
                return const Center(child: CircularProgressIndicator());
              }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
