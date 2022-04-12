abstract class SocialStates {}

///General States
class InitialState extends SocialStates {}

class ChangeModeState extends SocialStates {}

class SocialChangeNavState extends SocialStates {}

//user
class SocialLoadingUserState extends SocialStates {}

class SocialSuccessUserState extends SocialStates {}

class SocialErrorUserState extends SocialStates {
  final String error;
  SocialErrorUserState(this.error);
}

//profile

class SocialImagePickedSuccessState extends SocialStates {}

class SocialImagePickedErrorState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}

class SocialUserUpdateErrorState extends SocialStates {}

class SocialUserUpdateSuccessState extends SocialStates {}

class SocialUploadImageErrorState extends SocialStates {}

//post

class SocialPostImagePickedSuccessState extends SocialStates {}

class SocialPostImageRemovedSuccessState extends SocialStates {}

class SocialPostImagePickedErrorState extends SocialStates {}

class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialDeletePostErrorState extends SocialStates {}

class SocialDeletePostSuccessState extends SocialStates {}


//posts
class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  final String error;
  SocialGetPostsErrorState(this.error);
}

//like post

class SocialLikePostsSuccessState extends SocialStates {}

class SocialLikePostsErrorState extends SocialStates {
  final String error;
  SocialLikePostsErrorState(this.error);
}

//comment post

class SocialCommentPostsSuccessState extends SocialStates {}

class SocialCommentPostsErrorState extends SocialStates {
  final String error;
  SocialCommentPostsErrorState(this.error);
}

class SocialDeleteCommentPostsSuccessState extends SocialStates {}

class SocialDeleteCommentPostsErrorState extends SocialStates {
  final String error;
  SocialDeleteCommentPostsErrorState(this.error);
}

class SocialCommentImagePickedSuccessState extends SocialStates {}

class SocialCommentImageRemovedSuccessState extends SocialStates {}

class SocialCommentImagePickedErrorState extends SocialStates {}

class SocialGetCommentsLoadingState extends SocialStates {}

class SocialGetCommentsSuccessState extends SocialStates {}

class SocialGetCommentsErrorState extends SocialStates {
  final String error;
  SocialGetCommentsErrorState(this.error);
}

//users
class SocialGetAllUsersLoadingState extends SocialStates {}

class SocialGetAllUsersSuccessState extends SocialStates {}

class SocialGetAllUsersErrorState extends SocialStates {
  final String error;
  SocialGetAllUsersErrorState(this.error);
}

// message

class SocialGetMessageSuccessState extends SocialStates {}

class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {
  final String error;
  SocialSendMessageErrorState(this.error);
}


//FAB visibilit

class SocialHomeFabShowState extends SocialStates {}

//refersh

class Loaded extends SocialStates {}

class Loading extends SocialStates{}

//follow

class SocialFollowSuccessState extends SocialStates {}

class SocialFollowErrorState extends SocialStates {
  final String error;
  SocialFollowErrorState(this.error);
}

class SocialUnfollowSuccessState extends SocialStates {}

class SocialUnFollowErrorState extends SocialStates {
  final String error;
  SocialUnFollowErrorState(this.error);
}

class SocialGetFollowersLoadingState extends SocialStates {}

class SocialGetFollowersSuccessState extends SocialStates {}

class SocialGetFollowersErrorState extends SocialStates {
  final String error;
  SocialGetFollowersErrorState(this.error);
}


//user post 

class SocialGetUserPostsLoadingState extends SocialStates {}

class SocialGetUserPostsSuccessState extends SocialStates {}

class SocialGetUserPostsErrorState extends SocialStates {
  final String error;
  SocialGetUserPostsErrorState(this.error);
}

//search

class SocialSearchLoadingState extends SocialStates {}

class SocialSearchSuccessState extends SocialStates {}

class SocialSearchErrorState extends SocialStates {
  final String error;
  SocialSearchErrorState(this.error);
}

//logout

class SignOutLoadingState extends SocialStates {}

class SignOutSuccessState extends SocialStates {}

class SignOutErrorState extends SocialStates {
  final String error;
  SignOutErrorState(this.error);
}

//theme

class SocialAppChangeModeState extends SocialStates {}

//lang

class ChangeLanguageState extends SocialStates {}


