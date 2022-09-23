import 'package:hedera_core/blocs/main_wallet/main_wallet_cubit.dart';
import 'package:hedera_core/blocs/sub_wallet/sub_wallet_cubit.dart';
import 'package:hedera_core/model/hedera_sub_wallet.dart';
import 'package:core_cai_v3/base/base_cai_screen.dart';
import 'package:core_cai_v3/bloc/chat_message/chat_message_bloc.dart';
import 'package:core_cai_v3/widgets/chat_item_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lumbung_wallet_cai/core/base/base_stateful.dart';

import 'package:lumbung_common/model/hedera/wallet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbung_wallet_cai/core/utils/loading_util.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/custom_function.dart';
import '../../core/utils/text_styles.dart';
import '../../shared_widget/custom_text_field.dart';
import '../../shared_widget/custom_text_form_field.dart';
import '../../shared_widget/leading_icon_widget.dart';
import '../../shared_widget/rounded_button.dart';
import '../home/home.dart';

part 'ui/set_main_wallet_screen.dart';
part 'ui/detail_sub_wallet_screen.dart';

part 'widget/main_wallet_sidebar_list_widget.dart';
