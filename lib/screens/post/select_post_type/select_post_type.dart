import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/bottom_nav_post/bottom_nav_post_cubit.dart';
import 'package:vibez/Cubit/post/image_picker_cubit/image_picker_cubit.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/screens/post/add_post/add_clip.dart';
import 'package:vibez/screens/post/add_post/add_post_screen.dart';
import 'package:vibez/screens/story/upload_story/upload_story.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_text.dart';

class SelectPostType extends StatelessWidget {
   SelectPostType({super.key});
  final List<Widget> _pages = [
   AddPostScreen(),
   AddClipScreen(),
   UploadStoryScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocBuilder<BottomNavCubit,int>(
        builder:(context,state){
          return _pages[state];
        },
      ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomAppBar(
              height: 50.h,
              color: Colors.black,
              shape: const CircularNotchedRectangle(),
              notchMargin: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildNavItem(context,"Post", 0),
                  _buildNavItem(context,"Reel", 1),
                  _buildNavItem(context,"Live", 2),
                ],
              ),
            ),
          ),
        ),
    );
  }
   Widget _buildNavItem(BuildContext context, String label, int index) {
     return BlocBuilder<BottomNavCubit, int>(
       builder: (context, selectedIndex) {
         final isSelected = selectedIndex == index;
         return GestureDetector(
           onTap: () {
             context.read<ImagePickerCubit>().clearImage();
             context.read<BottomNavCubit>().changeIndex(index);
           } ,
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               CommonSoraText(
                 text: label,
                 color: isSelected ? Colors.white : Colors.white60,
                   ),
             ],
           ),
         );
       },
     );
   }
}
