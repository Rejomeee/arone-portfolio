import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_my_portfolio/cubit/flutter_bird/flutter_bird_cubit.dart';

final List<BlocProvider<dynamic>> multipleProviders = [
  BlocProvider<FlutterBirdCubit>(
    create: (BuildContext context) => FlutterBirdCubit(),
  ),
];
