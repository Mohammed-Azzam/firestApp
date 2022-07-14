import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_and_success/StateManagement/blocs/posts_cubit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'verify_video_states.dart';

class VerifyVideoCubit extends Cubit<VerifyVideoStates> {
  VerifyVideoCubit() : super(VerifyVideoStateInitial());

  Map<String, Map<String, dynamic>> timeResults = {};

  // int timeCountDown = -1;
  int totalTime = -1;

  static VerifyVideoCubit instance(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> verifyVideoCounter(int userId, int postId) async {
    final String url =
        'https://speedandsuccessphone.website/api.php?cmd=verify_video_counter&user_id=$userId&post_id=$postId';
    final response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      dynamic r = json.decode(response.body)['response'];
      print('verify output runtime output is:${r.runtimeType.toString()}');
      if (r.runtimeType.toString() == '_JsonMap' ||
          r.runtimeType.toString() ==
              '_InternalLinkedHashMap<String, dynamic>') {
        print('json output');

        if (r.containsKey('time_count_down')) {
          print('output contain time count down');

          timeResults.update(postId.toString(), (value) => r,
              ifAbsent: () => r);

          totalTime = r['total_time'];
          print('timeResults: $timeResults');
          emit(VideoVerified(
            timeResult: timeResults,
            // timeCountDown: timeCountDown,
            totalTime: totalTime,
          ));
        }
      } else if (r.runtimeType.toString() == 'String') {
        //exceed the time limit
        print('exceed');
        emit(VideoCountExceedLimit());
      } else {
        print('fail to verify');

        emit(VideoVerificationFailed());
      }
    } else {
      print('error verifying video $postId for user $userId');
      throw (Exception());
    }
  }

  Future<void> refreshSinglePost(context, PostsCubit postsCubit, int userId,
      int postId, VerifyVideoCubit verifyVideoCubit) async {
    final String url =
        'https://speedandsuccessphone.website/api.php?cmd=get_video_counter&user_id=$userId&post_id=$postId';
    print('get video counter for post: $postId');
    print(url);
    final response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      List<dynamic> l = json.decode(response.body)['response'];

      //update the counter
      print('update the post counter');
      postsCubit.updateAdditionalInfoList(
          // context, userId, verifyVideoCubit
          postId, l[0]
          );

      // update the time
      if (l[0]['text'] == 'continue') {
        print('update the post time');
        verifyVideoCounter(userId, postId);
      }
    }
  }
}
