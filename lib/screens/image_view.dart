import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({
    Key key,
    @required this.file,
    @required this.initialIndex,
  }) : super(key: key);

  final List<FileSystemEntity> file;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Picture'),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Swiper(
            // pagination: SwiperPagination(),
            index: initialIndex,
            loop: false,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Image.file(
                file[index],
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              );
            },
            itemCount: file.length,
          )),
    );
  }
}
