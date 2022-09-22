import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:core/blocs/job/job_cubit.dart';
import 'package:core/blocs/main_wallet/main_wallet_cubit.dart';
import 'package:core/blocs/sub_wallet/sub_wallet_cubit.dart';
import 'package:core/model/hedera_sub_wallet.dart';
import 'package:core/model/job_model.dart';
import 'package:lumbung_common/model/hedera/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

import '../../core/base/base_stateful.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/loading_util.dart';
import '../../core/utils/text_styles.dart';
import '../../shared_widget/base_screen.dart';
import '../../shared_widget/custom_app_bar.dart';
import '../../shared_widget/custom_text_field.dart';
import '../../shared_widget/custom_text_form_field.dart';
import '../../shared_widget/main_wallet_selector.dart';
import '../../shared_widget/rounded_button.dart';

part 'ui/wallet_screen.dart';
part 'ui/set_main_wallet_screen.dart';
part 'ui/set_sub_wallet_screen.dart';
