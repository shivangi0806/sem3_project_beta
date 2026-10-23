import 'package:fitlink/features/admin/presentation/components/privileges/prvileges_pages_component.dart';
import 'package:fitlink/features/admin/presentation/cubits/prvileges_cubit_cubit.dart';
import 'package:fitlink/features/auth/presenttation/cubits/auth_cubit.dart';
import 'package:fitlink/features/auth/presenttation/cubits/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrevilegesPage extends StatelessWidget {
  const PrevilegesPage({super.key, this.token});

  /// Optional explicit JWT. When omitted, the page uses the authenticated
  /// session held by [AuthCubit].
  final String? token;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authState = context.read<AuthCubit>().state;
        final jwt = token ??
            (authState is AuthLoginSuccessState
                ? authState.user.accessToken
                : '');
        return PrvilegesCubitCubit(token: jwt)..loadPrivileges();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Privileges')),
        body: const PrevilegesPageComponent(),
      ),
    );
  }
}
