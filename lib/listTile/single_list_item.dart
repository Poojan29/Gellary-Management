import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SingleListTile extends StatelessWidget {
  const SingleListTile({
    Key key,
    this.folderName,
    this.folderContents,
    this.onCardClicked,
    @required this.image,
    @required this.totalItems,
    @required this.onCancelButtonPressed,
    @required this.onDeleteClicked,
    @required this.onRenameClicked,
  }) : super(key: key);

  final String folderName;
  final int totalItems;
  final int folderContents;
  final Image image;
  final VoidCallback onCardClicked;
  final VoidCallback onCancelButtonPressed;
  final VoidCallback onDeleteClicked;
  final VoidCallback onRenameClicked;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onCardClicked,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              elevation: 0.0,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                    child: image,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          folderName,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'asset/icons/Group 2@2x.png',
                              width: 11.0,
                              height: 13.0,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              totalItems.toString(),
                              style: TextStyle(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          folderName,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    ListTile(
                                      leading: new Icon(
                                        FontAwesomeIcons.edit,
                                        size: 18.0,
                                      ),
                                      title: new Text(
                                        'Rename',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      onTap: onRenameClicked,
                                    ),
                                    Divider(),
                                    ListTile(
                                      leading: new Icon(
                                        FontAwesomeIcons.trashAlt,
                                        size: 18.0,
                                        color: Colors.red,
                                      ),
                                      title: new Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      onTap: onDeleteClicked,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        onPressed: onCancelButtonPressed,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
