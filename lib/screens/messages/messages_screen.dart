import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/search/search_cubit.dart';
import 'package:vibez/Cubit/search/search_state.dart';
import 'package:vibez/Cubit/search_field_cubit/search_field_cubit.dart';
import 'package:vibez/Cubit/search_field_cubit/search_field_state.dart';
import 'package:vibez/Cubit/send_receive_chat_time/send_receive_chat_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/call_model.dart';
import 'package:vibez/model/message_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/screens/call_screen.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_textfield.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool isShow = false;
  TextEditingController searchController = TextEditingController();
  UserModel? userModel;
  ApiService apiService = ApiService();
  @override
  void initState() {
    // String user = SharedPrefs.getUserData() ?? "";
    // Map<String, dynamic> userMap = jsonDecode(user);
    // userModel = UserModel.fromJson(userMap);

    super.initState();
  }

  Stream<CallModel?> getIncomingCall() {
    return ApiService.firestore
        .collection('calls')
        .where('receiverId',
            isEqualTo: ApiService.me.uid) // Change to your user ID
        .where('status', isEqualTo: 'ringing')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return CallModel.fromMap(snapshot.docs.first.data());
    });
  }

  void showIncomingCallDialog(BuildContext context, CallModel call) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Incoming Call"),
          content: Text("You have an incoming call from ${call.callerId}"),
          actions: [
            TextButton(
              onPressed: () async {
                // Accept the call
                await ApiService.firestore
                    .collection('calls')
                    .doc(call.channelId)
                    .update({'status': 'ongoing'});

                Navigator.of(context).pop(); // Close dialog

                // Navigate to Video Call Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VideoCallScreen(channelId: call.channelId),
                  ),
                );
              },
              child: Text("Accept"),
            ),
            TextButton(
              onPressed: () async {
                // Reject the call by deleting the Firestore entry
                await ApiService.firestore
                    .collection('calls')
                    .doc(call.channelId)
                    .delete();
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Reject"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    return GestureDetector(
      onTap: () {
        context.read<SearchFieldCubit>().toggleSearchVisibility(false);
        FocusScope.of(context).unfocus();
      },
      child: StreamBuilder<CallModel?>(
        stream: getIncomingCall(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            CallModel call = snapshot.data!;
            Future.microtask(() => showIncomingCallDialog(context, call));
          }
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: "Ask AI",
              backgroundColor: AppColors.to.contrastThemeColor,
              onPressed: () {
                Get.toNamed(AppRoutes.chatBotScreen);
              },
              child: ImageIcon(
                  AssetImage(ImagePath.chatbotIcon),
                color: AppColors.to.aiLightColor,
                size: 40,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            appBar: CommonAppBar(
              title: CommonSoraText(
                text: ApiService.me.username,
                color: AppColors.to.contrastThemeColor,
                textSize: 20,
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_rounded,
                    color: AppColors.to.contrastThemeColor),
              ),
            ),
            backgroundColor: AppColors.to.darkBgColor,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),

                      /// **Search Input Field**
                      BlocBuilder<SearchFieldCubit, SearchFieldState>(
                        builder: (context, state) {
                          final searchFieldCubit =
                              context.read<SearchFieldCubit>();
                          return Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: CommonTextField(
                                    controller: searchController,
                                    hintText: "${LocaleKeys.search.tr}...",
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    fillColor: AppColors.to.contrastThemeColor
                                        .withOpacity(0.5),
                                    maxLines: 1,
                                    textInputAction: TextInputAction.go,
                                    onChanged: (val) {
                                      searchCubit.searchUsers(val);
                                    },
                                    onTap: () {
                                      searchFieldCubit
                                          .toggleSearchVisibility(true);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: state.isShow ? 5 : 0.w,
                              ),
                              state.isShow
                                  ? CommonIconButton(
                                      iconData: Icons.close,
                                      size: 25,
                                      color: AppColors.to.contrastThemeColor,
                                      onTap: () {
                                        searchFieldCubit
                                            .toggleSearchVisibility(false);
                                        searchController.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                    )
                                  : SizedBox(),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 10.h),

                      /// **Listen to SearchCubit State**
                      BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                          if (state.isSearching) {
                            return state.userList.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Center(
                                      child: CommonSoraText(
                                        text:
                                            'No results found for "${searchController.text}"',
                                        color: AppColors.to.contrastThemeColor,
                                        textSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : buildUserList(state.userList);
                          } else {
                            return buildAllUsers();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Show All Users when No Search Query
  Widget buildAllUsers() {
    return StreamBuilder(
      stream: ApiService.getMyUsersId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.to.darkBgColor,
          ));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: CommonSoraText(
              text: LocaleKeys.noLoggedUser.tr,
              color: AppColors.to.contrastThemeColor,
            ),
          );
        }

        final users = snapshot.data?.docs;
        final userList =
            users?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];
        return buildUserList(userList);
      },
    );
  }

  /// Build User List View
  Widget buildUserList(List<UserModel> users) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return StreamBuilder<Map<String, MessageModel>>(
          stream: ApiService.getAllLastMessagesStream(users),
          builder: (context, snapshot) {
            final messageList = snapshot.data ?? {};
            if (messageList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 15.h,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Image(
                        image: AssetImage(ImagePath.noChatIcon),
                        height: 80.h,
                        color: AppColors.to.contrastThemeColor,
                      ),
                    ),
                    CommonSoraText(
                      text: "No recent chats yet",
                      color: AppColors.to.contrastThemeColor,
                      textSize: 20,
                    ),
                  ],
                ),
              );
            }
            // Sort users based on last message timestamp
            users.sort((a, b) {
              final lastMsgA =
                  int.tryParse(messageList[a.uid]?.sent ?? '0') ?? 0;
              final lastMsgB =
                  int.tryParse(messageList[b.uid]?.sent ?? '0') ?? 0;
              return lastMsgB.compareTo(lastMsgA);
            });
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                var userData = users[index];
                MessageModel? message = messageList[userData.uid];

                if (message?.fromId == ApiService.user.uid ||
                    message?.toId == ApiService.user.uid ||
                    state.isSearching) {
                  return GestureDetector(
                    onTap: () {
                      log("Last active of user: ${userData.lastActive}");
                      log("User name: ${userData.name}");
                      log("Follow Requests: ${userData.followRequests}");
                      Get.toNamed(AppRoutes.chatScreen, arguments: userData);
                    },
                    child: Container(
                      height: 80.h,
                      decoration:
                          BoxDecoration(color: AppColors.to.darkBgColor),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: CircleAvatar(
                              backgroundColor:
                                  AppColors.to.defaultProfileImageBg,
                              radius: 23,
                              backgroundImage: userData.image.isNotEmpty
                                  ? CachedNetworkImageProvider(userData.image)
                                  : AssetImage(ImagePath.profileIcon)
                                      as ImageProvider,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonSoraText(
                                text: userData.name,
                                color: AppColors.to.contrastThemeColor,
                                textSize: message == null
                                    ? 16
                                    : message.read.isEmpty &&
                                            message.fromId !=
                                                ApiService.user.uid
                                        ? 17
                                        : 16,
                                fontWeight: message == null
                                    ? FontWeight.normal
                                    : message.read.isEmpty &&
                                            message.fromId !=
                                                ApiService.user.uid
                                        ? FontWeight.w700
                                        : FontWeight.normal,
                              ),
                              SizedBox(width: 5.w),
                              SizedBox(
                                width: 200.w,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CommonSoraText(
                                        text: message == null
                                            ? LocaleKeys.busy.tr
                                            : message.type == Type.image
                                                ? LocaleKeys.image.tr
                                                : message.msg,
                                        color: message == null
                                            ? AppColors.to.contrastThemeColor
                                                .withOpacity(0.5)
                                            : (message.read.isEmpty &&
                                                    message.fromId !=
                                                        ApiService.user.uid)
                                                ? AppColors
                                                    .to.contrastThemeColor
                                                : AppColors
                                                    .to.contrastThemeColor
                                                    .withOpacity(0.5),
                                        textSize: message != null &&
                                                message.read.isEmpty &&
                                                message.fromId !=
                                                    ApiService.user.uid
                                            ? 15
                                            : 14,
                                        fontWeight: message != null &&
                                                message.read.isEmpty &&
                                                message.fromId !=
                                                    ApiService.user.uid
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        maxLine: 1,
                                        softWrap: false,
                                        textOverflow: TextOverflow.fade,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    if (message != null &&
                                        message.toId != ApiService.user.uid)
                                      Icon(
                                        Icons.done_all_rounded,
                                        size: 15,
                                        color: message.read.isEmpty &&
                                                message.toId !=
                                                    ApiService.user.uid
                                            ? Colors.grey.shade500
                                            : Colors.blue.shade400,
                                      ),
                                    CommonSoraText(
                                      text: message == null
                                          ? ""
                                          : (message.toId !=
                                                  ApiService.user.uid)
                                              ? context
                                                  .watch<TimeCubit>()
                                                  .formattedTime(message.sent)
                                                  .replaceAll("~", "")
                                              : "",
                                      color: AppColors.to.contrastThemeColor
                                          .withOpacity((message != null &&
                                                  message.read.isEmpty &&
                                                  message.fromId !=
                                                      ApiService.user.uid)
                                              ? 1
                                              : 0.5),
                                      textSize: (message != null &&
                                              message.read.isEmpty &&
                                              message.fromId !=
                                                  ApiService.user.uid)
                                          ? 15
                                          : 14,
                                      fontWeight: (message != null &&
                                              message.read.isEmpty &&
                                              message.fromId !=
                                                  ApiService.user.uid)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      maxLine: 1,
                                      softWrap: false,
                                      textOverflow: TextOverflow.fade,
                                    ),
                                    if (message != null &&
                                        message.read.isEmpty &&
                                        message.fromId != ApiService.user.uid)
                                      Row(
                                        children: [
                                          Container(
                                            height: 7,
                                            width: 7,
                                            decoration: BoxDecoration(
                                              color: AppColors
                                                  .to.contrastThemeColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          CommonSoraText(
                                            text: timeago
                                                .format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          int.parse(
                                                              message.sent)),
                                                  locale: 'en_short',
                                                )
                                                .replaceAll("~", ""),
                                            color:
                                                AppColors.to.contrastThemeColor,
                                            textSize: 14,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox();
              },
            );
          },
        );
      },
    );
  }
}
