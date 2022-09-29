import 'package:hedera_core/blocs/auth/auth_bloc.dart';
import 'package:hedera_core/blocs/job/job_cubit.dart';
import 'package:lumbung_common/model/hedera/concensus_model.dart';
import 'package:lumbung_common/model/hedera/job_model.dart';
import 'package:hedera_core/utils/date_utils.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:collection/collection.dart';

import '../../core/base/base_stateful.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/custom_function.dart';
import '../../core/utils/hedera_utils.dart';
import '../../core/utils/loading_util.dart';
import '../../core/utils/text_styles.dart';
import '../../shared_widget/base_screen.dart';
import '../../shared_widget/custom_app_bar.dart';
import '../../shared_widget/custom_table_widget.dart';
import '../../shared_widget/rounded_button.dart';

part 'ui/job_screen.dart';
part 'ui/job_concensus_data_screen.dart';
