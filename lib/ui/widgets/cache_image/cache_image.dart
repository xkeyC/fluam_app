import 'dart:async';
import 'dart:io';

import 'package:fluam_app/io/cache_manager.dart';
import 'package:flutter/material.dart';

class CacheImage extends StatefulWidget {
  final String url;

  /// loader
  final double loaderSize;

  CacheImage(this.url, {this.loaderSize = 64});

  @override
  _CacheImageState createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage>
    with AutomaticKeepAliveClientMixin {
  File imageFile;
  StreamSubscription fileStream;

  @override
  void initState() {
    if (fileStream != null) {
      return;
    }
    fileStream = AppCacheManager.getFile(widget.url).asStream().listen((file) {
      setState(() {
        imageFile = file;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (fileStream != null) {
      fileStream.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return imageFile == null
        ? Icon(
            Icons.image,
            size: widget.loaderSize,
            color: Colors.grey,
          )
        : Image.file(imageFile);
  }

  @override
  bool get wantKeepAlive => true;
}
