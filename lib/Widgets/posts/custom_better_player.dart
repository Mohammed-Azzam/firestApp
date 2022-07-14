import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_and_success/DataModels/video_model.dart';
import 'package:speed_and_success/StateManagement/blocs/zoom_cubit.dart';
import 'package:zoom_widget/zoom_widget.dart';

class CustomBetterVideoPlayer extends StatefulWidget {
  final String url;
  final String lessonImgUrl, instructorName, lessonName, courseName;
  final VideoModel videoModel;
  final String userName;

  const CustomBetterVideoPlayer({
    Key? key,
    required this.url,
    required this.lessonImgUrl,
    required this.instructorName,
    required this.lessonName,
    required this.courseName,
    required this.videoModel,
    required this.userName,
  }) : super(key: key);

  @override
  _CustomBetterVideoPlayerState createState() =>
      _CustomBetterVideoPlayerState();
}

class _CustomBetterVideoPlayerState extends State<CustomBetterVideoPlayer> {
  late BetterPlayerController _betterPlayerController;
  static var lessonName;
  static var instructorName;
  static var lessonImgUrl;
  static var courseName;

  // GlobalKey _betterPlayerKey = GlobalKey();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);

    lessonName = widget.lessonName;
    instructorName = widget.instructorName;
    lessonImgUrl = widget.lessonImgUrl;
    courseName = widget.courseName;
    print(widget.videoModel.resolutions.values);
    print(widget.videoModel.resolutions.values.first);

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.videoModel.resolutions.values.elementAt(0),
      headers: {
        "header": "my_custom_header" + courseName + instructorName + lessonName
      },
      resolutions: widget.videoModel.resolutions,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: lessonName,
        author: instructorName,
        imageUrl: lessonImgUrl,
        activityName: "MainActivity",
      ),
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: false,
        preCacheSize: 3000000,
        maxCacheSize: 9100000,
        maxCacheFileSize: 10000000,

        ///Android only option to use cached video between app sessions
        key: widget.url,
      ),
    );

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      autoPlay: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableFullscreen: false,
      ),
      looping: true,
      fullScreenByDefault: false,
      showPlaceholderUntilPlay: true,
      autoDetectFullscreenDeviceOrientation: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
      deviceOrientationsOnFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
      placeholder: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      // controlsConfiguration: BetterPlayerControlsConfiguration(
      //   // textColor: Colors.black,
      //   // iconsColor: Colors.black,
      // ),
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    // _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    // _betterPlayerController.enablePictureInPicture(_betterPlayerKey);

    // _betterPlayerController.eventListener!(
    //     BetterPlayerEvent(BetterPlayerEventType.hideFullscreen));
    // _betterPlayerController.addEventsListener((BetterPlayerEvent event) {
    //   if(event.betterPlayerEventType == BetterPlayerEventType.hideFullscreen ){
    //     print('hide full screen ');
    //     Navigator.of(context).pop();
    //   }
    // });
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
        _betterPlayerController.pause();
        print('video exception: ${event.parameters}');
        int i = Random().nextInt(widget.videoModel.resolutions.values.length);
        print(
            'i: $i\nurl:${widget.videoModel.resolutions.values.elementAt(i)}');
        dataSource = dataSource.copyWith(
            url: widget.videoModel.resolutions.values.elementAt(i));
        print(dataSource.url);
        _betterPlayerController.setupDataSource(dataSource).then((value) {
          _betterPlayerController.retryDataSource().then((value2) {
            print(value2);
          });
          // _betterPlayerController.play();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    if (_betterPlayerController.isFullScreen)
      _betterPlayerController.exitFullScreen();
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ZoomCubit zoomCubit = ZoomCubit.instance(context);
    return WillPopScope(
      onWillPop: () async {
        print('pop out custom');

        // Navigator.of(context).pop();
        return Future.value(true);
      },
      child: BlocConsumer<ZoomCubit, ZoomState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Zoom(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              maxZoomHeight:
                  MediaQuery.of(context).size.height * zoomCubit.maxHeight,
              maxZoomWidth:
                  MediaQuery.of(context).size.width * zoomCubit.maxWidth,
              colorScrollBars: Colors.deepPurple,
              opacityScrollBars: 0.3,
              scrollWeight: 4.0,
              initZoom: (state is ZoomInitial)? 1.0: 2.0,
              canvasColor: Colors.transparent,
              backgroundColor: Colors.black12,
              centerOnScale: true,
              child: BetterPlayer(
                controller: _betterPlayerController,
                // key: _betterPlayerKey,
              ),
            );
          }),
    );
  }
}
