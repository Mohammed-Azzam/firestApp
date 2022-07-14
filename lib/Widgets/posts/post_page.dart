import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_and_success/StateManagement/blocs/login_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/posts_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/verify_video_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/video_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/zoom_cubit.dart';
import 'package:speed_and_success/Widgets/common/rounded_button.dart';
import 'package:speed_and_success/Widgets/posts/custom_better_player.dart';
import 'package:speed_and_success/Widgets/posts/custom_drive_player.dart';
import 'package:speed_and_success/Widgets/posts/custom_youtube_player.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/schemas/post.dart';
import 'package:speed_and_success/helpers/get_src_link.dart';
import 'package:speed_and_success/helpers/remove_html_tags.dart';
import 'package:speed_and_success/helpers/watter_mark.dart';
import 'package:upgrader/upgrader.dart';

import 'circular_time_indicator.dart';
import 'custom_chiewe_player.dart';

class PostPage extends StatefulWidget {
  final String imageUrl,
      title,
      desc,
      execprt,
      pageUrl,
      content,
      categoryName,
      instructorName;
  final Post post;
  final int remainingTimeSec;
  final int totalTime;
  final int categoryNum;

  PostPage({
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.execprt,
    required this.pageUrl,
    required this.content,
    required this.post,
    required this.categoryName,
    required this.instructorName,
    required this.remainingTimeSec,
    required this.totalTime,
    required this.categoryNum,
  });

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Future<void> popupRoutine(PostsCubit postCubit,
      VerifyVideoCubit verifyVideoCubit, LoginCubit loginCubit, ZoomCubit zoomCubit) async {
    verifyVideoCubit.refreshSinglePost(context, postCubit,
        loginCubit.wpUser!.id!, widget.post.id!, verifyVideoCubit);
    if (mounted) {
      SystemChrome.setEnabledSystemUIOverlays([
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    zoomCubit.returnToInitial();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  late String? src;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    SystemChrome.setEnabledSystemUIOverlays([]);

    src = getSrc(widget.content);
    if (src != null) {
      if (src!.contains('vimeo') && !src!.contains('mp4')) {
        VideoCubit.instance(context).getVideo(context, src!);
      }
    }
    // SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    _overlayEntry.remove();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    super.dispose();
  }

  late OverlayEntry _overlayEntry;

  addWatermark(BuildContext context, String watermark,
      {int rowCount = 4, int columnCount = 10}) async {
    try {
      _overlayEntry.remove();
    } catch (e) {}

    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
        builder: (context) => Watarmark(
              rowCount: rowCount,
              columnCount: columnCount,
              text: watermark,
            ));
    overlayState?.insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    print("=============== content " + widget.content.toString() + " ~end");

    String src = getSrc(widget.content) ?? '';

    final String userName = LoginCubit.instance(context).wpUser!.username!;

    addWatermark(context, userName);

    PostsCubit postCubit = PostsCubit.instance(context);
    VerifyVideoCubit verifyVideoCubit = VerifyVideoCubit.instance(context);
    LoginCubit loginCubit = LoginCubit.instance(context);
    ZoomCubit zoomCubit = ZoomCubit.instance(context);

    Upgrader.clearSavedSettings();

    return WillPopScope(
      onWillPop: () async {
        popupRoutine(postCubit, verifyVideoCubit, loginCubit,zoomCubit);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: 8, left: 0),
          child: Row(children: [
//            (!src.contains('youtube'))
//                ?
            FloatingActionButton(
              key: ValueKey("back"),
              heroTag: "back",
              onPressed: () async {
                popupRoutine(postCubit, verifyVideoCubit, loginCubit, zoomCubit);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 35,
              ),
              backgroundColor: Colors.black12,
              foregroundColor: Theme.of(context).primaryColor,
              elevation: 0,
            ),
            SizedBox(
              width: 4,
            ),
            CircularTimeIndicator(
              remainingTimeSec: widget.remainingTimeSec,
              totalTime: widget.totalTime,
              onTimerEnd: () {
                print('Timer end from post page');
                popupRoutine(postCubit, verifyVideoCubit, loginCubit, zoomCubit);
              },
            ),
            SizedBox(
              width: 4,
            ),
            FloatingActionButton(
              key: ValueKey("zoom"),
              heroTag: "zoom",
              onPressed: () async {
                ZoomCubit.instance(context).changeMaxZoom();
              },
              child: BlocConsumer<ZoomCubit, ZoomState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is ZoomInitial) {
                      return Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 35,
                      );
                    } else {
                      return Icon(
                        Icons.zoom_out,
                        color: Colors.white,
                        size: 35,
                      );
                    }
                  }),
              backgroundColor: Colors.black12,
              foregroundColor: Theme.of(context).primaryColor,
              elevation: 0,
            ),
          ]),
        ),
        body: (src.contains('youtube'))
            ? CustomYoutubeVideoPlayer(
                userName: userName,
                url: src,
              )
            : (src.contains('google') && src.contains('drive'))
                ? CustomDriveVideoPlayer(
                    userName: userName,
                    url: widget.pageUrl,
                  )
                : (src.contains('vimeo') && !src.contains('mp4'))
                    ? BlocConsumer<VideoCubit, VideoStates>(
                        listener: (BuildContext context, VideoStates state) {},
                        builder: (BuildContext context, VideoStates state) {
                          if (state is VideoGetFinishedSuccessfully) {
                            return CustomBetterVideoPlayer(
                              url: src,
                              userName: userName,
                              videoModel: state.videoModel,
                              courseName: widget.categoryName,
                              instructorName: widget.instructorName,
                              lessonName: widget.post.title!.rendered!,
                              lessonImgUrl: (widget.post.featuredMedia == null)
                                  ? 'https://speedandsuccessphone.website/draft/old/wp-content/uploads/2021/04/cropped-New-Project-1-1.png'
                                  : widget.post.featuredMedia!.sourceUrl!,
                            );
                          } else if (state is VideoFinishedWithError) {
                            return Center(
                              child: Column(children: [
                                Text(
                                    'Error loading video, please try again later '),
                                RoundedButton(
                                  text: 'Reload',
                                  press: () {
                                    VideoCubit.instance(context)
                                        .getVideo(context, src);
                                  },
                                ),
                              ]),
                            );
                          } else if (state is VideoGetStarted) {
                            print('loading');
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            print('unknown error');
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            );
                          }
                        })
                    : (src.contains('http') && src.contains('mp4'))
                        ? CustomChewieVideoPlayer(url: src)
                        : Container(
                            child: Text(
                              removeAllHtmlTags(widget.content),
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
      ),
    );
  }
}
