import 'package:core/blocs/main_wallet/main_wallet_cubit.dart';
import 'package:core/blocs/sub_wallet/sub_wallet_cubit.dart';
import 'package:core/model/hedera_sub_wallet.dart';
import 'package:lumbung_common/model/hedera/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import '../../core/base/base_stateful.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/text_styles.dart';
import '../../shared_widget/base_screen.dart';
import '../../shared_widget/custom_app_bar.dart';

part 'ui/wallet_screen.dart';
