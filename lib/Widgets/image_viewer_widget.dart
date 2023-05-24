import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewerPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  ImageViewerPage({Key? key, required this.imageUrls, required this.initialIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: imageUrls.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: MemoryImage(
                  base64Decode(imageUrls[index]),
                ),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(),
            ),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(initialPage: initialIndex),
          ),
          Positioned(
            top: 40.0,
            right: 16.0,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the page
              },
              icon: const Icon(Icons.close, color: Colors.white, size: 35),
            ),
          ),
        ],
      ),
    );
  }
}