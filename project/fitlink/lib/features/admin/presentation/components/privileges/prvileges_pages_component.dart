import 'package:fitlink/core/model/privilege.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/admin/presentation/components/privileges/previleges_form_dialog.dart';
import 'package:fitlink/features/admin/presentation/components/src/empty_privilege_tile.dart';
import 'package:fitlink/features/admin/presentation/components/src/privilegeTile.dart';
import 'package:fitlink/features/admin/presentation/cubits/prvileges_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrevilegesPageComponent extends StatefulWidget {
  const PrevilegesPageComponent({super.key});

  @override
  State<PrevilegesPageComponent> createState() =>
      _PrevilegesPageComponentState();
}

class _PrevilegesPageComponentState extends State<PrevilegesPageComponent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openPrivilegeForm({Privilege? privilege}) async {
    final result = await showDialog<Privilege>(
      context: context,
      builder: (_) => PrivilegeFormDialog(privilege: privilege),
    );

    if (result == null || !mounted) return;

    final cubit = context.read<PrvilegesCubitCubit>();

    if (privilege == null) {
      await cubit.addPrivilege(
        name: result.name,
        description: result.description,
      );
    } else {
      await cubit.updatePrivilege(
        privilegeId: privilege.privilegeId,
        name: result.name,
        description: result.description,
      );
    }
  }

  Future<void> _confirmDelete(Privilege privilege) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: navyBlueLight,
        title: const Text('Delete privilege?'),
        content: Text('“${privilege.name}” will be removed from this list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context
          .read<PrvilegesCubitCubit>()
          .deletePrivilege(privilege.privilegeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrvilegesCubitCubit, PrvilegesCubitState>(
      builder: (context, state) {
        if (state is PrvilegesLoadingState || state is PrvilegesCubitInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PrivilegesErrorState) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Could not load privileges: ${state.errorMsg}'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      context.read<PrvilegesCubitCubit>().loadPrivileges(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is! PrvilegesSuccessState) {
          return const SizedBox.shrink();
        }

        final items = state.data;
        final cubit = context.read<PrvilegesCubitCubit>();

        return LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 600;

            return SingleChildScrollView(
              padding: EdgeInsets.all(compact ? 16 : 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Privilege management',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Define the access capabilities available in FitLink.',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          if (!compact) ...[
                            const SizedBox(width: 16),
                            FilledButton.icon(
                              onPressed: () => _openPrivilegeForm(),
                              icon: const Icon(Icons.add),
                              label: const Text('Add privilege'),
                            ),
                          ],
                        ],
                      ),
                      if (compact) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _openPrivilegeForm(),
                            icon: const Icon(Icons.add),
                            label: const Text('Add privilege'),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: navyBlueLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.07),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.shield_outlined,
                                  color: Color(0xFF91C5FF),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                            '${items.length} '
                                    '${items.length == 1 ? 'privilege' : 'privileges'}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: compact ? 150 : 260,
                                  height: 42,
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: cubit.searchPrivileges,
                                    decoration: InputDecoration(
                                      hintText: 'Search privileges',
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        size: 19,
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (items.isEmpty)
                              EmptyPrivileges(
                                searching: state.searchQuery.trim().isNotEmpty,
                              )
                            else
                              ...items.map(
                                (item) => PrivilegeTile(
                                  privilege: item,
                                  onEdit: () =>
                                      _openPrivilegeForm(privilege: item),
                                  onDelete: () => _confirmDelete(item),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
