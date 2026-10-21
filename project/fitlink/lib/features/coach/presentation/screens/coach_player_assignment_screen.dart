import 'package:fitlink/features/auth/provider/user_provider.dart';
import 'package:fitlink/features/coach/cubit/coach_roster_cubit.dart';
import 'package:fitlink/features/coach/data/services/coach_roster_service.dart';
import 'package:fitlink/features/coach/presentation/components/coach_players_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CoachPlayerAssignmentScreen extends StatelessWidget {
  const CoachPlayerAssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<UserProvider>();
    if (!session.isAuthenticated || session.user?.roleId != 'ROLE_COACH') {
      return const Center(
        child: Text(
          'Sign in with a coach account to manage your player roster.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFB6C9E0)),
        ),
      );
    }

    return BlocProvider(
      key: ValueKey('coach-roster:${session.userToken}'),
      create: (_) => CoachRosterCubit(
        CoachRosterService(token: session.userToken),
      )..load(),
      child: const CoachPlayersComponent(),
    );
  }
}
