import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_and_success/DataModels/video_model.dart';
import 'package:speed_and_success/Widgets/common/dialogs.dart';
import 'package:speed_and_success/Widgets/common/rounded_button.dart';
import 'package:speed_and_success/helpers/get_vimeo_id.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'video_states.dart';

class VideoCubit extends Cubit<VideoStates> {
  VideoCubit() : super(VideoStateInitial());

  late VideoModel videoModel;

  static VideoCubit instance(BuildContext context) => BlocProvider.of(context);

  Future<bool> internetChecks(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      Dialogs().showErrorDialog(context,
          errorStatement: 'please, check the internet connectivity');
      return false;
    }
  }

  Future<void> getVideo(BuildContext context, String src) async {
    bool internetIsConnected = await internetChecks(context);
    if (internetIsConnected) {
      emit(VideoGetStarted());
      final vimeoId = getVimeoId(src);
      final String url = 'https://player.vimeo.com/video/$vimeoId/config';
      final response = await http
          .get(Uri.parse(url), headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        videoModel = VideoModel.fromJson(json.decode(response.body));
        emit(VideoGetFinishedSuccessfully(videoModel: videoModel));

      } else {
        print('error fetching Video model  \n use the no resolution');
        videoModel = VideoModel(progressive: [], streams_avc: [], streams: []);
        emit(VideoFinishedWithError(videoModel: videoModel));

      }
      emit(VideoGetFinishedSuccessfully(videoModel: videoModel));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Network Error'),
              content: Text('Please check your network adaptor'),
              actions: [
                RoundedButton(
                  text: 'Ok',
                  heightRatio: 0.05,
                  press: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }
}
