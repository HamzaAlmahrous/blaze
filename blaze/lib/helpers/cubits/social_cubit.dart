import 'dart:io';
import 'package:blaze/components/toast.dart';
import 'package:blaze/helpers/local/chache_helper.dart';
import 'package:blaze/models/comments.dart';
import 'package:blaze/models/message.dart';
import 'package:blaze/models/post.dart';
import 'package:blaze/views/chats/chats_screen.dart';
import 'package:blaze/views/profile/profile_screen.dart';
import 'package:blaze/views/users/users_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blaze/components/const.dart';
import 'package:blaze/models/user.dart';
import 'package:blaze/views/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'social_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(InitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUser user = SocialUser.empty();

  void getUserData() {
    emit(SocialLoadingUserState());
    print(uId);
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      //print(value.data());
      user = SocialUser.fromJson(value.data()!);
      emit(SocialSuccessUserState());
      print(user.uId);
      getUserPosts(id: user.uId);
    }).catchError((error) {
      print(error);
      emit(SocialErrorUserState(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    const HomeScreen(),
    const UsersScreen(),
    const ChatsScreen(),
    const ProfileScreen(),
  ];

  List<String> titles = ['Home', 'Chats', 'Users', 'Settings'];

  void changeNav(int index) {
    currentIndex = index;
    print(currentIndex);
    if (currentIndex == 3) {
      getUserData();
    }
    if (currentIndex == 1) {
      getAllUsers();
    }
    emit(SocialChangeNavState());
  }

  bool isFabVisible = true;
  void changeHomeFab(bool change) {
    isFabVisible = change;
    emit(SocialHomeFabShowState());
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialImagePickedErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //print(value);
        updateUser(name: name, phone: phone, bio: bio, profileImage: value);
        profileImage = null;
      }).catchError((error) {
        emit(SocialUploadImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //print(value);
        updateUser(name: name, phone: phone, bio: bio, coverImage: value);
        coverImage = null;
      }).catchError((error) {
        emit(SocialUploadImageErrorState());
        //print(error.toString());
      });
    }).catchError((error) {
      emit(SocialUploadImageErrorState());
      //print(error.toString());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? coverImage,
    String? profileImage,
  }) {
    emit(SocialUserUpdateLoadingState());
    SocialUser model = SocialUser(
        email: user.email,
        name: name,
        phone: phone,
        uId: user.uId,
        image: profileImage ?? user.image,
        bio: bio,
        followers: user.followers,
        cover: coverImage ?? user.cover);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uId)
        .update(model.toJson())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void uploadPostImage({
    required String text,
    required String dateTime,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text, dateTime: dateTime, postImage: value);
        //print(value);
        postImage = null;
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialPostImageRemovedSuccessState());
  }

  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  }) {
    emit(SocialUserUpdateLoadingState());
    SocialPost model = SocialPost(
      name: user.name,
      uId: user.uId,
      image: user.image,
      postImage: postImage ?? '',
      text: text,
      dateTime: dateTime,
      likes: 0,
      comments: 0,
    );
    var newPost = FirebaseFirestore.instance.collection('posts').doc();

    newPost.set(model.toJson()).then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });

    newPost.update({'pId': newPost.id}).then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void deletePost(SocialPost post) {
    if (post.uId == user.uId) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(post.pId)
          .delete()
          .then((value) {
        emit(SocialDeletePostSuccessState());
        showToast(
            text: 'posts deleted successfully', state: ToastState.SUCCESS);
      }).catchError((error) {
        emit(SocialDeletePostErrorState());
      });
    } else {
      showToast(text: 'you can\'t delete this post', state: ToastState.ERROR);
    }
  }

  List<SocialPost> posts = [];

  void getPosts() async {
    // FirebaseFirestore.instance.collection('users').doc(user.uId).collection('friends').get().then((value) {
    //   value.docs.forEach((element) {
    //     FirebaseFirestore.instance.collection('posts').where('uId', isEqualTo: element.id).get().then((value) => null);
    //   });
    // });
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      int i = 0;
      if (value.docs.isNotEmpty) posts = [];
      for (var element in value.docs) {
        posts.add(SocialPost.fromJson(element.data()));
        element.reference.collection('likes').get().then((value) {
          posts[i].likes = value.docs.length;
        }).catchError((error) {});
        i++;
      }
      print(posts.length);
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId, int likes, int index) async {
    final snapShot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(user.uId)
        .get();
    if (snapShot.exists) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(user.uId)
          .delete()
          .then((value) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({'likes': likes - 1});
        posts[index].likes = posts[index].likes! - 1;
        emit(SocialLikePostsSuccessState());
      }).catchError((error) {
        emit(SocialLikePostsErrorState(error));
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(user.uId)
          .set({
        'like': true,
      }).then((value) {
        FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({'likes': likes + 1});

        posts[index].likes = posts[index].likes! + 1;
        emit(SocialLikePostsSuccessState());
      }).catchError((error) {
        emit(SocialLikePostsErrorState(error));
      });
    }
  }

  File? commentImage;

  Future<void> getCommentImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialCommentImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCommentImagePickedErrorState());
    }
  }

  void removeCommentImage() {
    commentImage = null;
    emit(SocialPostImageRemovedSuccessState());
  }

  void addComment({
    required String text,
    required String postId,
    required dateTime,
  }) {
    if (commentImage != null) {
      firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(commentImage!.path).pathSegments.last}')
          .putFile(commentImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          SocialComment comment = SocialComment(
            uId: user.uId,
            dateTime: dateTime,
            name: user.name,
            image: user.image,
            text: text,
            commentImage: value,
          );
          var newComment = FirebaseFirestore.instance
              .collection('posts')
              .doc(postId)
              .collection('comments')
              .doc();

          newComment.set(comment.toJson()).then((value) {
            emit(SocialCommentPostsSuccessState());
          }).catchError((error) {
            emit(SocialCommentPostsErrorState(error));
          });

          newComment.update({'cId': newComment.id});
          commentImage = null;
        }).catchError((error) {
          emit(SocialCommentPostsErrorState(error));
        });
      }).catchError((error) {
        emit(SocialCommentPostsErrorState(error));
      });
    } else {
      SocialComment comment = SocialComment(
        uId: user.uId,
        dateTime: dateTime,
        name: user.name,
        image: user.image,
        text: text,
      );

      var newComment = FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc();

      newComment.set(comment.toJson()).then((value) {
        emit(SocialCommentPostsSuccessState());
      }).catchError((error) {
        emit(SocialCommentPostsErrorState(error));
      });
      print(newComment.id);

      newComment.update({'cId': newComment.id});
    }
  }

  void deleteComment(SocialComment comment, String postId) {
    if (comment.uId == user.uId) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(comment.cId)
          .delete()
          .then((value) {
        emit(SocialDeleteCommentPostsSuccessState());
      }).catchError((error) {
        emit(SocialDeleteCommentPostsErrorState(error));
      });
    }
  }

  List<SocialComment> comments = [];

  void getCommetns({required String postId}) {
    comments = [];
    emit(SocialGetCommentsLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        comments.add(SocialComment.fromJson(element.data()));
      });
      emit(SocialGetCommentsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetCommentsErrorState(error));
    });
  }

  List<SocialUser> allUsers = [];

  void getAllUsers() async {
    allUsers = [];
    emit(SocialGetAllUsersLoadingState());
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] == user.uId) {
          continue;
        } else {
          allUsers.add(SocialUser.fromJson(element.data()));
        }
      }

      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }

  void sendMessage(String receiverId, String dateTime, String text) {
    SocialMessage message = SocialMessage(
        reciverId: receiverId,
        dateTime: dateTime,
        senderId: user.uId,
        text: text);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error));
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(user.uId)
        .collection('messages')
        .add(message.toJson())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState(error));
    });
  }

  List<SocialMessage> messages = [];

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      for (var element in event.docs) {
        messages.add(SocialMessage.fromJson(element.data()));
      }
    });

    emit(SocialGetMessageSuccessState());
  }

  void refershPage(int index) {
    emit(Loading());
    if (index == 1) {
      getAllUsers();
    } else if (index == 2) {
      getFollowers();
    } else if (index == 0) {
      getPosts();
    } else if (index == 3) {
      getUserData();
    }

    emit(Loaded());
  }

  void follow(String followId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uId)
        .collection('friends')
        .doc(followId)
        .set({'follow': true}).then((value) {
      emit(SocialFollowSuccessState());
      getFollowers();
      FirebaseFirestore.instance
          .collection('users')
          .doc(followId)
          .get()
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .update({'followers': value.data()!['followers'] + 1});
      });
    }).catchError((error) {
      emit(SocialFollowErrorState(error));
    });
  }

  void unfollow(String followId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uId)
        .collection('friends')
        .doc(followId)
        .delete()
        .then((value) {
      emit(SocialUnfollowSuccessState());
      FirebaseFirestore.instance
          .collection('users')
          .doc(followId)
          .get()
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .update({'followers': value.data()!['followers'] - 1});
      });
      getFollowers();
    }).catchError((error) {
      emit(SocialUnFollowErrorState(error));
    });
  }

  List<SocialUser> followers = [];
  void getFollowers() async {
    followers = [];
    emit(SocialGetFollowersLoadingState());
    user.uId = uId!;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uId)
        .collection("friends")
        .get()
        .then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .get()
            .then((value) {
          followers.add(SocialUser.fromJson(value.data()!));
        });
      }
      emit(SocialGetFollowersSuccessState());
    }).catchError((error) {
      emit(SocialGetFollowersErrorState(error));
    });
  }

  List<SocialPost> userPosts = [];

  void getUserPosts({required id}) async {
    userPosts = [];
    emit(SocialGetUserPostsLoadingState());
    //print(id);
    int i = 0;
    FirebaseFirestore.instance
        .collection('posts')
        .where('uId', isEqualTo: id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        userPosts.add(SocialPost.fromJson(element.data()));
        element.reference.collection('likes').get().then((value) {
          posts[i].likes = value.docs.length;
        }).catchError((error) {});
        i++;
      }
    }).then((value) {
      print(userPosts);
      emit(SocialGetUserPostsSuccessState());
    }).catchError((error) {
      emit(SocialGetUserPostsErrorState(error));
    });
  }

  List<SocialUser> searchResualt = [];

  void search({required String s}) {
    emit(SocialSearchLoadingState());
    for (var element in allUsers) {
      //print(element.name.toLowerCase());
      //print(s.toLowerCase());
      if (element.name.toLowerCase().contains(s.toLowerCase())) {
        searchResualt.add(element);
      }
    }
    emit(SocialSearchSuccessState());
  }

  void saveImage(String imageUrl) async {
    // Uri imgeUri = Uri(scheme: 'https', path: imageUrl, host: 'firebasestorage.googleapis.com');
    // var response = await http.get(imgeUri);
    // Directory documentDirectory = await getApplicationDocumentsDirectory();
    // File file = File(join(documentDirectory.path, 'imagetest.png'));
    // file.writeAsBytesSync(response.bodyBytes);
  }

  
  void logOut(context) {
    emit(SignOutLoadingState());
    FirebaseAuth.instance.signOut().then((value) async {
      CacheHelper.removeData(key: 'uId');
      await FirebaseMessaging.instance.deleteToken();
      // await FirebaseFirestore.instance.collection('users').get().then((value) {
      //   value.docs.forEach((element) async {
      //     if (element.id == user.uId)
      //       element.reference.update({'token': null});
      //   });
      // });
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      emit(SignOutSuccessState());
    }).catchError((error) {
      emit(SignOutErrorState(error));
    });
  }
}
