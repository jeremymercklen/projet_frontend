// lib/widgets/search_bar.dart
import 'package:flutter/material.dart';
import 'package:projet_frontend/models/anime.dart';
import 'package:projet_frontend/pages/page_anime.dart';
import 'package:projet_frontend/components.dart';

class AnimeSearchBar extends StatelessWidget {
  final Future<List<Anime>> Function(String query) searchAnimes;

  const AnimeSearchBar({super.key, required this.searchAnimes});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
          hintText: 'Search animes...',
        );
      },
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
        if (controller.text.isEmpty) {
          return const [];
        }

        final animes = await searchAnimes(controller.text);

        return animes
            .map((anime) => ListTile(
                  leading: Image.network(
                    anime.info.picture,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: MyText(anime.info.name),
                  onTap: () {
                    controller.closeView(controller.text);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PageAnime(anime: anime)));
                  },
                ))
            .toList();
      },
    );
  }
}
