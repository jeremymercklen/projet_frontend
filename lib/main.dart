import 'package:projet_frontend/components.dart';
import 'package:projet_frontend/consts.dart';
import 'package:projet_frontend/pages/login_page.dart';
import 'package:projet_frontend/pages/page_anime.dart';
import 'package:projet_frontend/services/anime_api.dart';
import 'package:projet_frontend/services/list_anime_api.dart';
import 'package:projet_frontend/services/login_state.dart';
import 'package:projet_frontend/widgets/drawer.dart';
import 'package:projet_frontend/models/list_animes.dart';
import 'package:projet_frontend/models/anime.dart';

import 'package:flutter/material.dart';
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
  final ScrollController _controllerFirstGenre = ScrollController();
  final ScrollController _controllerSecondGenre = ScrollController();
  final ScrollController _controllerThirdGenre = ScrollController();
  final ScrollController _controllerFourthGenre = ScrollController();
  bool _isLoadingFirstGenre = false;
  bool _isLoadingSecondGenre = false;
  bool _isLoadingThirdGenre = false;
  bool _isLoadingFourthGenre = false;
  late Future<Map<String, String>> _response;
  late Future<List<Anime>> _firstGenre;
  late Future<List<Anime>> _secondGenre;
  late Future<List<Anime>> _thirdGenre;
  late Future<List<Anime>> _fourthGenre;
  late List<Anime> firstGenre;
  late List<Anime> secondGenre;
  late List<Anime> thirdGenre;
  late List<Anime> fourthGenre;
  List<Anime> _firstGenreShorten = [];
  List<Anime> _secondGenreShorten = [];
  List<Anime> _thirdGenreShorten = [];
  List<Anime> _fourthGenreShorten = [];

  @override
  void initState() {
    _controllerFirstGenre.addListener(_onScrollFirstGenre);
    _controllerSecondGenre.addListener(_onScrollSecondGenre);
    _controllerThirdGenre.addListener(_onScrollThirdGenre);
    _controllerFourthGenre.addListener(_onScrollFourthGenre);
    super.initState();
  }

  _onScrollFirstGenre() {
    if (_controllerFirstGenre.offset >=
            _controllerFirstGenre.position.maxScrollExtent &&
        !_controllerFirstGenre.position.outOfRange) {
      setState(() {
        _isLoadingFirstGenre = true;
      });
      _fetchData(_firstGenreShorten, firstGenre, _isLoadingFirstGenre);
    }
  }

  _onScrollSecondGenre() {
    if (_controllerSecondGenre.offset >=
            _controllerSecondGenre.position.maxScrollExtent &&
        !_controllerSecondGenre.position.outOfRange) {
      setState(() {
        _isLoadingSecondGenre = true;
      });
      _fetchData(_secondGenreShorten, secondGenre, _isLoadingSecondGenre);
    }
  }

  _onScrollThirdGenre() {
    if (_controllerThirdGenre.offset >=
            _controllerThirdGenre.position.maxScrollExtent &&
        !_controllerThirdGenre.position.outOfRange) {
      setState(() {
        _isLoadingThirdGenre = true;
      });
      _fetchData(_thirdGenreShorten, thirdGenre, _isLoadingThirdGenre);
    }
  }

  _onScrollFourthGenre() {
    if (_controllerFourthGenre.offset >=
            _controllerFourthGenre.position.maxScrollExtent &&
        !_controllerFourthGenre.position.outOfRange) {
      setState(() {
        _isLoadingFourthGenre = true;
      });
      _fetchData(_fourthGenreShorten, fourthGenre, _isLoadingFourthGenre);
    }
  }

  _fetchData(genreListShorten, genreList, isLoading) {
    int lastIndex = genreListShorten.length;
    setState(() {
      for (int i = lastIndex; i < lastIndex + 5; i++) {
        if (genreList.length > i) {
          genreListShorten.add(genreList[i]);
        }
      }
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _controllerFirstGenre.dispose();
    _controllerSecondGenre.dispose();
    _controllerThirdGenre.dispose();
    _controllerFourthGenre.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _response = widget.userRoutes.refreshToken(context);
    _firstGenre = widget.animeAPI.animes('Shounen', context);
    _secondGenre = widget.animeAPI.animes('Shoujo', context);
    _thirdGenre = widget.animeAPI.animes('Seinen', context);
    _fourthGenre = widget.animeAPI.animes('Josei', context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        drawer: const MyDrawer(),
        body: FutureBuilder(
            future: Future.wait([
              _response,
              _firstGenre,
              _secondGenre,
              _thirdGenre,
              _fourthGenre
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Provider.of<LoginState>(context, listen: false).token =
                    (snapshot.data![0] as Map)["token"];
                firstGenre = snapshot.data![1] as List<Anime>;
                secondGenre = snapshot.data![2] as List<Anime>;
                thirdGenre = snapshot.data![3] as List<Anime>;
                fourthGenre = snapshot.data![4] as List<Anime>;

                if (_firstGenreShorten.length == 0) {
                  var lastIndex = 0;
                  for (int i = lastIndex; i < lastIndex + 5; i++) {
                    if (firstGenre.length >= i) {
                      _firstGenreShorten.add(firstGenre[i]);
                    }
                  }
                }
                if (_secondGenreShorten.length == 0) {
                  var lastIndex = 0;
                  for (int i = lastIndex; i < lastIndex + 5; i++) {
                    if (secondGenre.length >= i) {
                      _secondGenreShorten.add(secondGenre[i]);
                    }
                  }
                }
                if (_thirdGenreShorten.length == 0) {
                  var lastIndex = 0;
                  for (int i = lastIndex; i < lastIndex + 5; i++) {
                    if (thirdGenre.length >= i) {
                      _thirdGenreShorten.add(thirdGenre[i]);
                    }
                  }
                }
                if (_fourthGenreShorten.length == 0) {
                  var lastIndex = 0;
                  for (int i = lastIndex; i < lastIndex + 5; i++) {
                    if (fourthGenre.length >= i) {
                      _fourthGenreShorten.add(fourthGenre[i]);
                    }
                  }
                }

                return ListView.builder(
                    itemCount: 1,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => Column(children: [
                          /*MyPadding(
                              child: SearchAnchor(builder:
                                  (BuildContext context,
                                      SearchController controller) {
                            return SearchBar(
                                controller: controller,
                                padding:
                                    const MaterialStatePropertyAll<EdgeInsets>(
                                        EdgeInsets.symmetric(horizontal: 16.0)),
                                onTap: () {
                                  controller.openView();
                                },
                                onChanged: (_) {
                                  controller.openView();

                                },
                                leading: const Icon(Icons.search));
                          }, suggestionsBuilder: (BuildContext context,
                                  SearchController controller) async {
                            return List<ListTile>.generate(5, (int index) {
                              final String item = 'item $index';
                              return ListTile(
                                title: Text(item),
                                onTap: () {
                                  setState(() {
                                    controller.closeView(item);
                                  });
                                },
                              );
                            });
                          })),*/
                          Align(
                              alignment: Alignment.topLeft,
                              child: MyText('Shounen :')),
                          SizedBox(
                              height: 220,
                              child: ListView.builder(
                                  controller: _controllerFirstGenre,
                                  itemCount: _firstGenreShorten.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => PageAnime(
                                                        anime:
                                                            _firstGenreShorten
                                                                .elementAt(
                                                                    index))));
                                          },
                                          child: Card(
                                              child: Column(
                                            children: [
                                              (MyPadding(
                                                  child: Image(
                                                      image: NetworkImage(
                                                          _firstGenreShorten
                                                              .elementAt(index)
                                                              .info
                                                              .picture),
                                                      height: 150,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      }))),
                                              MyPadding(
                                                  child: MyText(
                                                      _firstGenreShorten
                                                          .elementAt(index)
                                                          .info
                                                          .name))
                                            ],
                                          ))))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: MyText('Shoujo :')),
                          SizedBox(
                              height: 220,
                              child: ListView.builder(
                                  controller: _controllerSecondGenre,
                                  itemCount: _secondGenreShorten.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => PageAnime(
                                                        anime:
                                                            _secondGenreShorten
                                                                .elementAt(
                                                                    index))));
                                          },
                                          child: Card(
                                              child: Column(
                                            children: [
                                              (MyPadding(
                                                  child: Image(
                                                      image: NetworkImage(
                                                          _secondGenreShorten
                                                              .elementAt(index)
                                                              .info
                                                              .picture),
                                                      height: 150,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      }))),
                                              MyPadding(
                                                  child: MyText(
                                                      _secondGenreShorten
                                                          .elementAt(index)
                                                          .info
                                                          .name))
                                            ],
                                          ))))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: MyText('Seinen :')),
                          SizedBox(
                              height: 220,
                              child: ListView.builder(
                                  controller: _controllerThirdGenre,
                                  itemCount: _thirdGenreShorten.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => PageAnime(
                                                        anime:
                                                            _thirdGenreShorten
                                                                .elementAt(
                                                                    index))));
                                          },
                                          child: Card(
                                              child: Column(
                                            children: [
                                              (MyPadding(
                                                  child: Image(
                                                      image: NetworkImage(
                                                          _thirdGenreShorten
                                                              .elementAt(index)
                                                              .info
                                                              .picture),
                                                      height: 150,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      }))),
                                              MyPadding(
                                                  child: MyText(
                                                      _thirdGenreShorten
                                                          .elementAt(index)
                                                          .info
                                                          .name))
                                            ],
                                          ))))),
                          Align(
                              alignment: Alignment.topLeft,
                              child: MyText('Josei :')),
                          SizedBox(
                              height: 220,
                              child: ListView.builder(
                                  controller: _controllerFourthGenre,
                                  itemCount: _fourthGenreShorten.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => PageAnime(
                                                        anime:
                                                            _fourthGenreShorten
                                                                .elementAt(
                                                                    index))));
                                          },
                                          child: Card(
                                              child: Column(
                                            children: [
                                              (MyPadding(
                                                  child: Image(
                                                      image: NetworkImage(
                                                          _fourthGenreShorten
                                                              .elementAt(index)
                                                              .info
                                                              .picture),
                                                      height: 150,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      }))),
                                              MyPadding(
                                                  child: MyText(
                                                      _fourthGenreShorten
                                                          .elementAt(index)
                                                          .info
                                                          .name))
                                            ],
                                          )))))
                        ]));
              }
              if (snapshot.hasError) {
                Future.delayed(Duration.zero, () {
                  Provider.of<LoginState>(context, listen: false).disconnect();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                });
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
