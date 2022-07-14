import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';


class CustomYoutubeVideoPlayer extends StatefulWidget {
  final String url;
  final String userName;

  const CustomYoutubeVideoPlayer({
    Key? key,
    required this.url,
    required this.userName,
  }) : super(key: key);

  @override
  _CustomYoutubeVideoPlayerState createState() =>
      _CustomYoutubeVideoPlayerState();
}

class _CustomYoutubeVideoPlayerState extends State<CustomYoutubeVideoPlayer> implements YouTubePlayerListener {

  double speed = 1.0;
  double _currentVideoSecond = 0.0;
  String _playerState = "";
  late FlutterYoutubeViewController _controller ;

  double vDuration = 0.0;
  bool showControl = true;

  void _onYoutubeCreated(FlutterYoutubeViewController controller) {
    this._controller = controller;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight,DeviceOrientation.landscapeLeft]);
  }

  Future<double> getStart(BuildContext context)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double x = 0.0;
    if(prefs.getDouble("lastAudioP"+widget.url)!=null)
      x = prefs.getDouble("lastAudioP"+widget.url)!;
    return x;
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: getStart(context),
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          if(!snapshot.hasData)
            return Center(child: CircularProgressIndicator(),);

          print("lastAudioP start second " + _currentVideoSecond.toString() );
          return Stack(
            children: [
              FlutterYoutubeView(
                onViewCreated: _onYoutubeCreated,
                listener: this,
                params: YoutubeParam(
                    videoId: convertUrlToId(widget.url)!,
                    showUI: false,
                    startSeconds: snapshot.data!,
                    showYoutube: false,
                    showFullScreen: false,
                    autoPlay: true
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    showControl = !showControl;
                  });
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: !showControl?SizedBox(height: 1,):
                Container(
                    color: Colors.black45,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap:(){
                                if(_playerState=="PLAYING"||_playerState=="BUFFERING")
                                  _controller.pause();
                                else
                                  _controller.play();
                              },
                              child: Icon(
                                (_playerState=="PLAYING"||_playerState=="BUFFERING")?Icons.pause:Icons.play_arrow,
                                size: 40,color: Colors.white,

                              ),
                            ),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10,right: 20),
                                  child: ProgressBar(
                                    progress: Duration(seconds: _currentVideoSecond.toInt()),
                                    buffered: Duration(seconds: _currentVideoSecond.toInt()),
                                    total: Duration(seconds: vDuration.toInt()),
                                    onSeek: (duration) {
                                      _controller.seekTo(duration.inSeconds.toDouble());
                                    },
                                    onDragUpdate: (details) {
                                      debugPrint('${details.timeStamp}, ${details.localPosition}');
                                    },
                                    barHeight: 5,
                                    baseBarColor: Colors.white,
                                    progressBarColor: Colors.blue,
                                    bufferedBarColor: Colors.blueAccent,
                                    thumbColor: Colors.white,
                                    timeLabelTextStyle: TextStyle(color: Colors.white),
                                  ),
                                )
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                _controller.seekTo(_currentVideoSecond - 10.0);
                              },
                              child: Icon(Icons.restore,size: 22,color: Colors.white,),
                            ),

                            SizedBox(width: 16,),

                            InkWell(
                                onTap: (){
                                  setState(() {
                                    speed = speed==1.0?1.5:speed==1.5?2.0:1.0;
                                  });
                                  _controller.setPlaybackRate(
                                      rate: speed==1.0
                                          ?PlaybackRate.RATE_1
                                          :speed==1.5
                                          ?PlaybackRate.RATE_1_5
                                          :PlaybackRate.RATE_2);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(speed.toString() + " X",style: TextStyle(color: Colors.blue),),
                                    Text(" سرعة التشغيل ",style: TextStyle(color: Colors.white),),
                                  ],
                                )
                            ),
                            SizedBox(width: 16,),
                            InkWell(
                              onTap: (){
                                _controller.seekTo(_currentVideoSecond + 10.0);
                              },
                              child: Icon(Icons.update,size: 22,color: Colors.white,),
                            ),
                          ],
                        )
                      ],
                    )
                ),
              ),
            ],
          );
        });
  }

  @override
  void onCurrentSecond(double second) {
    print("onCurrentSecond second = $second");
    savePosition(second);
    setState(() {
      _currentVideoSecond = second;
    });
  }

  @override
  void onError(String error) {
    print("onError error = $error");
  }

  @override
  void onReady() {
    print("onReady");

  }

  @override
  void onStateChange(String state) {
    print("onStateChange state = $state");
    setState(() {
      _playerState = state;
    });
  }

  @override
  void onVideoDuration(double duration) {
    print("onVideoDuration duration = $duration");
    setState(() {
      vDuration = duration;
    });
  }


  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return "";
  }

  void savePosition(double second)async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("lastAudioP"+widget.url, second);
  }

}


