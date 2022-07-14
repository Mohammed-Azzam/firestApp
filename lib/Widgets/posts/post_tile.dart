import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:speed_and_success/DataModels/single_post_additional_info.dart';
import 'package:speed_and_success/StateManagement/blocs/login_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/posts_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/verify_video_cubit.dart';
import 'package:speed_and_success/Widgets/common/dialogs.dart';
import 'package:speed_and_success/Widgets/posts/post_page.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/constants.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/requests/params_post_list.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/schemas/post.dart';
import 'package:speed_and_success/helpers/get_src_link.dart';

import '../../constants.dart';
import 'circular_time_indicator.dart';

class PostTile extends StatefulWidget {
  final String imageApiUrl,
      title,
      desc,
      excerpt,
      pageUrl,
      content,
      categoryName,
      instructorName;
  final Post post;
  final SinglePostAdditionalInfo additionalInfo;
  final int categoryNum;

  PostTile({
    required this.imageApiUrl,
    required this.title,
    required this.desc,
    required this.excerpt,
    required this.pageUrl,
    required this.content,
    required this.post,
    required this.categoryName,
    required this.instructorName,
    required this.additionalInfo,
    required this.categoryNum,
  });

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  String imageUrl = '';
  String? src = null;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageApiUrl;
    src = getSrc(widget.content);

  }

  @override
  Widget build(BuildContext context) {
    PostsCubit postsCubit = PostsCubit.instance(context);
    LoginCubit loginCubit = LoginCubit.instance(context);
    VerifyVideoCubit verifyVideoCubit = VerifyVideoCubit.instance(context);
    return GestureDetector(
      onTap: () async {
        if (imageUrl != "" && src != null) {
          if (!widget.content.contains('error')) {
            if (widget.additionalInfo.counter >=
                    widget.additionalInfo.limit_counter &&
                widget.additionalInfo.status == 'start') {
              await Dialogs().showAlertDialog(context,
                  dialogText:
                      'Please contact the admin if you want to buy more watches ');
            } else {
              if (widget.additionalInfo.status == 'start') {
                await Dialogs().showCustomDialog(context,
                    txt1:
                        'Are you sure you Want to watch the video and spend 1 watch?',
                    aactionText1: 'Watch',
                    actionText2: 'No', action1: () async {
                  print('Watch clicked');
                  await verifyVideoCubit.verifyVideoCounter(
                      loginCubit.wpUser!.id!, widget.post.id!);

                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPage(
                        post: widget.post,
                        categoryName: widget.categoryName,
                        instructorName: widget.instructorName,
                        title: widget.title,
                        imageUrl: imageUrl,
                        desc: widget.desc,
                        execprt: widget.excerpt,
                        pageUrl: widget.pageUrl,
                        content: widget.content,
                        totalTime: verifyVideoCubit.totalTime,
                        remainingTimeSec: (verifyVideoCubit.timeResults[
                            widget.post.id.toString()]!['time_count_down']),
                        categoryNum: widget.categoryNum,
                      ),
                    ),
                  );
                }, action2: () {
                  print('No clicked');
                  Navigator.of(context).pop();
                });
              } else {
                final int remainingTimeSec =
                ((verifyVideoCubit.timeResults[widget.post.id.toString()] ??
                    {})['time_count_down'] ??
                    0);
                String status = await postsCubit.getPostStatus(
                    loginCubit.wpUser!.id!, widget.post.id!);
                if (status == 'continue' && remainingTimeSec>5) {
                  verifyVideoCubit.verifyVideoCounter(
                      loginCubit.wpUser!.id!, widget.post.id!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPage(
                        post: widget.post,
                        categoryName: widget.categoryName,
                        instructorName: widget.instructorName,
                        title: widget.title,
                        imageUrl: imageUrl,
                        desc: widget.desc,
                        execprt: widget.excerpt,
                        pageUrl: widget.pageUrl,
                        content: widget.content,
                        totalTime: verifyVideoCubit.totalTime,
                        remainingTimeSec: (verifyVideoCubit.timeResults[
                            widget.post.id.toString()]!['time_count_down']),
                        categoryNum: widget.categoryNum,
                      ),
                    ),
                  );
                } else {
                  postsCubit.updatePosts(
                      context, verifyVideoCubit, loginCubit.wpUser!.id!,
                      paramsPostList: ParamsPostList(
                          context: WordPressContext.view,
                          orderBy: PostOrderBy.date,
                          order: Order.asc,
                          postStatus: PostPageStatus.publish,
                          perPage: 100,
                          includeCategories: [widget.categoryNum]));
                }
              }
            }
          } else {
            Dialogs().showErrorDialog(context,
                errorStatement:
                    'You have no access to this lesson\n, please contact the adminstrator');
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        maxLines: 3,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${widget.additionalInfo.limit_counter - widget.additionalInfo.counter} remaning watch',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 125, 44, 163)),
                              ),
                              TextSpan(
                                  text:
                                      ' / ${widget.additionalInfo.limit_counter} Watches',
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
              if (widget.additionalInfo.status == 'continue')
                BlocConsumer<VerifyVideoCubit, VerifyVideoStates>(
                  listener: (context, state) {
                    if (state is VideoVerified) {
                      print(state.timeResult[widget.post.id.toString()]);
                    }
                  },
                  builder: (context, state) {
                    if (state is VideoVerified) {
                      final int remainingTimeSec =
                          ((state.timeResult[widget.post.id.toString()] ??
                                  {})['time_count_down'] ??
                              0);

                      return CircularTimeIndicator(
                        remainingTimeSec: remainingTimeSec,
                        totalTime: state.totalTime,
                        onTimerEnd: () {
                          print('Timer end from post tile');
                          postsCubit.updatePosts(
                              context, verifyVideoCubit, loginCubit.wpUser!.id!,
                              paramsPostList: ParamsPostList(
                                  context: WordPressContext.view,
                                  orderBy: PostOrderBy.date,
                                  order: Order.asc,
                                  postStatus: PostPageStatus.publish,
                                  perPage: 100,
                                  includeCategories: [widget.categoryNum]));
                        },
                      );
                      double percent = 1;
                      double remainingTime = 0;
                      String unit = '';
                      if (remainingTimeSec > 0 && remainingTimeSec < 60) {
                        unit = 'sec';
                        remainingTime = remainingTimeSec.toDouble();
                      } else if (remainingTimeSec >= 60 &&
                          remainingTimeSec < 3600) {
                        unit = 'min';
                        remainingTime = remainingTimeSec.toDouble() / 60.0;
                      } else if (remainingTimeSec >= 3600) {
                        unit = 'hr';
                        remainingTime = remainingTimeSec.toDouble() / 3600.0;
                      } else {
                        print('error in verify ');
                      }
                      percent = remainingTime / state.totalTime;
                      print('called verify');
                      return CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 4.0,
                        animation: true,
                        // animateFromLastPercent: true,
                        backgroundColor: Colors.grey[350]!,
                        percent: percent,
                        center: Container(
                          height: 90,
                          width: 90,
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            child: Text(
                              "${remainingTime.toStringAsFixed(1)}\n$unit",
                              softWrap: true,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        progressColor: Color.fromARGB(230, 157, 55, 204),
                        // progressColor: Colors.pinkAccent.withBlue(100).withGreen(50),
                        circularStrokeCap: CircularStrokeCap.round,
                      );
                    } else {
                      print('not called verify');
                      return Container();
                    }
                  },
                ),
              // Container(
              //   margin: EdgeInsets.all(8),
              //   child: ClipOval(
              //     child: CachedNetworkImage(
              //       height: 75,
              //       width: 100,
              //       fit: BoxFit.contain,
              //       imageUrl: imageUrl,
              //       placeholder: (context, s) => Container(
              //         height: 75,
              //         width: 100,
              //         child: Center(
              //           child: CircularProgressIndicator(),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ]),
            // SizedBox(height: 8),

            SizedBox(height: 5),
            (!widget.content.contains('error'))
                ? Container()
                : Text(
                    'No access for this Lesson',
                    style: TextStyle(color: Colors.red),
                  ),
            // Text(widget.desc)
          ],
        ),
      ),
    );
  }
}
