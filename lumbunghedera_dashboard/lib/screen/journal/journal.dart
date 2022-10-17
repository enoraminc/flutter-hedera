import 'dart:convert';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:hedera_core/blocs/auth/auth_bloc.dart';
import 'package:hedera_core/blocs/journal/journal_cubit.dart';
import 'package:hedera_core/blocs/sub_wallet/sub_wallet_cubit.dart';
import 'package:hedera_core/blocs/vote/vote_cubit.dart';
import 'package:lumbung_common/model/hedera/concensus_model.dart';
import 'package:lumbung_common/model/hedera/hedera_sub_wallet.dart';
import 'package:lumbung_common/model/hedera/journal_model.dart';
import 'package:lumbung_common/model/hedera/pod_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbunghedera_dashboard/core/base/base_stateful.dart';
import 'package:collection/collection.dart';
import 'package:hedera_core/utils/date_utils.dart';
import 'package:lumbunghedera_dashboard/core/utils/text_styles.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:go_router/go_router.dart';
import 'package:lumbung_common/model/hedera/job_model.dart';

import 'package:lumbung_common/model/user.dart';
import 'package:lumbung_common/model/hedera/wallet.dart';
import 'package:lumbung_common/model/hedera/cashbon_journal_model.dart';
import 'package:lumbung_common/model/hedera/vote_journal_model.dart';

import '../../core/base/base_stateless.dart';
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

part 'ui/journal_concensus_data_screen.dart';
part 'ui/journal_screen.dart';
part 'ui/create_cashbon_journal_screen.dart';
part 'ui/create_vote_journal_screen.dart';

part 'widget/journal_type_selector_widget.dart';
part 'widget/detail_journal_widget.dart';
part 'widget/single_journal_widget.dart';
part 'widget/cashbon_concensus_widget.dart';
part 'widget/vote_concensus_widget.dart';
part 'widget/journal_member_list_widget.dart';
