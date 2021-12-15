import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/bloc/cat_facts/bloc.dart';
import 'package:cat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageScreen extends StatelessWidget {
  final String imgUrl;
  final String tag;

  const ImageScreen({Key? key, required this.imgUrl, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
        ),
        body: Center(
          child: Hero(
            tag: tag,
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return SingleChildScrollView(
                child: CachedNetworkImage(imageUrl: '$imgUrl',),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.primaryColorLight,
              ),
              child: Column(
                children: [
                  CachedNetworkImage(imageUrl: '$imgUrl',),
                  Expanded(
                    flex: 7,
                    child: Padding(
                          padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          children: [
                            Facts()
                          ],
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
      child: BlocBuilder<CatFactsBloc, CatFactsState>(
        builder: (context, state) {
          if (state is CatsFactsLoaded) {
            return Column(
              children: state.facts
                  .map(
                    (e) => Card( 
                      child: Padding(
                        padding: EdgeInsets.all(20),
                      child: Text('«$e»',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        )),
                      ),
                  ))
                  .toList(),
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
        },
      ),
    );
  }
}
