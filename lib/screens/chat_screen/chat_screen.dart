import 'dart:developer';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibez/Cubit/emoji/emoji_cubit.dart';
import 'package:vibez/Cubit/message_input/message_input_cubit.dart';
import 'package:vibez/Cubit/user/user_cubit.dart';
import 'package:vibez/Cubit/user/user_state.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/message_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/screens/call_screen.dart';
import 'package:vibez/services/call_service.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/utils/date_format/my_date_util.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_textfield.dart';
import 'package:vibez/widgets/message_card/message_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late UserModel userData;
  late List<MessageModel> _list = [];
  TextEditingController chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isEmoji = false;
  final GlobalKey _attachmentButtonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  String? selectedMessageId;
  final CallService callService = CallService();
  String currentUserId = ApiService.user.uid;
  @override
  void initState() {
    userData = Get.arguments;
    context
        .read<UserCubit>()
        .fetchChatUserProfile(userData.uid, ApiService.user.uid);
    super.initState();
  }

  void _toggleAttachmentOptions(BuildContext context, UserModel userData, GlobalKey key) {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    renderBox.localToGlobal(Offset.zero); // Button position

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          right: 10,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + 60, // Above keyboard
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 150.w,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.to.darkBgColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  spacing: 10.h,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _removeOverlay();
                        final ImagePicker picker = ImagePicker();
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 90);
                        for (var i in images) {
                          await ApiService.sendChatImage(
                            userData,
                            File(i.path),
                          );
                        }
                      },
                      child: Row(
                        spacing: 10.w,
                        children: [
                          Icon(
                            Icons.image,
                            color: AppColors.to.contrastThemeColor,
                          ),
                          CommonSoraText(
                            text: LocaleKeys.gallery.tr,
                            color: AppColors.to.contrastThemeColor,
                            textSize: 15,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _removeOverlay();
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          await ApiService.sendChatImage(
                            userData,
                            File(image.path),
                          );
                        }
                      },
                      child: Row(
                        spacing: 10.w,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: AppColors.to.contrastThemeColor,
                          ),
                          CommonSoraText(
                            text: LocaleKeys.camera.tr,
                            color: AppColors.to.contrastThemeColor,
                            textSize: 15,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _removeOverlay();
                        final result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'docx', 'xlx', 'txt'],
                        );

                        if (result != null) {
                          for (var file in result.files) {
                            final pickedFile = File(file.path!);
                            await ApiService.sendChatDocument(userData, pickedFile, file.name);
                          }
                        }
                      },
                      child: Row(
                        spacing: 10.w,
                        children: [
                          Icon(
                            Icons.file_copy_rounded,
                            color: AppColors.to.contrastThemeColor,
                          ),
                          CommonSoraText(
                            text: "Document",
                            color: AppColors.to.contrastThemeColor,
                            textSize: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // void initiateCall(String callerId, String receiverId) async {
  //   String channelId = await CallService()
  //       .startCall(callerId: callerId, receiverId: receiverId);
  //
  //   // Listen for call updates using the channelId
  //   CallService().listenToCallUpdates(channelId).listen((call) {
  //     if (call != null && call.status == 'ongoing') {
  //       // Navigate to Video Call Screen when the call is accepted
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => VideoCallScreen(channelId: call.channelId),
  //         ),
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isEmojiOpen = context.read<EmojiCubit>().state;
        if (isEmojiOpen) {
          context.read<EmojiCubit>().closeEmojiKeyboard();
          return false; // Prevent screen from closing
        }
        return true; // Allow screen to close
      },
      child: Scaffold(
        backgroundColor: AppColors.to.darkBgColor,
        appBar: CommonAppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_rounded,
                color: AppColors.to.contrastThemeColor,
            ),
          ),
          title: Row(
            spacing: 10.w,
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.otherUserProfileScreen, arguments: userData);
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.to.defaultProfileImageBg,
                  radius: 16,
                  backgroundImage: userData.image.isNotEmpty
                      ? NetworkImage(userData.image)
                      : AssetImage(ImagePath.profileIcon) as ImageProvider,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.otherUserProfileScreen,
                              arguments: userData);
                        },
                        child: CommonSoraText(
                          text: userData.username,
                          color: AppColors.to.contrastThemeColor,
                          textSize: 17,
                        ),
                      ),
                      CommonIconButton(
                        iconData: Icons.navigate_next_rounded,
                        size: 20,
                        color: AppColors.to.contrastThemeColor,
                        onTap: () {
                          Get.toNamed(AppRoutes.otherUserProfileScreen,
                              arguments: userData);
                        },
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream:  ApiService.getUserInfo(userData),
                    builder: (context,snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }

                      if (snapshot.hasError) {
                        return CommonSoraText(text: 'Error');
                      }

                      if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                        return Container();
                      }

                      final data = snapshot.data!.data();
                      final list = data != null ? [UserModel.fromJson(data)] : [];

                      // These logs will now run only when data is guaranteed to exist
                      log("=====list is ===== $list");
                      log("=====list is ===== ${list[0].isOnline}");
                      return  GestureDetector(
                        onTap: () {
                          log("is online : ${list[0].isOnline}");
                          log("username : ${list[0].username}");
                        },
                        child: CommonSoraText(
                          text: list.isNotEmpty
                              ? list[0].isOnline
                              ? "Online"
                              : MyDateUtil.getLastActiveTime(
                            context: context,
                            lastActive: list[0].lastActive,
                          )
                              : MyDateUtil.getLastActiveTime(
                            context: context,
                            lastActive: userData.lastActive,
                          ),
                          color: AppColors.to.contrastThemeColor,
                          textSize: 12,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
      actions: [
            // IconButton(
            //   icon: Icon(
            //     Icons.video_call,
            //     size: 25,
            //     color: AppColors.to.contrastThemeColor,
            //   ),
            //   onPressed: () async {
            //     initiateCall(
            //       currentUserId,
            //       userData.uid,
            //     );
            //   },
            // ),
          ],
          // body: ,
        ),
        body: BlocListener<MessageInputCubit, bool>(
          listener: (context, isEmpty) {
            // Perform side effects here (if needed)
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: ApiService.getAllMessages(userData),

                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => MessageModel.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            reverse:  true,
                            controller: _scrollController,
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onLongPress: () {},
                                  child: MessageCard(message: _list[index]));
                            },
                          );
                        } else {
                          return Center(
                            child: CommonSoraText(
                              text: "${LocaleKeys.sayHi.tr} 👋🏻",
                              color: AppColors.to.contrastThemeColor,
                              textSize: 15,
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
              SizedBox(height: 5.h),
              BlocBuilder<EmojiCubit, bool>(
                builder: (context, isEmojiOpen) {
                  return Column(
                    children: [
                      BlocBuilder<UserCubit, UserState>(
                          builder: (context, userState) {
                        bool isConnected =
                            context.watch<UserCubit>().isConnected;
                        bool isPrivate = context.watch<UserCubit>().isPrivate;
                        log("is connected in chat screen $isConnected");
                        log("account is private?? $isPrivate");
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.to.contrastThemeColor
                                  .withOpacity(0.5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  CommonIconButton(
                                    iconData: Icons.emoji_emotions_outlined,
                                    color: AppColors.to.contrastThemeColor,
                                    size: 30,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .unfocus(); // Hide keyboard
                                      context
                                          .read<EmojiCubit>()
                                          .toggleEmojiKeyboard();
                                    },
                                  ),
                                  Expanded(
                                    child: BlocSelector<MessageInputCubit, bool,
                                        bool>(
                                      selector: (state) => state,
                                      builder: (context, isEmpty) {
                                        return CommonTextField(
                                          controller: chatController,
                                          onChanged: context
                                              .read<MessageInputCubit>()
                                              .onTextChanged,
                                          hintText:
                                              "${LocaleKeys.typeHere.tr}...",
                                          fillColor: Colors.transparent,
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedErrorBorder: InputBorder.none,
                                          onTap: () => context
                                              .read<EmojiCubit>()
                                              .closeEmojiKeyboard(),
                                        );
                                      },
                                    ),
                                  ),
                                  BlocSelector<MessageInputCubit, bool, bool>(
                                    selector: (state) => state,
                                    builder: (context, isEmpty) {
                                      return Row(
                                        spacing: 5.w,
                                        children: [
                                          if (isEmpty) ...[
                                            GestureDetector(
                                              key:
                                                  _attachmentButtonKey,
                                              onTap: () {
                                                _toggleAttachmentOptions(
                                                  context,
                                                  userData,
                                                  _attachmentButtonKey,
                                                );
                                              },
                                              child: Icon(
                                                Icons
                                                    .attach_file,
                                                size: 30,
                                                color: AppColors
                                                    .to.contrastThemeColor,
                                              ),
                                            ),
                                          ],
                                          GestureDetector(
                                            onTap: () {
                                              if (chatController
                                                  .text.isNotEmpty) {
                                                ApiService.sendMessage(
                                                  userData,
                                                  chatController.text,
                                                  Type.text,
                                                );
                                                chatController.clear();
                                                context
                                                    .read<MessageInputCubit>()
                                                    .onTextChanged(
                                                        ""); // Reset state
                                                Future.delayed(
                                                    Duration(milliseconds: 300),
                                                    () {
                                                });
                                              }
                                            },
                                            child: Container(
                                              height: 30.h,
                                              width: 30.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors
                                                    .to.contrastThemeColor,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3.0),
                                                child: Icon(
                                                  Icons.send_rounded,
                                                  size: 20,
                                                  color:
                                                      AppColors.to.darkBgColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      if (isEmojiOpen)
                        SizedBox(
                          height: 275.h,
                          child: EmojiPicker(
                            textEditingController: chatController,
                            config: Config(
                              categoryViewConfig: CategoryViewConfig(
                                backgroundColor: AppColors.to.darkBgColor,
                                iconColor: AppColors.to.contrastThemeColor,
                                iconColorSelected:
                                    AppColors.to.contrastThemeColor,
                                indicatorColor: AppColors.to.contrastThemeColor,
                              ),
                              bottomActionBarConfig: BottomActionBarConfig(
                                backgroundColor: AppColors.to.darkBgColor,
                                buttonColor: AppColors.to.darkBgColor,
                                buttonIconColor:
                                    AppColors.to.contrastThemeColor,
                              ),
                              height: 256.h,
                              emojiViewConfig: EmojiViewConfig(
                                verticalSpacing: 5.h,
                                emojiSizeMax: 32 *
                                    (defaultTargetPlatform == TargetPlatform.iOS
                                        ? 1.30
                                        : 1.0),
                                backgroundColor: AppColors.to.darkBgColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
