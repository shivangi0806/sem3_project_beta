import 'package:fitlink/core/model/role.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/admin/presentation/cubits/roles_cubit.dart';
import 'package:fitlink/features/admin/presentation/cubits/roles_state.dart';
import 'package:fitlink/features/admin/presentation/components/roles/role_form_dialog.dart';
import 'package:fitlink/features/auth/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RolesPage extends StatelessWidget {
  const RolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UserProvider>(context, listen: false).userToken;
    return BlocProvider(
      create: (_) => RolesCubit(token: token)..loadRoles(),
      child: const RolesPageComponent(),
    );
  }
}

class RolesPageComponent extends StatefulWidget {
  const RolesPageComponent({super.key});

  @override
  State<RolesPageComponent> createState() => _RolesPageComponentState();
}

class _RolesPageComponentState extends State<RolesPageComponent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _lookupRole() async {
    final controller = TextEditingController();
    final roleId = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: navyBlueLight,
        title: const Text('Find a role'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Role ID',
            hintText: 'Enter the exact role ID',
          ),
          onSubmitted: (value) => Navigator.pop(dialogContext, value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Find'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (roleId == null || roleId.isEmpty || !mounted) return;
    _showRoleDetails(roleId);
  }

  Future<void> _showRoleDetails(String roleId) async {
    final future = context.read<RolesCubit>().getRoleDetails(roleId);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: navyBlueLight,
        title: const Text('Role details'),
        content: SizedBox(
          width: 440,
          child: FutureBuilder<Role>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox(
                  height: 90,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Text(
                  'Could not load role: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent),
                );
              }
              final role = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detail('Role name', role.roleName),
                    _detail('Role ID', role.roleId),
                    _detail('Type', role.isSystemRole ? 'System' : 'Custom'),
                    _detail('Privileges', role.privilegesId.isEmpty
                        ? 'None assigned'
                        : role.privilegesId.join(', ')),
                    _detail('Created', _formatDateTime(role.createdAt)),
                    _detail('Updated', _formatDateTime(role.updatedAt)),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRoleForm({Role? role}) async {
    final state = context.read<RolesCubit>().state;
    if (state is! RolesLoaded) return;
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RoleFormDialog(
        role: role,
        privileges: state.privileges,
        onSubmit: (roleId, roleName, privilegeIds) {
          final cubit = context.read<RolesCubit>();
          if (role == null) {
            return cubit.createRole(
              roleId: roleId,
              roleName: roleName,
              privilegesId: privilegeIds,
            );
          }
          return cubit.updateRole(
            roleId: role.roleId,
            roleName: roleName,
            privilegesId: privilegeIds,
          );
        },
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(role == null ? 'Role created.' : 'Role updated.')),
      );
    }
  }

  Future<void> _deleteRole(Role role) async {
    if (role.isSystemRole) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete role?'),
        content: Text('Delete "${role.roleName}" (${role.roleId})? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await context.read<RolesCubit>().deleteRole(role.roleId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted role "${role.roleName}".')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }

  Widget _detail(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 105,
              child: Text(label, style: const TextStyle(color: Colors.white60)),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles'),
        actions: [
          IconButton(
            tooltip: 'Create role',
            onPressed: () => _showRoleForm(),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: 'Find role by ID',
            onPressed: _lookupRole,
            icon: const Icon(Icons.manage_search_outlined),
          ),
          IconButton(
            tooltip: 'Refresh roles',
            onPressed: () => context.read<RolesCubit>().loadRoles(),
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<RolesCubit, RolesState>(
        builder: (context, state) {
          if (state is RolesInitial || state is RolesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RolesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => context.read<RolesCubit>().loadRoles(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is! RolesLoaded) return const SizedBox.shrink();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 320,
                      child: TextField(
                        controller: _searchController,
                        onChanged: context.read<RolesCubit>().searchRoles,
                        decoration: const InputDecoration(
                          hintText: 'Search role name, ID, or privilege',
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      value: state.systemFilter == null
                          ? 'all'
                          : state.systemFilter! ? 'system' : 'custom',
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All types')),
                        DropdownMenuItem(value: 'system', child: Text('System')),
                        DropdownMenuItem(value: 'custom', child: Text('Custom')),
                      ],
                      onChanged: (value) => context.read<RolesCubit>().filterBySystem(
                        value == 'system' ? true : value == 'custom' ? false : null,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        final cubit = context.read<RolesCubit>();
                        cubit.searchRoles('');
                        cubit.filterBySystem(null);
                      },
                      icon: const Icon(Icons.filter_alt_off_outlined),
                      label: const Text('Clear filters'),
                    ),
                    Text('${state.roles.length} roles'),
                  ],
                ),
              ),
              Expanded(
                child: state.roles.isEmpty
                    ? Center(
                        child: Text(state.searchQuery.trim().isEmpty &&
                                state.systemFilter == null
                            ? 'No roles found.'
                            : 'No roles match these filters.'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        itemCount: state.roles.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) => _roleTile(state.roles[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _roleTile(Role role) => Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showRoleDetails(role.roleId),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: accentBlue.withOpacity(0.2),
                  child: Icon(
                    role.isSystemRole ? Icons.admin_panel_settings_outlined : Icons.badge_outlined,
                    color: const Color(0xFFB9DAFF),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(role.roleName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text('ID: ${role.roleId}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _typeChip(role.isSystemRole),
                          _metaLabel(Icons.lock_outline, '${role.privilegesId.length} privileges'),
                          _metaLabel(Icons.calendar_today_outlined, _formatDate(role.createdAt)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: role.isSystemRole ? 'System roles cannot be edited' : 'Edit role',
                  onPressed: role.isSystemRole ? null : () => _showRoleForm(role: role),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: role.isSystemRole ? 'System roles cannot be deleted' : 'Delete role',
                  onPressed: role.isSystemRole ? null : () => _deleteRole(role),
                  icon: const Icon(Icons.delete_outline),
                ),
                IconButton(
                  tooltip: 'View role details',
                  onPressed: () => _showRoleDetails(role.roleId),
                  icon: const Icon(Icons.arrow_forward_ios, size: 17),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _typeChip(bool isSystem) {
    final color = isSystem ? Colors.lightBlueAccent : Colors.tealAccent;
    final label = isSystem ? 'System role' : 'Custom role';
    return Chip(
      avatar: Icon(isSystem ? Icons.shield_outlined : Icons.tune, size: 15),
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _metaLabel(IconData icon, String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white54),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      );

  String _formatDate(DateTime? date) => date == null
      ? '—'
      : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  String _formatDateTime(DateTime? date) => date == null
      ? '—'
      : '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
