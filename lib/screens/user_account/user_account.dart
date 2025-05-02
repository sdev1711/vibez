import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vibez/Cubit/private_account_switch/private_account_switch_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_text.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  late DateTime createdAt;
  String? formattedDate;
  @override
  void initState() {
     createdAt = ApiService.user.metadata.creationTime!;
     formattedDate = DateFormat('dd-MM-yyyy').format(createdAt);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
          textSize: 15.sp,
          text: LocaleKeys.account.tr,
          color: AppColors.to.contrastThemeColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded,
              color: AppColors.to.contrastThemeColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<SwitchCubit,bool>(
              builder: (context,isPrivate){
                return  Column(
                  spacing: 15.h,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonSoraText(
                          text:LocaleKeys.privateAccount.tr,
                          color: AppColors.to.contrastThemeColor,
                        ),
                        Switch(
                            value: isPrivate,
                            onChanged: (val) {
                              context.read<SwitchCubit>().toggleSwitch(val);
                            },
                          activeColor: AppColors.to.contrastThemeColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonSoraText(
                          text:"Joined at",
                          color: AppColors.to.contrastThemeColor,
                        ),
                        CommonSoraText(
                          text:formattedDate??"",
                          color: AppColors.to.contrastThemeColor,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
