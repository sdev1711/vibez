import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/chatbot_msg_model.dart';
import 'package:vibez/widgets/common_text.dart';

class Messages extends StatelessWidget {
  final ChatbotMessageModel chatBotMessage;

  const Messages({
    super.key,
    required this.chatBotMessage,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(chatBotMessage.date.toString());
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return Row(
      mainAxisAlignment: chatBotMessage.isUser?MainAxisAlignment.end:MainAxisAlignment.start, // Align messages to the left
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: chatBotMessage.isUser?AppColors.to.aiDarkColor:AppColors.to.aiLightColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  // Prevents text from forcing overflow
                  child: CommonSoraText(
                    text: chatBotMessage.message.replaceAll("**", ""),
                    color: chatBotMessage.isUser?AppColors.to.sendUserFontColor:AppColors.to.receiveUserFontColor,
                    textSize: 15,
                  ),
                ),
                SizedBox(width: 10.w),
                CommonSoraText(
                  text: formattedTime,
                  color: chatBotMessage.isUser?AppColors.to.defaultProfileImageBg
                      .withOpacity(0.5):AppColors.to.darkBgColor.withOpacity(0.5),
                  textSize: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}