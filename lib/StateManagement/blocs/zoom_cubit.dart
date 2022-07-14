import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'zoom_state.dart';

class ZoomCubit extends Cubit<ZoomState> {
  ZoomCubit() : super(ZoomInitial());

  static ZoomCubit instance(BuildContext context) => BlocProvider.of(context);
  double maxWidth = 1.0;
  double maxHeight = 1.0;

  void changeMaxZoom() {
    if (state is ZoomInitial) {
      maxHeight = 3.0;
      maxWidth = 2.0;
      emit(ZoomChange());
    } else {
      returnToInitial();
    }
  }

  void returnToInitial() {
    maxHeight = 1.0;
    maxWidth = 1.0;
    emit(ZoomInitial());
  }
}
