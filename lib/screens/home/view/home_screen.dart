import 'package:cat_app/common/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/cat_likes/bloc.dart';
import '/bloc/cat_images/bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'package:favorite_button/favorite_button.dart';
import 'image_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                            tag: 'dash${state.catsImages[index].id}',
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
                                        if (likeState is Likes) {
                                          return FavoriteButton(
                                            valueChanged: (isLiked) async {
                                              if (likeState.likes.contains(state
                                                  .catsImages[index].url)) {
                                                _likeBloc.add(Dislike(
                                                    id: state.catsImages[index]
                                                        .url));
                                                return true;
                                              } else {
                                                _likeBloc.add(Like(
                                                    id: state.catsImages[index]
                                                        .url));
                                                return false;
                                              }
                                            },
                                            iconSize: 40,
                                            iconDisabledColor: Colors.white70,
                                          );
                                        } else {
                                          return Center(
                                            child: Text(
                                              'Something went wrong...',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          );
                                        }
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
            return Column(
              children: [
                const SizedBox(height: 100,),
                Image.asset(
              'assets/images/cat.gif',
              alignment: Alignment.center,
                ),
              ]
            );
          }
        });
  }
}
