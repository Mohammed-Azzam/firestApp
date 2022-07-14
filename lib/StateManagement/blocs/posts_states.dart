part of 'posts_cubit.dart';

abstract class PostsStates {
  const PostsStates();
}

class PostsStateInitial extends PostsStates {}

class PostsStarted extends PostsStates {}

class PostsFinishedSuccessfully extends PostsStates {
  List<Post> postsList;

  PostsFinishedSuccessfully({required this.postsList});
}

class PostsFinishedWithError extends PostsStates {}
