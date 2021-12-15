import 'package:cat_app/bloc/cat_likes/bloc.dart';
import 'package:cat_app/common/cached_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LikeBloc _bloc = BlocProvider.of<LikeBloc>(context);
    return BlocBuilder<LikeBloc, LikesState>(
      builder: (context, state) {
        if (state is Likes) {
          if (state.likes.length > 0) {
            return GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: state.likes.length,
              itemBuilder: (context, index) => Stack(
                children: [
                  CachedImage(imageUrl: state.likes.elementAt(index)),
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
                              if (likeState is Likes) {
                                return FavoriteButton(
                                    valueChanged: (isLiked) async {
                                      _bloc.add(Dislike(
                                          id: state.likes.elementAt(index)));
                                      return !isLiked;
                                    },
                                    iconSize: 32,
                                    isFavorite: true,
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                'Oops... Its empty!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            );
          }
        } else {
          return Center(
            child: Text(
              'Loading likes..',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          );
        }
      },
    );
  }
}
