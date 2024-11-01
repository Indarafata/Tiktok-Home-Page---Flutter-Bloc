import 'package:flutter_bloc/flutter_bloc.dart';

class LikeCubit extends Cubit<bool> {
  LikeCubit() : super(false); // initially not liked

  void toggleLike() => emit(!state); // toggle between liked and not liked
}