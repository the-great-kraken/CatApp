import 'package:cat_app/bloc/cat_likes/bloc.dart';
import 'package:cat_app/common/cached_image.dart';
import 'package:cat_app/models/like.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/cat_likes/bloc.dart';
import '../../bloc/cat_likes/likes_repository.dart';
import '../../bloc/cat_likes/state.dart';
import '../home/view/image_screen.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: LikesRepository().fetchItems(),
          builder: streamBuilder,
        ),
      ),
    );
  }

  Widget streamBuilder(context, snapshot) {
    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator());
    }

    List<Like> list = snapshot.data as List<Like>;

    if (list.length == 0) {
      return Center(
        child: Text('You have not any favorites yet'),
      );
    }

    LikeBloc _bloc = BlocProvider.of<LikeBloc>(context);

    return BlocBuilder<LikeBloc, LikesState>(builder: (context, state) {
      return GridView.builder(
          padding: EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return ImageScreen(
                    imgUrl: '${list[index].url}',
                    id: '${list[index].id}',
                    isLike: true,
                  );
                }));
              },
              child: Hero(
                tag: 'dash${list[index].id}',
                flightShuttleBuilder: (
                  BuildContext flightContext,
                  Animation<double> animation,
                  HeroFlightDirection flightDirection,
                  BuildContext fromHeroContext,
                  BuildContext toHeroContext,
                ) {
                  return SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(30),
                      child: Image.network('${list[index].url}'),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    CachedImage(imageUrl: list.elementAt(index).url),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              BlocBuilder<LikeBloc, LikesState>(
                                  builder: (context, likeState) {
                                return FavoriteButton(
                                  valueChanged: (isLiked) async {
                                    _bloc.likeRepository.dislike(
                                      list[index].id,
                                    );
                                  },
                                  iconSize: 32,
                                  isFavorite: true,
                                );
                              }),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}
