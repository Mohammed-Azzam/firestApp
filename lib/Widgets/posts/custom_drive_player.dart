
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart';

class CustomDriveVideoPlayer extends StatefulWidget {
  final String url;
  final String userName;

  const CustomDriveVideoPlayer({
    Key? key,
    required this.url,
    required this.userName,
  }) : super(key: key);

  @override
  _CustomDriveVideoPlayerState createState() =>
      _CustomDriveVideoPlayerState();
}

class _CustomDriveVideoPlayerState extends State<CustomDriveVideoPlayer> {

  @override
  void initState() {
    super.initState();
    print("=============== 5");
//    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight,DeviceOrientation.landscapeLeft]);
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("=============== 6");
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
//            initialOptions: InAppWebViewGroupOptions(
//                android: AndroidInAppWebViewOptions(
////                  initialScale: 1,
////                  loadWithOverviewMode: true,
////                  useWideViewPort: false,
//                )
//            ),

          )
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
//                  color: Colors.white10,
            child: InkWell(
              onTap: null,
              child: SizedBox(width: 90,height: 90,),
            ),
          ),
        ),
      ],
    );
  }
}


