import 'package:equatable/equatable.dart';
import '../../models/like.dart';

abstract class LikeEvent extends Equatable {}

class AddLikeEvent extends LikeEvent {
  AddLikeEvent({required this.id, required this.url});

  final String id;
  final String url;

  @override
  List<Object> get props => [id, url];
}

class LikeExist extends LikeEvent {
  LikeExist({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}

class DislikeEvent extends LikeEvent {
  DislikeEvent({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}