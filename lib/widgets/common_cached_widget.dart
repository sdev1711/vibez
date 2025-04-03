import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vibez/app/colors.dart';

class CommonCachedWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  const CommonCachedWidget({super.key, required this.imageUrl,this.height,this.width});


  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context,imageProvider)=>Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.to.darkBgColor,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) => Container(
        height:height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[300],
        ),
        child: Center(
          child: CircularProgressIndicator(value: downloadProgress.progress,color: AppColors.to.contrastThemeColor,),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height:height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[400],
        ),
        child: Icon(Icons.refresh, size: 50, color:AppColors.to.contrastThemeColor),
      ),
    );
  }
}
