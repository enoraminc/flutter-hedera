import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:core/blocs/book/book_cubit.dart';
import 'package:core/blocs/member_wallet/member_wallet_cubit.dart';
import 'package:core/blocs/sub_wallet/sub_wallet_cubit.dart';
import 'package:core/model/book_model.dart';
import 'package:core/model/hedera_sub_wallet.dart';
import 'package:core_cai_v3/base/base_cai_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lumbung_wallet_cai/core/base/base_stateful.dart';
import 'package:collection/collection.dart';

import 'package:lumbung_common/model/hedera/wallet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbung_wallet_cai/core/utils/loading_util.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/routes/routes.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/custom_function.dart';
import '../../core/utils/hedera_utils.dart';
import '../../core/utils/text_styles.dart';
import '../../shared_widget/custom_text_field.dart';
import '../../shared_widget/custom_text_form_field.dart';
import '../../shared_widget/main_wallet_selector.dart';
import '../../shared_widget/rounded_button.dart';

part 'ui/book_screen.dart';
part 'ui/create_book_screen.dart';
