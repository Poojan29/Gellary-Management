import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/listTile/single_grid_tile.dart';
import 'package:flutter_application_1/listTile/single_list_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img;
import 'package:path/path.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key key, this.name, this.directory})
      : super(key: key);

  final String name;
  final Directory directory;

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File _image;
  final picker = ImagePicker();
  List<File> allImages = [];
  PickedFile file;
  File mFile;
  List<FileSystemEntity> _images;
  String date;

  Future<File> saveImageToDisk(String path, Directory directory) async {
    try {
      File tempFile = File(path);
      Img.Image image = Img.decodeImage(tempFile.readAsBytesSync());
      Img.Image mImage = Img.copyResize(image, width: 512);
      String imageType = path.split('.').last;
      String mPath = '${directory.path}/image_${DateTime.now()}.$imageType';
      print('IamgePath is = $mPath');
      File dFile = File(mPath);
      if (imageType == 'jpg' || imageType == 'jpeg') {
        dFile.writeAsBytesSync(Img.encodeJpg(mImage));
      } else {
        dFile.writeAsBytesSync(Img.encodePng(mImage));
      }
      return dFile;
    } catch (e) {
      return null;
    }
  }

  Future<File> loadImage(ImageSource imageSource) async {
    file = await picker.getImage(source: imageSource);

    if (file != null) {
      mFile = await saveImageToDisk(file.path, widget.directory);

      print('File is = $file');
      print('Directory is = ${widget.directory}');

      print('Name Is = ${widget.name}');

      setState(() {});
    }
    return mFile;
  }

  Future<List<FileSystemEntity>> getAllTheImages() async {
    String imgDir = widget.directory.path;
    final myDir = new Directory(imgDir);
    print('Folder Dir = $myDir');
    for (File f in myDir.listSync(recursive: true, followLinks: false)) {
      _image = f;
    }
    _images = myDir.listSync(recursive: true, followLinks: false);
    print('All Images == \n $_images');
    print('All Images == \n $myDir');
    print('Total Images == ${_images.length}');

    return _images;
  }

//   var color = const Color(0xFF659BFF);
  bool _isList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(),
        title: widget.name == null
            ? Text(
                'Folders Name',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(
                '${widget.name}',
                style: TextStyle(
                  //   color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                Icons.upload_file,
                // color: Colors.grey[600],
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.grid_view,
                    size: 25.0,
                    color: _isList
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isList = true;
                      print(_isList);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.format_list_bulleted_rounded,
                    size: 25.0,
                    color: _isList
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isList = false;
                      print(_isList);
                    });
                  },
                ),
              ],
            ),
          ),
          FutureBuilder(
              future: getAllTheImages(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<FileSystemEntity>> snapshot) {
                if (snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.done) {
                  print('Data Available.');
                  return Expanded(
                    child: _isList
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              itemCount: snapshot.data.length == null
                                  ? Center(child: Text('No Photo Available'))
                                  : snapshot.data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, int) {
                                return _image == null
                                    ? Text('No image Found')
                                    : SingleImageGridTile(
                                        file: snapshot.data[int] as File,
                                        fileName:
                                            basename(snapshot.data[int].path),
                                      );
                              },
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length == null
                                ? Center(child: Text('No Photo Available'))
                                : snapshot.data.length,
                            itemBuilder: (context, int) {
                              return _image == null
                                  ? Center(child: Text('No image Found.'))
                                  : SingleImageListTile(
                                      //   date: date,
                                      file: snapshot.data[int] as File,
                                      fileName:
                                          basename(snapshot.data[int].path),
                                    );
                            },
                          ),
                  );
                } else if (!snapshot.hasData) {
                  print('Data Nathi');
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  print('Else Part che.');
                  return Center(
                    child: Text('Else Part'),
                  );
                }
              }),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
                padding: MaterialStateProperty.all(EdgeInsets.all(12.0)),
              ),
              onPressed: () {
                loadImage(ImageSource.gallery);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.insert_drive_file_rounded),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Add new image'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
