import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glowblow/widgets/gradient_title.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_extend/share_extend.dart';

class ViewImage extends StatefulWidget {
  final File picture;

  const ViewImage({Key key, this.picture}) : super(key: key);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  GlobalKey<ScaffoldState> imageScaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    showSnackBar(String text) {
      imageScaffold.currentState.showSnackBar(SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ));
    }

    return Scaffold(
      key: imageScaffold,
      appBar: AppBar(
        centerTitle: true,
        title: GradientTitle(
          title: 'View Your Image',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.share_up),
            onPressed: () async {
              await ShareExtend.share(widget.picture.path, 'image');
            },
          ),
          IconButton(
            icon: Icon(CupertinoIcons.down_arrow),
            onPressed: () async {
              if (await Permission.storage.isGranted) {
                final result =
                    await ImageGallerySaver.saveFile(widget.picture.path);
//                print(result);
                if (result
                    .toString()
                    .contains('.png', result.toString().length - 5)) {
                  showSnackBar('Image Saved Successfully ☺️');
                }
              } else {
                !await Permission.storage.isPermanentlyDenied
                    ? Permission.storage.request()
                    : showSnackBar('Please Grant Permission');
              }
            },
          )
        ],
      ),
      body: Image.file(widget.picture),
    );
  }
}
