import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class CustomChewieVideoPlayer extends StatefulWidget {
  final String url;

  const CustomChewieVideoPlayer({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _CustomChewieVideoPlayerState createState() =>
      _CustomChewieVideoPlayerState();
}

class _CustomChewieVideoPlayerState extends State<CustomChewieVideoPlayer> {
  ChewieController? chewieController;
  late VideoPlayerController videoPlayerController;
  late VideoPlayerController videoPlayerController2;

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.url);
    // ..initialize().then((value)  {
    // chewieController.enterFullScreen();
    //     setState((){});
    // });
    // videoPlayerController2 = VideoPlayerController.network(
    //     'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
    await Future.wait([
      videoPlayerController.initialize(),
      // videoPlayerController2.initialize()
    ]);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      autoInitialize: true,
      fullScreenByDefault: true,
      showControls: true,
      allowFullScreen: true,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ],
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      placeholder: Container(
        color: Colors.grey,
      ),
      // autoInitialize: true,
    )..enterFullScreen();
    // chewieController!.enterFullScreen();
    setState(() {});
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    initializePlayer();
    // chewieController!.enterFullScreen();

    // videoPlayerController = VideoPlayerController.network(widget.url)
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    //
    // chewieController = ChewieController(
    //   videoPlayerController: videoPlayerController,
    //   autoPlay: true,
    //   // autoInitialize: true,
    //   // fullScreenByDefault: true,
    //   // allowFullScreen: true,
    //   // allowMuting: true,
    //   // allowPlaybackSpeedChanging: true,
    //   // looping: true,
    //   additionalOptions: (context) {
    //     return <OptionItem>[
    //       OptionItem(
    //         onTap: () => debugPrint('My option works!'),
    //         iconData: Icons.high_quality_outlined,
    //         title: 'Quality',
    //       ),
    //     ];
    //   },
    //   optionsBuilder: (context, defaultOptions) async {
    //     await showDialog<void>(
    //       context: context,
    //       builder: (ctx) {
    //         return Container(
    //           height: 150,
    //           child: AlertDialog(
    //             content: ListView.builder(
    //               itemCount: defaultOptions.length,
    //               itemBuilder: (_, i) => ActionChip(
    //                 label: Text(defaultOptions[i].title),
    //                 onPressed: () => defaultOptions[i].onTap!(),
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );
    // chewieController.enterFullScreen();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (chewieController!.isFullScreen) chewieController!.exitFullScreen();

    videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return Future.value(true);
      },
      child: Column(children: <Widget>[
        Expanded(
          child: Center(
            child: chewieController != null &&
                    chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: chewieController!,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading'),
                    ],
                  ),
          ),
        ),
      ]),
    );
  }
}
