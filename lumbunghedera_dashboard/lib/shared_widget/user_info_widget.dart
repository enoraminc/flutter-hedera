import 'package:flutter/material.dart';
import 'package:lumbung_common/model/user.dart';

import '../core/utils/text_styles.dart';
import 'profile_image_widget.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    if (user == null) return SizedBox();
    return Row(
      children: [
        ProfileImageWidget(
          url: user?.avatarUrl ?? "",
          height: 50,
          width: 50,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                user?.displayName ?? "",
                style: Styles.commonTextStyle(
                  size: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                user?.email ?? "",
                style: Styles.commonTextStyle(
                  size: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
