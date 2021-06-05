import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleImageListTile extends StatelessWidget {
  const SingleImageListTile(
      {Key key, @required this.file, @required this.fileName, this.date})
      : super(key: key);

  final FileSystemEntity file;
  final String fileName;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  child: Image.file(
                    file,
                    height: 60.0,
                    width: 100.0,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fileName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Icon(Icons.more_vert_rounded)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
