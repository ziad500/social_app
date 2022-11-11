import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/loginScreen/login_screen.dart';
import 'package:social_app/modules/newPost/new_post.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/network/cashe_helper.dart';

import '../../shared/components/components.dart';
import 'app_states.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(AppCubitInitialState());
  //ShopLoginModel? loginmodel;

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  void getUserDate() {
    emit(SocialGetUserLoadingState());
    if (uId != '' && uId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .get()
          .then((value) {
        userModel = UserModel.fromjson(value.data()!);
        print(value.data());
        emit(SocialGetUserSuccessState());
      }).catchError((error) {
        emit(SocialGetUserErrorState(error.toString()));
      });
    }
  }

  int currentIndex = 0;
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen()
  ];

  List<String> titles = ['Home', 'Chats', 'Add Post', 'Users', 'Settings'];

  void changeBottomNav(int index) {
    if (index == 1) {
      getAllUsers();
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    } else if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;

      emit(SocialChangeBottomNavState());
    }
  }

  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut();
    CasheHelper.saveData(key: 'uId', value: '');
    uId = CasheHelper.getData(key: 'uId');
    currentIndex = 0;
    print(uId);
/*     CasheHelper.saveData(key: 'uId', value: '');
 */
    navigateAndFinish(context, SocialLoginScreen());
    emit(SignOutState());
  }

  final ImagePicker picker = ImagePicker();
  File? profileImage;

  Future<void> getProfileImage() async {
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (image != null) {
      profileImage = File(image.path);

      emit(SocialProfileImagePickedSuccessState());
    } else {
      emit(SocialProfileImagePickedErrorState());
      print('no image selected');
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (image != null) {
      coverImage = File(image.path);

      emit(SocialCoverImagePickedSuccessState());
    } else {
      emit(SocialCoverImagePickedErrorState());
      print('no image selected');
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
    String? profile,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          profile: value,
        );

        //   print(value);
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
    String? cover,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(coverImage!.path).pathSegments.last}")
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone, bio: bio, cover: value);

        //   print(value);
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? profile,
    String? cover,
  }) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .update(UserModel(
                bio: bio,
                email: userModel!.email,
                cover: cover ?? userModel!.cover,
                image: profile ?? userModel!.image,
                isEmailVerified: false,
                uId: userModel!.uId,
                passsord: userModel!.passsord,
                name: name,
                phone: phone)
            .toMap())
        .then((value) {
      profileImage = null;
      coverImage = null;
      getUserDate();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImagePicked;

  Future<void> getPostImage() async {
    final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (image != null) {
      postImagePicked = File(image.path);

      emit(SocialPostImagePickedSuccessState());
    } else {
      emit(SocialPostImagePickedErrorState());
      print('no image selected');
    }
  }

  void uploadPostImage({
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("posts/${Uri.file(postImagePicked!.path).pathSegments.last}")
        .putFile(postImagePicked!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text, postImage: value);
        //   print(value);
      }).catchError((error) {
        emit(SocialCreatePostErrorState(error));
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error));
    });
  }

  void createPost({required String text, String? postImage}) {
    emit(SocialCreatePostLoadingState());
    FirebaseFirestore.instance
        .collection("posts")
        .add(PostModel(
                dateTime: DateFormat.yMMMd().format(DateTime.now()).toString() +
                    " at " +
                    DateFormat.jm().format(DateTime.now()).toString(),
                image: userModel!.image,
                name: userModel!.name,
                postImage: postImage ?? '',
                text: text,
                postId: "",
                uId: userModel!.uId)
            .toMap())
        .then((value) {
      FirebaseFirestore.instance.collection("posts").doc(value.id).set(
          PostModel(
                  dateTime:
                      DateFormat.yMMMd().format(DateTime.now()).toString() +
                          " at " +
                          DateFormat.jm().format(DateTime.now()).toString(),
                  image: userModel!.image,
                  name: userModel!.name,
                  postImage: postImage ?? '',
                  text: text,
                  postId: value.id,
                  uId: userModel!.uId)
              .toMap());
      postImagePicked = null;
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error));
    });
  }

  void removePostImage() {
    postImagePicked = null;
    emit(SocialremovePostImageState());
  }

  List<PostModel> posts = [];
  List<int> likes = [];

  void getPosts() {
    emit(SocialGetPostsLoadingState());
    if (uId != '' && uId != null) {
      FirebaseFirestore.instance.collection('posts').get().then((value) {
        for (var element in value.docs) {
          element.reference.collection('likes').get().then((value) {
            likes.add(value.docs.length);
            posts.add(PostModel.fromjson(element.data()));
            print(posts);
          }).catchError((error) {});
        }
        emit(SocialGetPostsSuccessState());
      }).catchError((error) {
        emit(SocialGetPostsErrorState(error));
      });
    }
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(uId)
        .set({'like': true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error));
    });
  }

  List<UserModel> users = [];
  void getAllUsers() {
    emit(SocialGetAllUsersLoadingState());
    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] != uId) {
          users.add(UserModel.fromjson(element.data()));
        }
      }
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUsersErrorState(error));
    });
  }

  void sendMessages({
    required String recieverId,
    required String text,
  }) {
    // set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .add(MessageModel(
                dateTime: Timestamp.now(),
                recieverId: recieverId,
                senderId: uId,
                text: text)
            .toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    // set reciever chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(recieverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(MessageModel(
                dateTime: Timestamp.now(),
                recieverId: recieverId,
                senderId: uId,
                text: text)
            .toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];
  void getMessages({
    required String recieverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(recieverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromjson(element.data()));
      }
      emit(SocialGetMessagesSuccessState());
    });
  }
}
