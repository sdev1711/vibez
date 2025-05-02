import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/bottom_nav_post/bottom_nav_post_cubit.dart';
import 'package:vibez/Cubit/chat_screen_appbar/chat_appbar_cubit.dart';
import 'package:vibez/Cubit/chatbot/chatbot_cubit.dart';
import 'package:vibez/Cubit/document_download_cubit/document_download_cubit.dart';
import 'package:vibez/Cubit/emoji/emoji_cubit.dart';
import 'package:vibez/Cubit/feed_post/feed_post_cubit.dart';
import 'package:vibez/Cubit/message_input/message_input_cubit.dart';
import 'package:vibez/Cubit/post/image_picker_cubit/image_picker_cubit.dart';
import 'package:vibez/Cubit/private_account_switch/private_account_switch_cubit.dart';
import 'package:vibez/Cubit/search/search_cubit.dart';
import 'package:vibez/Cubit/search_field_cubit/search_field_cubit.dart';
import 'package:vibez/Cubit/send_receive_chat_time/send_receive_chat_cubit.dart';
import 'package:vibez/Cubit/user/user_cubit.dart';
import 'package:vibez/Cubit/video_visibility/video_visibility.dart';
import 'package:vibez/Cubit/zoom_image/zoom_cubit.dart';
import 'package:vibez/repository/post_repository.dart';
import 'package:vibez/services/notification_services.dart';
import 'package:vibez/services/story/story_service.dart';
import 'Cubit/auth/auth_cubit.dart';
import 'Cubit/feed_search/feed_search_cubit.dart';
import 'Cubit/follow_request/follow_request_cubit.dart';
import 'Cubit/post/post_cubit.dart';
import 'Cubit/profile_bio/profile_bio_cubit.dart';
import 'Cubit/user_profile_data/user_profile_cubit.dart';
import 'Flavour/config.dart';
import 'app/app_route.dart';
import 'app/colors.dart';
import 'controllers/bottom_navigation_controller.dart';
import 'database/shared_preference.dart';
import 'firebase_options.dart';
import 'generated/locales.g.dart';

Future<void> initApp({Flavour? appFlavour}) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (appFlavour == null) {
    throw Exception("App flavor must not be null!");
  }
  await SharedPrefs.init();
  ThemeMode initialThemeMode = getStoredThemeMode();
  Config.appFlavour = appFlavour;
  Get.put(AppColors());
  String? languageCode = SharedPrefs.getLanguage();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initializeNotifications();
  await StoryService().deleteExpiredStories();
  Locale initialCode = languageCode != null
      ? Locale(languageCode, languageCode == 'en' ? 'US' : 'IND')
      : Locale('en', 'US');
  Get.put(BottomNavController());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp(
      initialThemeMode: initialThemeMode,
      initialLocale: initialCode,
      initialRoute: AppRoutes.initialRoute,
    ));
  });
}

ThemeMode getStoredThemeMode() {
  bool? isDarkMode = SharedPrefs.getThemeMode();

  if (isDarkMode == null) {
    return ThemeMode.system;
  }
  return isDarkMode ? ThemeMode.dark : ThemeMode.light;
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.initialRoute,
    this.initialThemeMode = ThemeMode.system,
    this.initialLocale = const Locale('en', 'US'),
  });
  final String initialRoute;
  final ThemeMode initialThemeMode;
  final Locale initialLocale;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(312, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (BuildContext context) => AuthCubit(),
          ),
          BlocProvider<UserCubit>(
            create: (BuildContext context) => UserCubit(),
          ),
          BlocProvider<SearchCubit>(
            create: (BuildContext context) => SearchCubit(),
          ),
          BlocProvider<MessageInputCubit>(
            create: (BuildContext context) => MessageInputCubit(),
          ),
          BlocProvider<SearchFieldCubit>(
            create: (BuildContext context) => SearchFieldCubit(),
          ),
          BlocProvider<TimeCubit>(
            create: (context) => TimeCubit(),
          ),
          BlocProvider<EmojiCubit>(
            create: (context) => EmojiCubit(),
          ),
          BlocProvider<ChatAppbarCubit>(
            create: (context) => ChatAppbarCubit(),
          ),
          BlocProvider<SwitchCubit>(
            create: (context) => SwitchCubit()..fetchInitialState(),
          ),
          BlocProvider<FollowRequestCubit>(
            create: (context) => FollowRequestCubit()..listenToFollowRequests(),
          ),
          BlocProvider<FeedSearchCubit>(
            create: (context) => FeedSearchCubit(),
          ),
          BlocProvider<UserProfileCubit>(
            create: (context) => UserProfileCubit()..fetchUserProfile(),
          ),
          BlocProvider<PostCubit>(
            create: (context) => PostCubit(
              postRepository: PostRepository(),
            ),
          ),
          BlocProvider<ImagePickerCubit>(
            create: (context) => ImagePickerCubit(),
          ),
          BlocProvider<FeedPostCubit>(
            create: (context) => FeedPostCubit(
              postRepository: PostRepository(),
            ),
          ),
          BlocProvider<ChatBotCubit>(
            create: (context) => ChatBotCubit(),
          ),
          BlocProvider<ZoomCubit>(
            create: (context) => ZoomCubit(),
          ),
          BlocProvider<VideoVisibilityCubit>(
            create: (context) => VideoVisibilityCubit(),
          ),
          BlocProvider<ProfileBioCubit>(
            create: (context) => ProfileBioCubit(),
          ),
          BlocProvider<DocumentDownloadCubit>(
            create: (context) => DocumentDownloadCubit(),
          ),
          BlocProvider<BottomNavCubit>(
            create: (context) => BottomNavCubit(),
          ),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translationsKeys: AppTranslation.translations,
          locale: widget.initialLocale,
          fallbackLocale: const Locale('en', 'US'),
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: widget.initialThemeMode,
          getPages: AppRoutes.getPages,
          initialRoute: widget.initialRoute,
        ),
      ),
    );
  }
}
