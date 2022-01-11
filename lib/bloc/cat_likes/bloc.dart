import 'package:cat_app/models/like.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'likes_repository.dart';
import 'state.dart';

class LikeBloc extends Bloc<AddLikeEvent, LikesState> {
  LikeBloc({required this.likeRepository}) : super(LikesState());

  final LikesRepository likeRepository;

  @override
  Stream<LikesState> mapEventToState(LikeEvent event) async* {
    if (event is AddLikeEvent) {
      Like like = Like(event.id, event.url, DateTime.now());
      await likeRepository.addLike(like);
    } else if (event is DislikeEvent) {
      await likeRepository.dislike(event.id);
    }
  }
}
