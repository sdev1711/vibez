# vibez

A project created in flutter using GetX and Bloc Cubit.

## Getting Started

Vibez is a dynamic social media platform designed for seamless connection and engagement.
Users can share their thoughts and moments through posts, photos, and stories, allowing others to like, comment, and share.
The platform includes a chat feature for real-time conversations, a followers/following system for personalized feeds,
and a discoverable feed showcasing public posts. Whether you want to stay connected, express yourself, or explore trending
content, App Name brings people together in an interactive and engaging way.

## Features

- User Authentication** (Firebase Auth)
- Chat System** (Real-time messaging with Firebase)
- Photo & Video Sharing** (Upload, view, and interact with posts)
- Like, Comment & Share** (Engagement features for posts)
- Story Feature** (24-hour disappearing stories)
- Followers & Following System** (Manage social connections)
- Feed Section** (View posts from non-private accounts)
- Edit Profile** (Update user details)
- Multi-language Support** (Localized content)
- Dark & Light Mode Support**
- Common Widgets** (Reusable UI components)
- Theming System** (Consistent UI with dynamic theme switching)
- Storage Management** (Efficient media storage)
- Routing System** (Navigation with GetX & BLoC Cubit)
- State Management** (GetX & Bloc Cubit)
- API Handling** (Dio & HTTP with managed request-response-error structure)
- Push Notifications** (Awesome Notifications & Firebase Messaging)
- ChatBot** (Gemini Api Key)

##  Folder Structure

lib/
│── api_service/          # API handling & network requests
│── app/                  # Application-level configuration & initialization
│── controllers/          # GetX controllers for managing state
│── cubit/                # BLoC Cubit state management
│── database/             # Local database setup (if needed)
│── drawer/               # Sidebar navigation components
│── flavour/              # Environment configurations (Development, Production)
│── generated/            # Auto-generated files (Localization, Assets)
│── models/               # Data models for API responses & local usage
│── repository/           # Data repository (Managing post functionalities)
│── screens/              # UI screens & pages
│── services/             # Third-party service integrations (story, notifications, etc.)
│── string_validation/    # Input validation helpers
│── utils/                # Utility functions & constants
│── widgets/              # Common reusable widgets
│── firebase_options.dart # Firebase initialization settings
│── main.dart             # Application entry point

---

## 📦 Dependencies

- cupertino_icons: ^1.0.8
- google_fonts: ^4.0.4
- get: ^4.6.6
- shared_preferences: ^2.3.5
- smooth_page_indicator: ^1.2.0+3
- flutter_screenutil: ^5.9.3
- flutter_svg: ^2.0.9
- firebase_core: ^3.10.1
- firebase_auth: ^5.4.1
- cloud_firestore: ^5.6.1
- firebase_messaging: ^15.2.0
- firebase_analytics: ^11.4.0
- awesome_notifications: ^0.10.0
- fluttertoast: ^8.2.10
- flutter_bloc: ^9.1.0
- bloc: ^9.0.0
- equatable: ^2.0.7
- firebase_database: ^11.3.1
- dio: ^5.7.0
- http: ^0.13.6
- intl: ^0.19.0
- shimmer: ^3.0.0
- image_picker: ^1.1.2
- firebase_storage: ^12.4.1
- timeago: ^3.7.0
- emoji_picker_flutter: ^4.3.0
- cached_network_image: ^3.3.1
- photo_view: ^0.15.0
- googleapis_auth: ^1.4.1
- image_gallery_saver_plus: ^3.0.5
- rxdart: ^0.27.7
- share_plus: ^10.1.4
- video_player: ^2.9.3
- chewie: ^1.10.0
- flutter_staggered_grid_view: ^0.7.0
- flutter_webrtc: ^0.12.12
- socket_io_client: ^3.0.2
- permission_handler: ^11.4.0
- pinput: ^5.0.1
- story_view: ^0.16.5

### Localization :

* For translations will use here [get_cli](https://pub.dev/packages/get_cli)
* Create your language json files inside assets/locales folder as below:


    |- assets/
        |-locales/
            |- en.json
            |- gu.json
            |- hi.json


    - Here file name should be in the language code as defined above for English,Hindi and Gujarati.

* Define your whole app strings into this json files as per the language.

* To install get_cli execute below commands one by one:

1. dart pub global activate get_cli
2. flutter pub global activate get_cli

* Now will generate string keys using below command, that will generate locales.g.dart file inside
  out lib folder.

  get generate locales assets/locales

* After this define translationsKeys in our main app which is located inside main.dart.

        GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translationsKeys: AppTranslation.translations,
          locale: initialLocale,
          fallbackLocale: const Locale('en', 'US'),
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: initialThemeMode,
          getPages: AppRoutes.getPages,
          initialRoute: initialRoute,
        ),


* Now in whole app use translations string like this -> LocaleKeys.follow.tr:

        Text(LocaleKeys.follow.tr, 
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: AppFontWeight.bold, color: AppColors.colorBlack)),


* So, here as written in above code AppTranslation & LocaleKeys this both are generated class
  and located inside lib/generated/locales.g.dart.
* Do not change anything inside this generated files, if you want to add new strings then you can
  add into your json files which are located inside assets/locales/ and then generate
  new LocaleKeys for that.


    
