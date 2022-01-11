import 'package:cat_app/bloc/cat_likes/likes_repository.dart';
import 'package:cat_app/common/cached_image.dart';
import 'package:cat_app/models/like.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/cat_likes/bloc.dart';
import '../../../bloc/cat_likes/state.dart';
import '/bloc/cat_likes/bloc.dart';
import '/bloc/cat_images/bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:favorite_button/favorite_button.dart';
import 'image_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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

    List<Like> _list = snapshot.data as List<Like>;
    var _idList = _list.map((like) => like.id);

    LikeBloc _likeBloc = BlocProvider.of<LikeBloc>(context);
    CatsBloc _catsBloc = BlocProvider.of<CatsBloc>(context);

    return BlocBuilder<CatsBloc, CatsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is CatsLoaded) {
            return LazyLoadScrollView(
              onEndOfPage: () {
                _catsBloc.add(LoadNewImages());
              },
              child: GridView.builder(
                  padding: EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.catsImages.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return ImageScreen(
                            imgUrl: '${state.catsImages[index].url}',
                            id: '${state.catsImages[index].id}',
                            isLike: _idList.contains(
                                            state.catsImages[index].id),
                          );
                        }));

                      },
                      child: Hero(
                        tag: 'dash${state.catsImages[index].id}',
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
                              child: Image.network(
                                  '${state.catsImages[index].url}'),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            CachedImage(imageUrl: state.catsImages[index].url),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      BlocBuilder<LikeBloc, LikesState>(
                                          builder: (context, likeState) {
                                        bool res = _idList.contains(
                                            state.catsImages[index].id);
                                        return FavoriteButton(
                                          valueChanged: (isLiked) async {
                                            res = await LikesRepository()
                                                .likeExist(
                                                    state.catsImages[index].id);
                                            if (res) {
                                              _likeBloc.likeRepository.dislike(
                                                state.catsImages[index].id,
                                              );
                                            } else {
                                              print(isLiked);
                                              _likeBloc.likeRepository
                                                  .addLike(Like(
                                                state.catsImages[index].id,
                                                state.catsImages[index].url,
                                                DateTime.now(),
                                              ));
                                            }
                                          },
                                          isFavorite: res,
                                          iconSize: 40,
                                          iconDisabledColor: Colors.white70,
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Column(children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/images/cat.gif',
                alignment: Alignment.center,
              ),
            ]);
          }
        });
  }
}
