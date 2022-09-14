import 'dart:convert';

import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:core/blocs/journal/journal_cubit.dart';
import 'package:core/blocs/sub_wallet/sub_wallet_cubit.dart';
import 'package:core/model/concensus_model.dart';
import 'package:core/model/hedera_sub_wallet.dart';
import 'package:core/model/journal_model.dart';
import 'package:core/model/cashbon_book_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbunghedera_dashboard/core/base/base_stateful.dart';
import 'package:collection/collection.dart';
import 'package:core/utils/date_utils.dart';
import 'package:lumbunghedera_dashboard/core/utils/text_styles.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:go_router/go_router.dart';

import 'package:lumbung_common/model/hedera/wallet.dart';

import '../../core/routes/routes.dart';
import '../../core/utils/custom_function.dart';
import '../../core/utils/hedera_utils.dart';
import '../../core/utils/loading_util.dart';
import '../../shared_widget/base_screen.dart';
import '../../shared_widget/custom_app_bar.dart';
import '../../shared_widget/custom_table_widget.dart';
import '../../shared_widget/custom_text_form_field.dart';
import '../../shared_widget/main_wallet_selector.dart';
import '../../shared_widget/rounded_button.dart';
import '../../shared_widget/sub_wallet_selector.dart';

part 'ui/journal_message_screen.dart';
part 'ui/journal_screen.dart';
part 'ui/create_journal_screen.dart';

part 'widget/journal_type_selector_widget.dart';
