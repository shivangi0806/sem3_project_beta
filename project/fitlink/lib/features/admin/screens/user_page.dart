import 'package:fitlink/core/model/user.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/admin/presentation/cubits/users_cubit.dart';
import 'package:fitlink/features/admin/presentation/cubits/users_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _lookupUser() async {
    final controller = TextEditingController();
    final userId = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: navyBlueLight,
        title: const Text('Find a user'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'User ID',
            hintText: 'Enter the exact user ID',
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

    if (userId == null || userId.isEmpty || !mounted) return;
    await _showUserDetails(userId);
  }

  Future<void> _showUserDetails(String userId) async {
    final future = context.read<UsersCubit>().getUserDetails(userId);
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: navyBlueLight,
        title: const Text('User details'),
        content: SizedBox(
          width: 440,
          child: FutureBuilder<User>(
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
                  'Could not load user: ${snapshot.error}',
                  style: const TextStyle(color: Colors.redAccent),
                );
              }
              final user = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detail('User ID', user.userId),
                    _detail('Name', user.username),
                    _detail('Email', user.email),
                    _detail('Role', user.roleId),
                    _detail('Mobile', user.mobileNo ?? '—'),
                    _detail('Status', user.isActive ? 'Active' : 'Inactive'),
                    _detail('Created', _formatDateTime(user.createdAt)),
                    _detail('Updated', _formatDateTime(user.updatedAt)),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: Colors.white60)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            tooltip: 'Find user by ID',
            onPressed: _lookupUser,
            icon: const Icon(Icons.person_search_outlined),
          ),
          IconButton(
            tooltip: 'Refresh users',
            onPressed: () => context.read<UsersCubit>().loadUsers(),
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersInitial || state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UsersError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => context.read<UsersCubit>().loadUsers(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is! UsersLoaded) return const SizedBox.shrink();

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
                      width: 300,
                      child: TextField(
                        controller: _searchController,
                        onChanged: context.read<UsersCubit>().searchUsers,
                        decoration: const InputDecoration(
                          hintText: 'Search name, email, ID, or role',
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      value: state.roleFilter ?? '',
                      hint: const Text('All roles'),
                      items: [
                        const DropdownMenuItem(
                          value: '',
                          child: Text('All roles'),
                        ),
                        ...state.availableRoles.map(
                          (role) =>
                              DropdownMenuItem(value: role, child: Text(role)),
                        ),
                      ],
                      onChanged: (value) =>
                          context.read<UsersCubit>().filterByRole(
                            value == null || value.isEmpty ? null : value,
                          ),
                    ),
                    DropdownButton<String>(
                      value: state.activeFilter == null
                          ? 'all'
                          : state.activeFilter!
                          ? 'active'
                          : 'inactive',
                      items: const [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text('All status'),
                        ),
                        DropdownMenuItem(
                          value: 'active',
                          child: Text('Active'),
                        ),
                        DropdownMenuItem(
                          value: 'inactive',
                          child: Text('Inactive'),
                        ),
                      ],
                      onChanged: (value) =>
                          context.read<UsersCubit>().filterByStatus(
                            value == 'active'
                                ? true
                                : value == 'inactive'
                                ? false
                                : null,
                          ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        final cubit = context.read<UsersCubit>();
                        cubit.searchUsers('');
                        cubit.filterByRole(null);
                        cubit.filterByStatus(null);
                      },
                      icon: const Icon(Icons.filter_alt_off_outlined),
                      label: const Text('Clear filters'),
                    ),
                    Text('${state.users.length} users'),
                  ],
                ),
              ),
              Expanded(
                child: state.users.isEmpty
                    ? Center(
                        child: Text(
                          state.searchQuery.trim().isEmpty &&
                                  state.roleFilter == null &&
                                  state.activeFilter == null
                              ? 'No users found.'
                              : 'No users match these filters.',
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        itemCount: state.users.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) =>
                            _userTile(state.users[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _userTile(User user) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showUserDetails(user.userId),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: accentBlue.withOpacity(0.2),
                child: Text(
                  _initials(user.username),
                  style: const TextStyle(
                    color: Color(0xFFB9DAFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _roleChip(user.roleId),
                        _statusChip(user.isActive),
                        _metaLabel(Icons.badge_outlined, user.userId),
                        _metaLabel(
                          Icons.calendar_today_outlined,
                          _formatDate(user.createdAt),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'View user details',
                onPressed: () => _showUserDetails(user.userId),
                icon: const Icon(Icons.arrow_forward_ios, size: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleChip(String role) {
    return Chip(
      avatar: const Icon(Icons.verified_user_outlined, size: 15),
      label: Text(role.isEmpty ? 'Unassigned' : role),
      backgroundColor: navyBlueMid,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _statusChip(bool isActive) {
    final color = isActive ? Colors.greenAccent : Colors.orangeAccent;
    return Chip(
      avatar: Icon(Icons.circle, size: 9, color: color),
      label: Text(isActive ? 'Active' : 'Inactive'),
      labelStyle: TextStyle(color: color, fontSize: 12),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _metaLabel(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white54),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return '—';
    return '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
