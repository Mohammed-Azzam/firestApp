import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomVimeoVideoPlayer extends StatefulWidget {
  final String id;

  const CustomVimeoVideoPlayer({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _CustomVimeoVideoPlayerState createState() => _CustomVimeoVideoPlayerState();
}

class _CustomVimeoVideoPlayerState extends State<CustomVimeoVideoPlayer> {

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return VimeoPlayer(
      videoId: widget.id,
    );
  }
}
