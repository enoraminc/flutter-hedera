import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:core/blocs/job/job_cubit.dart';
import 'package:core/blocs/journal/journal_cubit.dart';
import 'package:core/blocs/main_wallet/main_wallet_cubit.dart';
import 'package:core/blocs/sub_wallet/sub_wallet_cubit.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lumbunghedera_dashboard/core/base/base_stateful.dart';
import 'package:lumbunghedera_dashboard/core/utils/text_styles.dart';
import 'package:lumbunghedera_dashboard/shared_widget/rounded_button.dart';

import '../../core/routes/routes.dart';
import '../../core/utils/custom_function.dart';
import '../../core/utils/loading_util.dart';
import '../../flavor_config.dart';
import '../../shared_widget/base_screen.dart';
import '../../shared_widget/custom_app_bar.dart';
import '../../shared_widget/custom_table_widget.dart';

part 'ui/dashboard_screen.dart';

part 'widget/box_content_widget.dart';
