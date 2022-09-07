import 'dart:convert';

import 'package:core/blocs/auth/auth_bloc.dart';
import 'package:core/blocs/book/book_cubit.dart';
import 'package:core/blocs/sub_wallet/sub_wallet_cubit.dart';
import 'package:core/model/book_model.dart';
import 'package:core/model/cashbon_book_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumbunghedera_dashboard/core/base/base_stateful.dart';
import 'package:collection/collection.dart';
import 'package:core/utils/date_utils.dart';
import 'package:lumbunghedera_dashboard/core/utils/text_styles.dart';

import '../../core/utils/loading_util.dart';
import '../../shared_widget/base_screen.dart';
import '../../shared_widget/custom_app_bar.dart';
import '../../shared_widget/custom_table_widget.dart';

part 'ui/book_message_screen.dart';
