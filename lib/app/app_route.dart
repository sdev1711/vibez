import 'package:get/get.dart';
import 'package:vibez/screens/chat_screen/chat_screen.dart';
import 'package:vibez/screens/chatbot/chatbot_screen.dart';
import 'package:vibez/screens/clips/clip_screen.dart';
import 'package:vibez/screens/feed/feed.dart';
import 'package:vibez/screens/follow/followers.dart';
import 'package:vibez/screens/follow/following.dart';
import 'package:vibez/screens/forgot_password/forgot_password.dart';
import 'package:vibez/screens/home/home_screen.dart';
import 'package:vibez/screens/login/login_screen.dart';
import 'package:vibez/screens/main/main_screen.dart';
import 'package:vibez/screens/messages/messages_screen.dart';
import 'package:vibez/screens/notifications/notifications_screen.dart';
import 'package:vibez/screens/post/add_post/add_post_screen.dart';
import 'package:vibez/screens/post/comment/comment_screen.dart';
import 'package:vibez/screens/post/post_view/feed_post_view.dart';
import 'package:vibez/screens/post/post_view/post_view.dart';
import 'package:vibez/screens/post/add_post/add_clip.dart';
import 'package:vibez/screens/post/select_post_type/select_post_type.dart';
import 'package:vibez/screens/search/search_screen.dart';
import 'package:vibez/screens/signup/signUp_screen.dart';
import 'package:vibez/screens/splash_screen/splash_screen.dart';
import 'package:vibez/screens/story/upload_story/upload_story.dart';
import 'package:vibez/screens/story/view_story/story_view.dart';
import 'package:vibez/screens/user_account/user_account.dart';
import 'package:vibez/screens/user_profile/edit_profile.dart';
import 'package:vibez/screens/user_profile/profile_screen.dart';
import 'package:vibez/screens/user_profile/other_user_profile_screen.dart';

class AppRoutes{
  static const String initialRoute ="/";
  static const String homeScreen="/HomeScreen";
  static const String onboardingScreen="/onBoarding";
  static const String loginScreen="/loginScreen";
  static const String signUpScreen="/signUpScreen";
  static const String mainScreen="/mainScreen";
  static const String profileScreen="/profileScreen";
  static const String otherUserProfileScreen="/otherUserProfileScreen";
  static const String editProfileScreen="/editProfileScreen";
  static const String messageScreen="/messageScreen";
  static const String chatScreen="/chatScreen";
  static const String notificationsScreen="/notificationsScreen";
  static const String userAccountScreen="/userAccountScreen";
  static const String followingScreen="/followingScreen";
  static const String followersScreen="/followersScreen";
  static const String postViewScreen="/postViewScreen";
  static const String commentScreen="/commentScreen";
  static const String feedScreen="/feedScreen";
  static const String searchScreen="/searchScreen";
  static const String forgotPassword="/forgotPassword";
  static const String uploadStory="/uploadStory";
  static const String storyViewerScreen="/storyViewerScreen";
  static const String storyUploadScreen="/storyUploadScreen";
  static const String chatBotScreen="/chatBotScreen";
  static const String addClipScreen="/addClipScreen";
  static const String clipViewScreen="/clipViewScreen";
  static const String feedPostViewScreen="/feedPostViewScreen";
  static const String selectPostTypeScreen="/selectPostTypeScreen";

  static final List<GetPage> getPages=  [
    GetPage(name: AppRoutes.initialRoute,
        page: ()=> SplashScreen(),
    ),
    // GetPage(name: AppRoutes.onboardingScreen,
    //     page: ()=> OnBoardingScreen(),
    // ),
    GetPage(name: AppRoutes.loginScreen,
      page: ()=> LoginScreen(),
    ),
    GetPage(name: AppRoutes.signUpScreen,
      page: ()=> SignupScreen(),
    ),
    GetPage(name: AppRoutes.homeScreen,
      page: ()=> HomeScreen(),
    ),
    GetPage(name: AppRoutes.mainScreen,
      page: ()=> MainScreen(),
    ),
    GetPage(name: AppRoutes.profileScreen,
      page: ()=> ProfileScreen(),
    ),
    GetPage(name: AppRoutes.editProfileScreen,
      page: ()=> EditProfile(),
    ),
    GetPage(name: AppRoutes.messageScreen,
      page: ()=> MessagesScreen(),
    ),
    GetPage(name: AppRoutes.chatScreen,
      page: ()=> ChatScreen(),
    ),
    GetPage(name: AppRoutes.otherUserProfileScreen,
      page: ()=> OtherUserProfileScreen(),
    ),
    GetPage(name: AppRoutes.userAccountScreen,
      page: ()=> UserAccount(),
    ),
    GetPage(name: AppRoutes.notificationsScreen,
      page: ()=> NotificationsScreen(),
    ),
    GetPage(name: AppRoutes.followersScreen,
      page: ()=> Followers(),
    ),
    GetPage(name: AppRoutes.followingScreen,
      page: ()=> Following(),
    ),
    GetPage(name: AppRoutes.postViewScreen,
      page: ()=> PostView(),
    ),
    GetPage(name: AppRoutes.commentScreen,
      page: ()=> CommentScreen(),
    ),
    GetPage(name: AppRoutes.feedScreen,
      page: ()=> FeedScreen(),
    ),
    GetPage(name: AppRoutes.searchScreen,
      page: ()=> SearchScreen(),
    ),
    GetPage(name: AppRoutes.forgotPassword,
      page: ()=> ForgotPassword(),
    ),
    GetPage(name: AppRoutes.uploadStory,
      page: ()=> UploadStoryScreen(),
    ),
    GetPage(name: AppRoutes.storyViewerScreen,
      page: ()=> StoryViewerScreen(),
    ),
    GetPage(name: AppRoutes.storyUploadScreen,
      page: ()=> UploadStoryScreen(),
    ),
    GetPage(name: AppRoutes.chatBotScreen,
      page: ()=> ChatBotScreen(),
    ),
    GetPage(name: AppRoutes.addClipScreen,
      page: ()=> AddClipScreen(),
    ),
    GetPage(name: AppRoutes.clipViewScreen,
      page: ()=> ClipScreen(),
    ),
    GetPage(name: AppRoutes.feedPostViewScreen,
      page: ()=> FeedPostView(),
    ),
    GetPage(name: AppRoutes.selectPostTypeScreen,
      page: ()=> SelectPostType(),
    ),
  ];
}
