import 'dart:typed_data';

import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:core/blocs/sub_wallet/sub_wallet_cubit.dart';
import 'package:core/model/hedera_sub_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lumbung_wallet_cai/core/base/base_stateful.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:core_cai_v3/bloc/chat_message/chat_message_bloc.dart';
import 'package:core_cai_v3/base/base_chat_screen.dart';
import 'package:core_cai_v3/functions/custom_function.dart';
import 'package:core_cai_v3/model/chat_user.dart';
import 'package:core_cai_v3/widgets/chat_item_screen.dart';
import 'package:core_cai_v3/widgets/chat_message/chat_message_header.dart';
import 'package:core_cai_v3/base/base_cai_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:lumbung_wallet_cai/core/routes/routes.dart';
import 'package:lumbung_wallet_cai/flavor_config.dart';
import 'package:go_router/go_router.dart';

import '../../core/blocs/main_screen/main_screen_bloc.dart';
import '../../core/blocs/sidebar/sidebar_bloc.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/loading_util.dart';
import '../../core/utils/storage_utils.dart';
import '../../core/utils/text_styles.dart';
import '../../shared_widget/rounded_button.dart';

part 'ui/home_screen.dart';

part 'widget/sidebar_list_widget.dart';
part 'widget/main_chat_screen.dart';
