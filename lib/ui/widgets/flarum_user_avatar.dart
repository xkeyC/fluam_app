import 'package:fluam_app/ui/widgets/cache_image/cache_image.dart';
import 'package:flutter/material.dart';

class FlarumUserAvatar extends StatelessWidget {
  final String? avatarUrl;

  const FlarumUserAvatar(this.avatarUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (avatarUrl == null) {
      return ClipOval(
        child: Icon(
          Icons.account_circle,
          size: 48,
        ),
      );
    }
    return SizedBox(
      width: 48,
      height: 48,
      child: ClipOval(
        child: CacheImage(
          avatarUrl,
          loaderSize: 48,
        ),
      ),
    );
  }
}
