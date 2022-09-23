import 'package:hedera_core/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbunghedera_dashboard/core/utils/custom_function.dart';
import 'package:lumbunghedera_dashboard/core/utils/text_styles.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';

class ProfileDropdown extends StatelessWidget {
  const ProfileDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final currentUser =
          context.select((AuthBloc element) => element.state.currentUser);
      return PopupMenuButton(
        offset: const Offset(0, 35),
        color: Theme.of(context).backgroundColor,
        onSelected: (int v) {
          switch (v) {
            case 0:
              ThemeMode? themeMode = EasyDynamicTheme.of(context).themeMode;
              if (themeMode == ThemeMode.dark) {
                EasyDynamicTheme.of(context).changeTheme(dark: false);
              } else {
                EasyDynamicTheme.of(context).changeTheme(dark: true);
              }
              break;
            case 1:
              context.read<AuthBloc>().add(const LogoutButtonPressed());
              break;

            default:
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              value: 0,
              child: Row(
                children: <Widget>[
                  Icon(
                    CustomFunctions.isDarkTheme(context)
                        ? Icons.brightness_4
                        : Icons.brightness_2,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    CustomFunctions.isDarkTheme(context)
                        ? "Light mode"
                        : "Dark mode",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    size: 15,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Logout",
                    style: Styles.commonTextStyle(
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Row(
            children: [
              if (currentUser?.avatarUrl?.isEmpty ?? false)
                CircleAvatar(
                  radius: 22,
                  child: Text(
                    currentUser?.displayName?[0] ?? "-",
                  ),
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        currentUser?.avatarUrl ?? "",
                      ),
                    ),
                  ),
                ),
              if (!CustomFunctions.isMobile(context)) ...[
                const SizedBox(width: 5),
                Text(
                  currentUser?.displayName ?? "",
                  style: Styles.commonTextStyle(
                    size: 16,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 18,
                )
              ],
            ],
          ),
        ),
      );
    });
  }
}
