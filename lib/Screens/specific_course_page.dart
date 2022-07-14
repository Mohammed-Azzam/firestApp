import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_and_success/StateManagement/blocs/login_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/posts_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/verify_video_cubit.dart';
import 'package:speed_and_success/Widgets/posts/post_tile.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/constants.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/requests/params_post_list.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/schemas/post.dart';
import 'package:speed_and_success/helpers/callbackDispatcher.dart';
import 'package:workmanager/workmanager.dart';
import 'package:wakelock/wakelock.dart';

import '../constants.dart';

class SpecificCoursePage extends StatefulWidget {
  final int categoryNum;
  final String categoryName, instructorName;

  const SpecificCoursePage({
    Key? key,
    required this.categoryNum,
    required this.categoryName,
    required this.instructorName,
  }) : super(key: key);

  @override
  _SpecificCoursePageState createState() => _SpecificCoursePageState();
}

class _SpecificCoursePageState extends State<SpecificCoursePage> {
  late Timer myTimer;

  @override
  void initState() {
    super.initState();
    // The following line will enable the Android and iOS wakelock.
    Wakelock.enable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    PostsCubit postsCubit = PostsCubit.instance(context);
    LoginCubit loginCubit = LoginCubit.instance(context);
    VerifyVideoCubit verifyVideoCubit = VerifyVideoCubit.instance(context);

    postsCubit.fetchPosts(
      context,
      verifyVideoCubit,
      loginCubit.wpUser!.id!,
      paramsPostList: ParamsPostList(
          context: WordPressContext.view,
          orderBy: PostOrderBy.date,
          order: Order.asc,
          postStatus: PostPageStatus.publish,
          // perPage: 100,
          includeCategories: [widget.categoryNum]),
    );
    Workmanager()
        .initialize(
      callbackDispatcher,
      // isInDebugMode: true,
    )
        .then((value) {

      Workmanager().registerPeriodicTask(
          "${widget.categoryName}", notificationTask,
          frequency: Duration(minutes: 600),
          existingWorkPolicy: ExistingWorkPolicy.append,
          inputData: {
            'categoryNum': widget.categoryNum,
            'categoryName': widget.categoryName,
            'userName': LoginCubit.instance(context).wpUser!.username,
          }).then((value) {
        print('registered task: ${widget.categoryName}');
      });
    });

    myTimer = Timer.periodic(Duration(seconds: 900), (timer) {
      print('Ticks: ${timer.tick}');
      print('Passed 15 min, update lessons');
      updateLessons();
    });
  }

  @override
  void dispose() {
    myTimer.cancel();
    super.dispose();
  }

  Future<void> updateLessons() async {
    print('updateLessons is called');
    VerifyVideoCubit verifyVideoCubit = VerifyVideoCubit.instance(context);
    PostsCubit postsCubit = PostsCubit.instance(context);
    LoginCubit loginCubit = LoginCubit.instance(context);

    postsCubit.updatePosts(context, verifyVideoCubit, loginCubit.wpUser!.id!,
        paramsPostList: ParamsPostList(
            context: WordPressContext.view,
            orderBy: PostOrderBy.date,
            order: Order.asc,
            postStatus: PostPageStatus.publish,
            perPage: 100,
            includeCategories: [widget.categoryNum]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 5),
        child: BlocConsumer<PostsCubit, PostsStates>(
            listener: (BuildContext context, PostsStates state) {},
            builder: (BuildContext context, PostsStates state) {
              if (state is PostsStarted) {
                return Center(child: CircularProgressIndicator());
              } else if (state is PostsFinishedSuccessfully) {
                List<Post> myPostList = state.postsList.where((element) {
                  if (element.categoryIDs!.contains(widget.categoryNum)) {
                    return true;
                  } else {
                    return false;
                  }
                }).toList();
                PostsCubit postsCubit = PostsCubit.instance(context);

                return ListView.builder(
                    itemCount: myPostList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Post wppost = state.postsList[index];
                      return BlocConsumer<VerifyVideoCubit, VerifyVideoStates>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            return BlocConsumer<VerifyVideoCubit,
                                    VerifyVideoStates>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  return PostTile(
                                    post: wppost,
                                    categoryName: widget.categoryName,
                                    instructorName: widget.instructorName,
                                    imageApiUrl: (wppost.featuredMedia == null)
                                        ? 'https://speedandsuccessphone.website/draft/old/wp-content/uploads/2021/04/cropped-New-Project-1-1.png'
                                        : wppost.featuredMedia!.sourceUrl!,
                                    excerpt: wppost.excerpt!.rendered!,
                                    title: wppost.title!.rendered!,
                                    desc: wppost.content!.rendered!,
                                    pageUrl: wppost.link!,
                                    content: wppost.content!.rendered!,
                                    additionalInfo: postsCubit
                                        .postsAdditionalInfo!.additionalInfoList
                                        .where((element) =>
                                            element.post_id == wppost.id)
                                        .first,
                                    categoryNum: widget.categoryNum,
                                    //   pageUrl: 'https://speedandsuccessphone.website/draft/old/lesson-1-part-1-pricing-final-product/'
                                  );
                                });
                          });
                    });
              } else {
                return Center(
                  child: Container(
                    color: Colors.transparent,
                    height: 100,
                    child: Text(
                      'Error occurred while loading lessons,\nplease try again later ..',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
