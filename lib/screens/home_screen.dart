import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/app_theme.dart';
import 'package:flutter_application_1/listTile/single_list_item.dart';
import 'package:flutter_application_1/screens/ImagePicker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController createFolderDialogController = TextEditingController();
  TextEditingController renameDIalogController = TextEditingController();
  Directory appDocDirNewFolder, appDirFolder, externalStorageDir, directory;
  List<FileSystemEntity> allDirectory;
  List<Directory> allDirectorys;
  List<FileSystemEntity> allImages;

  Future<List<FileSystemEntity>> getAllAvailableDirectory() async {
    externalStorageDir = await getExternalStorageDirectory();
    final myExternalStorageDir = new Directory(externalStorageDir.path);
    print('Init Folder Dir = $myExternalStorageDir');
    for (Directory d in myExternalStorageDir.listSync()) {
      allImages = d.listSync();
    }
    allDirectory = myExternalStorageDir.listSync();
    print('All Directory == $allDirectory');

    setState(() {});

    return allDirectory;
  }

  @override
  void initState() {
    super.initState();
    getAllAvailableDirectory();
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = Provider.of<AppTheme>(context, listen: false);

    Future<File> createAlertDialog() {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              title: Text('Folder Name'),
              content: TextField(
                // cursorColor: Theme.of(context).primaryColor,
                cursorHeight: 20.0,
                decoration: InputDecoration(
                  hintText: 'eg. My receipts',
                ),
                controller: createFolderDialogController,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    'Create',
                  ),
                  onPressed: () async {
                    if (createFolderDialogController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please Enter Folder Name.'),
                        ),
                      );
                    } else {
                      externalStorageDir = await getExternalStorageDirectory();
                      print('Temp Dir Path = ${externalStorageDir.path}');

                      appDirFolder = Directory(
                          '${externalStorageDir.path}/${createFolderDialogController.text}');

                      if (await appDirFolder.exists()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Folder Already Exists.'),
                          ),
                        );
                      } else {
                        appDocDirNewFolder =
                            await appDirFolder.create(recursive: true);

                        print(appDocDirNewFolder.path);
                        Navigator.pop(context);
                        setState(() {});
                        return File(appDocDirNewFolder.path);
                      }
                    }
                  },
                ),
              ],
            );
          });
    }

    Future<List<FileSystemEntity>> getAllDirectory() async {
      final myStorageDir = new Directory(externalStorageDir.path);
      Directory d;
      for (d in myStorageDir.listSync()) {
        allImages = d.listSync();
      }
      allDirectory = myStorageDir.listSync();
      print('All Directory == $allDirectory');
      return allDirectory;
    }

    onDeleteClicked(FileSystemEntity index) {
      index.deleteSync(recursive: true);
      setState(() {});
    }

    Future<FileSystemEntity> changeFileNameOnly(
        FileSystemEntity file, String newFileName) {
      var path = file.path;
      print('Pathh = $path');
      var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
      var newPath = path.substring(0, lastSeparator + 1) + newFileName;
      print('new PAth = $newPath');
      setState(() {});
      return file.rename(newPath);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Documents',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24.0,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.create_new_folder_outlined,
              //   color: Colors.grey[600],
            ),
            onPressed: createAlertDialog,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: appTheme.getTheme == appTheme.dark()
                  ? Icon(Icons.wb_sunny)
                  : Icon(Icons.nights_stay),
              onPressed: appTheme.swapTheme,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        initialData: allDirectory,
        future: getAllDirectory(),
        builder: (BuildContext context,
            AsyncSnapshot<List<FileSystemEntity>> snapshot) {
          if (snapshot.hasData ||
              snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount:
                    snapshot.data.length == null ? 0 : snapshot.data.length,
                itemBuilder: (context, index) {
                  return SingleListTile(
                    folderName: basename(snapshot.data[index].path),
                    totalItems: allImages.length,
                    image: allImages.length.toString() == '0'
                        ? Image.asset(
                            'asset/icons/empty_folder_icon@3x.png',
                            height: 60.0,
                            width: 60.0,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            'asset/icons/folder_icon@3x.png',
                            height: 60.0,
                            width: 60.0,
                            fit: BoxFit.contain,
                          ),
                    onCardClicked: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImagePickerScreen(
                            directory: allDirectory[index],
                            name: basename(snapshot.data[index].path),
                          ),
                        ),
                      );
                    },
                    onDeleteClicked: () {
                      Navigator.pop(context);
                      return showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return Expanded(
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              title: Text('Are you sure you want delete?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Cancel',
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    onDeleteClicked(snapshot.data[index]);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    onRenameClicked: () {
                      return showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return Expanded(
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              title: Text('Folder Name'),
                              content: TextField(
                                cursorColor: Theme.of(context).primaryColor,
                                cursorHeight: 20.0,
                                decoration: InputDecoration(
                                  hintText: 'eg. My receipts',
                                ),
                                controller: createFolderDialogController,
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Cancel',
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Rename',
                                  ),
                                  onPressed: () {
                                    changeFileNameOnly(snapshot.data[index],
                                        renameDIalogController.text);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      // Navigator.pop(context);
                      //   setState(() {});
                    },
                    onCancelButtonPressed: () {
                      Navigator.pop(context);
                    },
                  );
                });
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text('No Data Available.'),
            );
          }
        },
      ),
    );
  }
}
