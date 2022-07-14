part of 'video_cubit.dart';

abstract class VideoStates {
  const VideoStates();
}

class VideoStateInitial extends VideoStates {}

class VideoGetStarted extends VideoStates {}

class VideoGetLoading extends VideoStates {}

class VideoGetFinishedSuccessfully extends VideoStates {
  final VideoModel videoModel;

  VideoGetFinishedSuccessfully({
    required this.videoModel,
  });
}

class VideoFinishedWithError extends VideoStates {
  final VideoModel videoModel;

  VideoFinishedWithError({
    required this.videoModel,
  });
}
