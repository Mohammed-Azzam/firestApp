part of 'verify_video_cubit.dart';

abstract class VerifyVideoStates {
  const VerifyVideoStates();
}

class VerifyVideoStateInitial extends VerifyVideoStates {}

class VideoVerified extends VerifyVideoStates {
  // final int timeCountDown;
  // final int totalTime;
  final Map<String, Map<String, dynamic>> timeResult;
  final int totalTime;

  VideoVerified({
    required this.timeResult,
    required this.totalTime,
    // required this.totalTime,
    // required this.timeCountDown,
  });
}

class VideoCountExceedLimit extends VerifyVideoStates {}

class VideoVerificationFailed extends VerifyVideoStates {}
