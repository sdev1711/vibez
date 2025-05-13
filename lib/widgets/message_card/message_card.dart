import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:vibez/Cubit/document_download_cubit/document_download_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/message_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/utils/dialog/dialog.dart';
import 'package:vibez/utils/date_format/my_date_util.dart';
import 'package:vibez/widgets/bottomshit_options.dart';
import 'package:vibez/widgets/common_button.dart';
import 'package:vibez/widgets/common_cached_widget.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_text_button.dart';
import 'package:vibez/widgets/common_textfield.dart';
import 'package:http/http.dart' as http;

class MessageCard extends StatefulWidget {
  final MessageModel message;
  final UserModel userData;
  const MessageCard({super.key, required this.message, required this.userData});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = ApiService.user.uid == widget.message.fromId;
    return InkWell(
      splashColor: Colors.transparent,
      onLongPress: () {
        showBottomShit(isMe);
      },
      onTap: () {
        log("hiiiii ${widget.message.type}");
      },
      child: isMe ? primaryMessage() : secondaryMessage(),
    );
  }

  Widget primaryMessage() {
    if (widget.message.read.isEmpty) {
      // Only update if not read
      Future.delayed(Duration(milliseconds: 500), () {
        ApiService.updateMessageReadStatus(widget.message);
      });
    }
    Timestamp convertStringToTimestamp(String timestampString) {
      int milliseconds = int.parse(timestampString); // Convert String to int
      return Timestamp.fromMillisecondsSinceEpoch(milliseconds);
    }

    // Timestamp timestamp = convertStringToTimestamp(widget.message.sent);
    String formatTimestamp(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('hh:mm a').format(dateTime); // Example: "12:00 PM"
    }

    Timestamp timestamp = convertStringToTimestamp(widget.message.sent);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Align messages to the left
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            padding: widget.message.type == Type.text
                ? EdgeInsets.all(10)
                : EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.to.sendUserColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: widget.message.type == Type.text
                ? Row(
                    mainAxisSize: MainAxisSize.min, // Allow dynamic width
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: CommonSoraText(
                          text: widget.message.msg,
                          color: AppColors.to.sendUserFontColor,
                          textSize: 15,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CommonSoraText(
                        text: formatTimestamp(timestamp),
                        color:
                            AppColors.to.defaultProfileImageBg.withOpacity(0.5),
                        textSize: 10,
                      ),
                      if (widget.message.read.isNotEmpty &&
                          ApiService.user.uid == widget.message.fromId) ...[
                        SizedBox(width: 5.w),
                        Icon(Icons.done_all_rounded,
                            color: ApiService.me.readReceipts == false ||
                                    widget.userData.readReceipts == false
                                ? Colors.grey.shade500
                                : Colors.blue.shade400,
                            size: 17),
                      ] else ...[
                        SizedBox(width: 5.w),
                        Icon(Icons.done_all_rounded,
                            color: Colors.grey.shade500, size: 17),
                      ]
                    ],
                  )
                : widget.message.type == Type.image
                    ? Stack(
                        children: [
                          CommonCachedWidget(
                              imageUrl: widget.message.msg,
                              height: 300.h,
                              width: 250.w),
                          Positioned(
                            bottom: 5,
                            right: 15,
                            child: widget.message.read.isNotEmpty &&
                                    ApiService.user.uid == widget.message.fromId
                                ? Icon(Icons.done_all_rounded,
                                    color:
                                        ApiService.me.readReceipts == false ||
                                                widget.userData.readReceipts ==
                                                    false
                                            ? Colors.grey.shade500
                                            : Colors.blue.shade400,
                                    size: 17)
                                : Icon(Icons.done_all_rounded,
                                    color: Colors.grey.shade500, size: 17),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: () async {
                          final url = widget.message.msg;
                          try {
                            // Download the file to local storage
                            final response = await http.get(Uri.parse(url));
                            final fileName = 'document.pdf';

                            final dir = await getTemporaryDirectory();
                            final filePath = '${dir.path}/$fileName';

                            final file = File(filePath);
                            await file.writeAsBytes(response.bodyBytes);

                            final result = await OpenFilex.open(filePath);
                            log('Open result: ${result.message}');
                          } catch (e) {
                            log('Failed to open file: $e');
                            if(!mounted)return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Couldn't open document.")),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          width: 250.w,
                          decoration: BoxDecoration(
                            color: AppColors.to.primaryBgColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.insert_drive_file,
                                  size: 30, color: AppColors.to.white),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonSoraText(
                                      text:
                                          widget.message.fileName ?? 'Document',
                                      textSize: 14,
                                      color: AppColors.to.white,
                                      softWrap: true,
                                      maxLine: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CommonSoraText(
                                          text: formatTimestamp(timestamp),
                                          textSize: 10,
                                          color: AppColors.to.white
                                              .withOpacity(0.5),
                                        ),
                                        widget.message.read.isNotEmpty &&
                                                ApiService.user.uid ==
                                                    widget.message.fromId
                                            ? Icon(Icons.done_all_rounded,
                                                color: ApiService.me
                                                                .readReceipts ==
                                                            false ||
                                                        widget.userData
                                                                .readReceipts ==
                                                            false
                                                    ? Colors.grey.shade500
                                                    : Colors.blue.shade400,
                                                size: 17)
                                            : Icon(Icons.done_all_rounded,
                                                color: Colors.grey.shade500,
                                                size: 17),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ],
    );
  }

  Widget secondaryMessage() {
    if (widget.message.read.isEmpty) {
      Future.delayed(Duration(milliseconds: 500), () {
        ApiService.updateMessageReadStatus(widget.message);
      });
    }
    Timestamp convertStringToTimestamp(String timestampString) {
      int milliseconds = int.parse(timestampString); // Convert String to int
      return Timestamp.fromMillisecondsSinceEpoch(milliseconds);
    }

    // Timestamp timestamp = convertStringToTimestamp(widget.message.sent);
    String formatTimestamp(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('hh:mm a').format(dateTime); // Example: "12:00 PM"
    }

    Timestamp timestamp = convertStringToTimestamp(widget.message.sent);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Align messages to the left
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            padding: widget.message.type == Type.text
                ? EdgeInsets.all(10)
                : EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.to.receiveUserColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: widget.message.type == Type.text
                ? Row(
                    mainAxisSize: MainAxisSize.min, // Allow dynamic width
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        // Prevents text from forcing overflow
                        child: CommonSoraText(
                          text: widget.message.msg,
                          color: AppColors.to.receiveUserFontColor,
                          textSize: 15,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CommonSoraText(
                        text: formatTimestamp(timestamp),
                        color: AppColors.to.darkBgColor.withOpacity(0.5),
                        textSize: 10,
                      ),
                    ],
                  )
                : widget.message.type == Type.image
                    ? Stack(
                        children: [
                          CommonCachedWidget(
                              imageUrl: widget.message.msg,
                              height: 300.h,
                              width: 250.w),
                        ],
                      )
                    : GestureDetector(
                        onTap: () async {
                          final dir = await getTemporaryDirectory();
                          final filePath =
                              '${dir.path}/${widget.message.fileName ?? "document.pdf"}';
                          final file = File(filePath);

                          if (await file.exists()) {
                            await OpenFilex.open(filePath);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          width: 250.w,
                          decoration: BoxDecoration(
                            color: AppColors.to.receiveUserColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.insert_drive_file,
                                  size: 30,
                                  color: AppColors.to.receiveUserFontColor),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonSoraText(
                                      text:
                                          widget.message.fileName ?? 'Document',
                                      textSize: 14,
                                      color: AppColors.to.receiveUserFontColor,
                                      softWrap: true,
                                      maxLine: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    CommonSoraText(
                                      text: formatTimestamp(timestamp),
                                      textSize: 10,
                                      color: AppColors.to.receiveUserFontColor
                                          .withOpacity(0.5),
                                    ),
                                    SizedBox(height: 10),

                                    ///Show download button only if file doesn't exist
                                    BlocProvider(
                                      create: (_) => DocumentDownloadCubit()
                                        ..checkIfDownloaded(
                                            widget.message.fileName ??
                                                'document.pdf'),
                                      child: BlocBuilder<DocumentDownloadCubit,
                                          bool>(
                                        builder: (context, isDownloaded) {
                                          if (!isDownloaded) {
                                            return Align(
                                              alignment: Alignment.centerRight,
                                              child: CommonButton(
                                                bgColor: AppColors
                                                    .to.receiveUserFontColor,
                                                height: 40.h,
                                                width: 100.w,
                                                onPressed: () {
                                                  final cubit = context.read<
                                                      DocumentDownloadCubit>();
                                                  cubit.downloadFile(
                                                      widget.message.msg,
                                                      widget.message.fileName ??
                                                          'document.pdf');
                                                },
                                                child: CommonSoraText(
                                                  text: "Download",
                                                  color: AppColors
                                                      .to.contrastThemeColor,
                                                ),
                                              ),
                                            );
                                          }
                                          return SizedBox
                                              .shrink(); // Hide button if already downloaded
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ],
    );
  }

  void showBottomShit(bool isMe) {
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 120.w,
                ),
                decoration: BoxDecoration(
                  color: AppColors.to.contrastThemeColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              widget.message.type == Type.image
                  ? Container()
                  : OptionItem(
                      icon: Icons.copy_rounded,
                      name: "Copy",
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then(
                          (value){
                            if(!mounted)return;
                            Navigator.pop(context);
                          }
                        );
                        if(!mounted)return;
                        Dialogs.showSnackBar(context, "Text copied!");
                      },
                    ),
              if (!isMe && widget.message.type == Type.image)
                OptionItem(
                  icon: Icons.download_rounded,
                  name: "Save Image",
                  onTap: () async {
                    try {
                      var response = await Dio().get(
                        widget.message.msg,
                        options: Options(responseType: ResponseType.bytes),
                      );

                      Uint8List? imageBytes = Uint8List.fromList(response.data);

                      if (imageBytes.isNotEmpty) {
                        // Save Image
                        var result = await ImageGallerySaverPlus.saveImage(
                          imageBytes,
                          quality: 60,
                          name: "vibes_save",
                        );

                        if (result['isSuccess']) {
                          // Show success dialog
                          if(!mounted)return;
                          Dialogs.showSnackBar(
                              context, "Image saved successfully!");
                          Navigator.pop(context);
                        } else {
                          // Show failure dialog
                          if(!mounted)return;
                          Dialogs.showSnackBar(
                              context, "Failed to save image.");
                        }
                      } else {
                        if(!mounted)return;
                        Dialogs.showSnackBar(context, "Image data is empty.");
                      }
                    } catch (e) {
                      log("Error: $e");
                      Dialogs.showSnackBar(
                          context, "An error occurred while saving the image.");
                    }
                  },
                ),
              isMe
                  ? widget.message.type == Type.image
                      ? Container()
                      : OptionItem(
                          icon: Icons.edit,
                          name: "Edit",
                          onTap: () {
                            Navigator.pop(context);
                            _showMessageUpdateDialog();
                          },
                        )
                  : SizedBox(),
              if (isMe)
                OptionItem(
                  icon: Icons.delete_outline_rounded,
                  name: "Delete",
                  onTap: () async {
                    Navigator.pop(context); // Close the bottom sheet first
                    await ApiService.deleteMsg(widget.message);
                    if(!mounted)return;
                    Dialogs.showSnackBar(context, "Message deleted!");
                  },
                ),
              Divider(
                color: AppColors.to.contrastThemeColor.withOpacity(0.5),
                indent: 1,
                // endIndent: 0.5,
              ),
              OptionItem(
                icon: Icons.done_all_rounded,
                name: "Sent at : ${MyDateUtil.getMessageTime(
                  time: widget.message.sent,
                )}",
                onTap: () {},
              ),
              isMe
                  ? ApiService.me.readReceipts == false ||
                          widget.userData.readReceipts == false
                      ? SizedBox()
                      : OptionItem(
                          icon: Icons.done_all_rounded,
                          name: widget.message.read.isNotEmpty
                              ? "Read at : ${MyDateUtil.getMessageTime(
                                  time: widget.message.read,
                                )}"
                              : "Read at : Not seen yet",
                          onTap: () {},
                        )
                  : SizedBox(),
              SizedBox(
                height: 20,
              ),
            ],
          );
        });
  }

  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Use a separate context
        return AlertDialog(
          contentPadding:
              const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: CommonSoraText(
            text: "Update message",
            color: AppColors.to.contrastThemeColor,
            textSize: 20,
          ),
          content: CommonTextField(
            initialValue: updatedMsg,
            onChanged: (value) => updatedMsg = value,
          ),
          actions: [
            CommonTextButton(
              onPressed: () {
                FocusScope.of(dialogContext).unfocus(); // Hide keyboard
                Future.delayed(Duration(milliseconds: 100), () {
                  if(!context.mounted)return;
                  if (Navigator.canPop(dialogContext)) {

                    Navigator.of(dialogContext).pop();
                  }
                });
                log("Cancel button pressed");
              },
              child: CommonSoraText(
                text: 'Cancel',
                color: AppColors.to.contrastThemeColor,
              ),
            ),
            CommonTextButton(
              onPressed: () async {
                FocusScope.of(dialogContext).unfocus(); // Hide keyboard
                Future.delayed(Duration(milliseconds: 100), () async {
                  if(!context.mounted)return;
                  if (Navigator.canPop(dialogContext)) {
                    Navigator.pop(dialogContext);
                  }
                  await ApiService.updateMessage(widget.message, updatedMsg);
                });
              },
              child: CommonSoraText(
                text: 'Update',
                color: AppColors.to.contrastThemeColor,
              ),
            )
          ],
        );
      },
    );
  }
}

Timestamp convertMillisecondsToTimestamp(int milliseconds) {
  return Timestamp.fromMillisecondsSinceEpoch(milliseconds);
}
