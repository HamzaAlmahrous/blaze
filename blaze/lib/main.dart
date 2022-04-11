import 'package:blaze/components/const.dart';
import 'package:blaze/helpers/cubits/social_cubit.dart';
import 'package:blaze/helpers/cubits/social_state.dart';
import 'package:blaze/views/edit_profile/edit_profile.dart';
import 'package:blaze/views/login/login_screen.dart';
import 'package:blaze/views/post/post_screen.dart';
import 'package:blaze/views/register/register_screen.dart';
import 'package:blaze/views/search/search_screen.dart';
import 'package:blaze/views/settings/settings_screen.dart';
import 'package:blaze/views/social_layout/social_layout.dart';
import 'package:blaze/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/themes.dart';
import 'helpers/bloc_observer.dart';
import 'helpers/local/chache_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  //foreground fcm
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
  });

  //when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
  });

  //background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  await CacheHelper.init();

  //bool? onBoarding;
  //onBoarding = CacheHelper.getData(key: 'onBoarding');
  uId = CacheHelper.getData(key: 'uId');
  lang = CacheHelper.getData(key: 'lang');
  lang ??= 'en';
  //print(uId);

  Widget startWidget = Wrapper.start(uId: uId);

  BlocOverrides.runZoned(
    () {
      runApp(
        MyApp(startWidget: startWidget),
      );
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({Key? key, required this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => SocialCubit()..getAllUsers()..getPosts()..getUserData()..getFollowers(),
        )
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme(),
              darkTheme: darkTheme(),
              themeMode: ThemeMode.light,
              home: startWidget,
              routes: {
                '/login': (context) => SocialLogin(),
                '/register': (context) => RegisterScreen(),
                '/home': (context) => SocialLayout(),
                '/new_post': (context) => const NewPostScreen(),
                '/edit_profile':(context) => const EditProfileScreen(),
                '/search':(context) => const SearchScreen(),
                '/settings':(context) => const SettingsScreen(),
              },
            );
          }),
    );
  }
}
