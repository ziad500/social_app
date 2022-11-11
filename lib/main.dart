import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/cubit/app_states.dart';
import 'package:social_app/layout/layout.dart';
import 'package:social_app/modules/loginScreen/cubit.dart';
import 'package:social_app/modules/loginScreen/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/network/bloc_observer.dart';
import 'package:social_app/shared/network/cashe_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:social_app/shared/network/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'package:social_app/styles/themes/themes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  //when the app is opened
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message}');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.body.toString()}');
    }
    showToast(text: 'on message', state: ToastStates.SUCCESS);
  });
  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    showToast(text: 'on Message Opened App', state: ToastStates.SUCCESS);

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.body.toString()}');
    }
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  DioHelper.init();
  await CasheHelper.init();

  Bloc.observer = MyBlocObserver();
  Widget widget;
  //CasheHelper.removeData(key: 'uId');
  uId = CasheHelper.getData(key: 'uId');
  //CasheHelper.removeData(key: 'uId');

  print(uId);
  if (uId != '' && uId != null) {
    widget = const SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) => SocialCubit()
                ..getUserDate()
                ..getPosts()),
        ],
        child: BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return MaterialApp(
                theme:
                    lighttheme /*  ThemeData(
                    primarySwatch: Colors.blue,
                    appBarTheme: const AppBarTheme(
                      actionsIconTheme: IconThemeData(color: Colors.black),
                      color: Colors.white,
                      elevation: 0.0,
                      titleTextStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    )
                    /* textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ), */
                    ),
              */
                ,
                debugShowCheckedModeBanner: false,
                home: startWidget,
              );
            }));
  }
}
