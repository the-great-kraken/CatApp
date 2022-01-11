import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/bloc/cat_facts/bloc.dart';
import 'package:cat_app/bloc/cat_likes/bloc.dart';
import 'package:cat_app/models/like.dart';
import 'package:cat_app/theme.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageScreen extends StatelessWidget {
  final String imgUrl;
  final String id;
  final bool isLike;

  const ImageScreen(
      {Key? key, required this.imgUrl, required this.isLike, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LikeBloc _likeBloc = BlocProvider.of<LikeBloc>(context);
    bool isFavorite = isLike;

    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            FavoriteButton(
              valueChanged: (isLiked) async {
                if (isFavorite) {
                  _likeBloc.likeRepository.dislike(
                    id,
                  );
                  isFavorite = false;
                } else {
                  _likeBloc.likeRepository.addLike(Like(
                    id,
                    imgUrl,
                    DateTime.now(),
                  ));
                }
              },
              isFavorite: isFavorite,
              iconSize: 40,
              iconDisabledColor: Colors.white70,
            ),
          ],
        ),
        body: Center(
          child: Hero(
            tag: id,
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return SingleChildScrollView(
                child: CachedNetworkImage(
                  imageUrl: '$imgUrl',
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.primaryColorLight,
              ),
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: '$imgUrl',
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [Facts()],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Facts extends StatelessWidget {
  const Facts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: CatFactsBloc().getFacts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> _facts = snapshot.data as List<String>;
            print(snapshot.data);
            return Column(
              children: _facts
                  .map((e) => Card(
                    child: Container(
                      width: Size.infinite.width,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('«$e»',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              )),
                        ),
                      ),),)
                  .toList(),
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
        },
      ),
    );
  }
}
