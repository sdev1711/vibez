import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibez/Cubit/auth/auth_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/screens/home/home_mobile_layout.dart';
import 'package:vibez/screens/home/home_tablet_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService apiService = ApiService();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().checkUserLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        if (availableWidth >= 600) {
          return HomeTabletLayout();
        } else {
          return HomeMobileLayout();
        }
      },
    );
  }
}
