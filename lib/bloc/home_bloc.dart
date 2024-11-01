import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiktok_home_page_bloc/model/tiktok_model.dart';
import 'package:tiktok_home_page_bloc/service/tiktok_service.dart';
import 'package:video_player/video_player.dart';

abstract class HomeEvent {}

class LoadVideos extends HomeEvent {}

class PlayVideo extends HomeEvent {
  final int index;
  PlayVideo(this.index);
}

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Tiktok> videos;
  final List<VideoPlayerController> controllers;
  final int playingIndex;

  HomeLoaded(this.videos, this.controllers, this.playingIndex);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TiktokService tiktokService;
  late List<VideoPlayerController> _controllers;
  int _playingIndex = -1;

  HomeBloc(this.tiktokService) : super(HomeInitial()) {
    _controllers = [];

    on<LoadVideos>((event, emit) async {
      emit(HomeLoading());
      try {
        final videos = await tiktokService.fetchTiktokData();
        await _initializeVideoControllers(videos, emit);
      } catch (e) {
        emit(HomeError('Failed to load videos $e'));
      }
    });

    on<PlayVideo>((event, emit) {
      _playVideo(event.index);
      emit(HomeLoaded(
          (state as HomeLoaded).videos, _controllers, _playingIndex));
    });
  }

  Future<void> _initializeVideoControllers(
      List<Tiktok> videos, Emitter<HomeState> emit) async {
    List<VideoPlayerController> controllers = [];

    for (int i = 0; i < videos.length; i++) {
      var controller =
          VideoPlayerController.asset('assets/videos/video${i + 1}.mp4');
      await controller
          .initialize();
      controllers.add(controller);
    }

    _controllers = controllers;
    _playingIndex = 0;
    _controllers[_playingIndex].play();
    _controllers[_playingIndex].setLooping(true);

    emit(HomeLoaded(videos, _controllers, _playingIndex));
  }

  void _playVideo(int index) {
    if (_playingIndex != index) {
      _controllers[_playingIndex].pause();
      _controllers[index].play();
      _controllers[index].setLooping(true);
      _playingIndex = index;
    }
  }

  @override
  Future<void> close() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    return super.close();
  }
}
