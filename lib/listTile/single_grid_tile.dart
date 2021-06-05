import 'dart:io';

import 'package:flutter/material.dart';

class SingleImageGridTile extends StatelessWidget {
  const SingleImageGridTile(
      {Key key, @required this.file, @required this.fileName})
      : super(key: key);

  final File file;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: Card(
        margin: EdgeInsets.only(bottom: 20.0),
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)),
              child: Image.file(
                file,
                width: 130.0,
                height: 120.0,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(Icons.more_horiz_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
