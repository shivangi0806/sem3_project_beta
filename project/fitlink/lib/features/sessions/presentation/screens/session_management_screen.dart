import 'package:fitlink/features/auth/provider/user_provider.dart';
import 'package:fitlink/features/sessions/data/services/session_service.dart';
import 'package:fitlink/features/sessions/presentation/components/coach_session_management_component.dart';
import 'package:fitlink/features/sessions/presentation/components/player_session_list_component.dart';
import 'package:fitlink/features/sessions/presentation/cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SessionManagementScreen extends StatelessWidget {
  const SessionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<UserProvider>();
    if (!session.isAuthenticated) {
      return const _SessionAccessMessage(
        message: 'Sign in to load sessions from the FitLink backend.',
      );
    }
    final isPlayer = session.user?.roleId == 'ROLE_PLAYER';
    return BlocProvider(
      key: ValueKey('${session.userToken}:${session.user?.roleId}'),
      create: (_) => SessionCubit(
        SessionService(token: session.userToken),
      )..load(playerMode: isPlayer),
      child: isPlayer
          ? const PlayerSessionListComponent()
          : const CoachSessionManagementComponent(),
    );
  }
}

class _SessionAccessMessage extends StatelessWidget {
  const _SessionAccessMessage({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline_rounded, size: 40),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ),
  );
}
