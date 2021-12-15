import 'dart:async';
import 'package:bloc/bloc.dart';
import 'tab.dart';
import '/models/models.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc() : super(AppTab.home) {
    on<UpdateTab>((event, emit) => emit(event.tab));
  }
}