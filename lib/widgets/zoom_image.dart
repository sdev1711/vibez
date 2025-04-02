import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImage {
  Future<dynamic> showFullScreenImage(BuildContext context, String imageUrl) {
    return showDialog(
      context: context,
      barrierDismissible: true, // Tap outside to close
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero, // Ensure it takes full screen size
        child: GestureDetector(
          onTap: () => Navigator.pop(context), // Tap outside to close
          child: Stack(
            children: [
// Blurred Background
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),
// Centered Image with Fixed Size
              Center(
                child: GestureDetector(
                  onTap: () {}, // Prevents closing when tapping on the image
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 300.w, // Set a fixed width for the image box
                      height: 300.h, // Set a fixed height for the image box
                      child: PhotoView(
                        imageProvider: NetworkImage(imageUrl),
                        backgroundDecoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
