import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_and_success/DataModels/posts_additional_info.dart';
import 'package:speed_and_success/DataModels/single_post_additional_info.dart';
import 'package:speed_and_success/StateManagement/blocs/verify_video_cubit.dart';
import 'package:speed_and_success/Widgets/common/dialogs.dart';
import 'package:speed_and_success/Widgets/common/rounded_button.dart';
import 'package:speed_and_success/constants.dart';
import 'package:http/http.dart' as http;
import 'package:speed_and_success/flutter_wordpress-0.2.1/flutter_wordpress.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/schemas/post.dart';
import 'dart:convert';

import '../../constants.dart';

part 'posts_states.dart';

class PostsCubit extends Cubit<PostsStates> {
  PostsCubit() : super(PostsStateInitial());

  List<Post>? postsList;
  List<int> postIds = [];
  PostsAdditionalInfo? postsAdditionalInfo;

  static PostsCubit instance(BuildContext context) => BlocProvider.of(context);

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

  Future<void> fetchPosts(
      BuildContext context, VerifyVideoCubit verifyVideoCubit, int userId,
      {ParamsPostList? paramsPostList}) async {
    bool internetIsConnected = await internetChecks(context);
    if (internetIsConnected) {
      emit(PostsStarted());

      ParamsPostList paramList;
      if (paramsPostList != null) {
        paramList = paramsPostList;
      } else {
        paramList = ParamsPostList(
            context: WordPressContext.view,
            order: Order.asc,
            orderBy: PostOrderBy.date,
            perPage: 100);
      }

      Future<List<Post>> posts = myWordPress.fetchPosts(
        postParams: paramList,
        // fetchAuthor: true,
        // fetchFeaturedMedia: true,
        // fetchCategories: true,
      );
      posts.then((list) {
        print('length of posts list is ${list.length}');
        postsList = list;
        postIds = [];
        postsList!.forEach((myPost) {
          List cats = [];
          postIds.add(myPost.id!);
          if (myPost.categories != null) {
            myPost.categories!.forEach((category) {
              cats.add(category.name);
            });
          }
          print(
              'id: ${myPost.id}, title: ${myPost.title}, slug: ${myPost.slug}, category:$cats , ');
        });
        _addPostsRecords(context, userId).then((value) {
          _getPostsAdditionalInfo(context, userId, verifyVideoCubit)
              .then((value) {
            emit(PostsFinishedSuccessfully(postsList: postsList!));
          }).catchError((err) {
            print('Error while fetching posts: $err');
            emit(PostsFinishedWithError());
          });
        }).catchError((err) {
          print('Error while fetching posts: $err');
          emit(PostsFinishedWithError());
        });
      }).catchError((err) {
        print('Error while fetching posts: $err');
        emit(PostsFinishedWithError());
      });
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

  Future<void> updatePosts(
      BuildContext context, VerifyVideoCubit verifyVideoCubit, int userId,
      {required ParamsPostList? paramsPostList}) async {
    bool internetIsConnected = await internetChecks(context);
    if (internetIsConnected) {
      ParamsPostList paramList;
      if (paramsPostList != null) {
        paramList = paramsPostList;
      } else {
        paramList = ParamsPostList(
            context: WordPressContext.view,
            order: Order.asc,
            orderBy: PostOrderBy.date,
            perPage: 100);
      }

      Future<List<Post>> posts = myWordPress.fetchPosts(
        postParams: paramList,
        // fetchAuthor: true,
        // fetchFeaturedMedia: true,
        // fetchCategories: true,
      );
      posts.then((list) {
        print('length of posts list is ${list.length}');
        postsList = list;
        postIds = [];
        postsList!.forEach((myPost) {
          List cats = [];
          postIds.add(myPost.id!);
          if (myPost.categories != null) {
            myPost.categories!.forEach((category) {
              cats.add(category.name);
            });
          }
          print(
              'id: ${myPost.id}, title: ${myPost.title}, slug: ${myPost.slug}, category:$cats , ');
        });
        _addPostsRecords(context, userId).then((value) {
          _getPostsAdditionalInfo(context, userId, verifyVideoCubit)
              .then((value) {
            emit(PostsFinishedSuccessfully(postsList: postsList!));
          });
        });
      });
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

  Future<void> _addPostsRecords(BuildContext context, int userId) async {
    String idsString = '';
    postIds.forEach((element) {
      idsString += element.toString();
      idsString += ',';
    });
    idsString =
        idsString.substring(0, idsString.length - 1); //remove the last ,
    final String url =
        'https://speedandsuccessphone.website/api.php?cmd=insert_video_data&user_id=$userId&post_id=$idsString';
    print('add video records');
    print(url);
    final response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      // List<dynamic> l = json.decode(response.body)['response'];
      // l.forEach((element) {
      //   // print('inserted post: ${element['post_id']}');
      // });
    } else {
      print('error fetching Video model  \n use the no resolution');
      throw (Exception());
    }
  }

  Future<String> getPostStatus(int userId, int postId) async {
    final String url =
        'https://speedandsuccessphone.website/api.php?cmd=get_video_counter&user_id=$userId&post_id=$postId';
    print('get video counter');
    print(url);
    final response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      List<dynamic> l = json.decode(response.body)['response'];
      print('runtimeType: ${l[0].runtimeType}');
      return l[0]['text'];
    } else {
      print('error fetching post additional info');
      return 'fail';
    }
  }

  Future<void> _getPostsAdditionalInfo(BuildContext context, int userId,
      VerifyVideoCubit verifyVideoCubit) async {
    String idsString = '';
    postIds.forEach((element) {
      idsString += element.toString();
      idsString += ',';
    });
    idsString =
        idsString.substring(0, idsString.length - 1); //remove the last ,
    final String url =
        'https://speedandsuccessphone.website/api.php?cmd=get_video_counter&user_id=$userId&post_id=$idsString';
    print('get video counter');
    print(url);
    final response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      List<dynamic> l = json.decode(response.body)['response'];
      l.forEach((element) {
        print('runtimeType: ${element.runtimeType}');
      });

      postsAdditionalInfo =
          PostsAdditionalInfo.fromJson(json.decode(response.body));
      postsAdditionalInfo!.additionalInfoList
          .where((element) => element.status == 'continue')
          .forEach((element) {
        verifyVideoCubit.verifyVideoCounter(userId, element.post_id);
      });
    } else {
      postsAdditionalInfo = PostsAdditionalInfo.fromJson({
        {
          "response": [
            {"post_id": -1, "counter": 0, "limit_counter": 0, "text": "start"},
          ]
        }
      });

      print('error fetching post additional info');
      throw (Exception());
    }
  }

  void updateAdditionalInfoList(
    int postId,
    postAdditionalJson,
    // BuildContext context,
    // int userId,
    // VerifyVideoCubit verifyVideoCubit
  ) {
    int index = postsAdditionalInfo!.additionalInfoList
        .indexWhere((element) => element.post_id == postId);

    postsAdditionalInfo!.additionalInfoList.replaceRange(index, index + 1,
        [SinglePostAdditionalInfo.fromJson(postAdditionalJson)]);

    // _getPostsAdditionalInfo(context, userId, verifyVideoCubit).then((value) {
    //   emit(PostsFinishedSuccessfully(postsList: postsList!));
    // }).catchError((err) {
    //   print('Error while fetching posts: $err');
    //   emit(PostsFinishedWithError());
    // });
  }
}
