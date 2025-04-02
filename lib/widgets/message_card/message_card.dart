import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/message_model.dart';
import 'package:vibez/utils/dialog/dialog.dart';
import 'package:vibez/utils/date_format/my_date_util.dart';
import 'package:vibez/widgets/bottomshit_options.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_text_button.dart';
import 'package:vibez/widgets/common_textfield.dart';

class MessageCard extends StatefulWidget {
  final MessageModel message;
  const MessageCard({super.key, required this.message});

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
      child: isMe ? primaryMessage() : secondaryMessage(),
    );
  }

  Widget primaryMessage() {
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
          // Ensures the message container doesn't force overflow
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              padding: EdgeInsets.all(10),
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
                          // Prevents text from forcing overflow
                          child: CommonSoraText(
                            text: widget.message.msg,
                            color: AppColors.to.sendUserFontColor,
                            textSize: 15,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        CommonSoraText(
                          text: formatTimestamp(timestamp),
                          color: AppColors.to.defaultProfileImageBg
                              .withOpacity(0.5),
                          textSize: 10,
                        ),
                        if (widget.message.read.isNotEmpty) ...[
                          SizedBox(width: 5.w),
                          Icon(Icons.done_all_rounded,
                              color: Colors.blue.shade400, size: 15),
                        ] else ...[
                          SizedBox(width: 5.w),
                          Icon(Icons.done_all_rounded,
                              color: Colors.grey.shade500, size: 15),
                        ]
                      ],
                    )
                  : SizedBox(
                      child: Image.network(
                        height: 200.h,
                        widget.message.msg,
                        fit: BoxFit.contain,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  Widget secondaryMessage() {
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
      mainAxisAlignment: MainAxisAlignment.start, // Align messages to the left
      children: [
        Flexible(
          // Ensures the message container doesn't force overflow
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            padding: EdgeInsets.all(10),
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
                : SizedBox(
              height: 200.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Image with loading indicator
                  Image.network(
                    widget.message.msg,
                    fit: BoxFit.contain,
                    height: 200.h,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(), // Show loader while loading
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50),
                  ),
                ],
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
              widget.message.type==Type.image?Container():OptionItem(
                icon: Icons.copy_rounded,
                name: "Copy",
                onTap: () async {
                  await Clipboard.setData(
                          ClipboardData(text: widget.message.msg))
                      .then(
                    (value) => Navigator.pop(context),
                  );
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
                          Dialogs.showSnackBar(
                              context, "Image saved successfully!");
                          Navigator.pop(context);
                        } else {
                          // Show failure dialog
                          Dialogs.showSnackBar(
                              context, "Failed to save image.");
                        }
                      } else {
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
                  ? widget.message.type==Type.image?Container():OptionItem(
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
                  ? OptionItem(
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
      builder: (BuildContext dialogContext) {  // Use a separate context
        return AlertDialog(
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),
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


