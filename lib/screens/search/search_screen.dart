import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/feed_search/feed_search_cubit.dart';
import 'package:vibez/Cubit/feed_search/feed_search_state.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_textfield.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (Get.arguments != null && Get.arguments['openKeyBoard'] == true) {
        FocusScope.of(context).requestFocus(_focusNode);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<FeedSearchCubit>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.to.darkBgColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
                  Padding(
          padding: const EdgeInsets.only(top: 50,right: 15,left: 10),
          child: Row(
            spacing: 5.w,
            children: [
              CommonIconButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
                size: 25,
                color: AppColors.to.contrastThemeColor,
                iconData:  Icons.arrow_back_rounded,
              ),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: CommonTextField(
                    controller: searchController,
                    focusNode: _focusNode,
                    hintText: "${LocaleKeys.search.tr}...",
                    prefixIcons: Image.asset(ImagePath.searchIcon,color: AppColors.to.contrastThemeColor,scale: 25,),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 6, horizontal: 12),
                    fillColor: AppColors.to.contrastThemeColor
                        .withOpacity(0.5),
                    maxLines: 1,
                    textInputAction: TextInputAction.go,
                    onChanged: (val) {
                      searchCubit.searchUsers(val);
                    },
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
                  ),
                  /// 🔹 **Search Results**
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: BlocBuilder<FeedSearchCubit, FeedSearchState>(
                  builder: (context, state) {
                    if (state.isSearching) {
                      return state.userList.isEmpty
                          ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: CommonSoraText(
                            text: LocaleKeys.noDataFound.tr,
                            color: AppColors.to.contrastThemeColor,
                            textSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                          : buildUserList(state.userList);
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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
    return BlocBuilder<FeedSearchCubit, FeedSearchState>(
      builder: (context, state) {
        return  ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            var userData = users[index];
            return StreamBuilder(
                stream: ApiService.getAllLastMessagesStream(users),
                builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.otherUserProfileScreen, arguments: userData);
                    },
                    child: Container(
                      height: 80.h,
                      decoration: BoxDecoration(color: AppColors.to.darkBgColor),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: CircleAvatar(
                              backgroundColor: AppColors.to.defaultProfileImageBg,
                              radius: 25,
                              backgroundImage: userData.image.isNotEmpty
                                  ? NetworkImage(userData.image)
                                  : AssetImage(
                                ImagePath.profileIcon,
                              ) as ImageProvider,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonSoraText(
                                text: userData.name,
                                color: AppColors.to.contrastThemeColor,
                                textSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(width: 5.h,),
                              CommonSoraText(
                                text: userData.username,
                                color: AppColors.to.contrastThemeColor.withOpacity(0.6),
                                textSize: 14,
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  );
                  return SizedBox();
                });
          },
        );
      },
    );
  }
}
