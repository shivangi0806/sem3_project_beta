import 'package:fitlink/core/model/privilege.dart';
import 'package:fitlink/core/model/role.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

typedef RoleSubmit = Future<void> Function(
  String roleId,
  String roleName,
  List<int> privilegeIds,
);

class RoleFormDialog extends StatefulWidget {
  const RoleFormDialog({
    super.key,
    required this.privileges,
    required this.onSubmit,
    this.role,
  });

  final List<Privilege> privileges;
  final Role? role;
  final RoleSubmit onSubmit;

  @override
  State<RoleFormDialog> createState() => _RoleFormDialogState();
}

class _RoleFormDialogState extends State<RoleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final Set<int> _selectedPrivileges;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.role != null;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.role?.roleId ?? '');
    _nameController = TextEditingController(text: widget.role?.roleName ?? '');
    _selectedPrivileges = widget.role?.privilegesId.toSet() ?? <int>{};
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPrivileges.isEmpty) {
      setState(() => _error = 'Select at least one existing privilege for this role.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.onSubmit(
        _idController.text.trim(),
        _nameController.text.trim(),
        _selectedPrivileges.toList()..sort(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: navyBlueLight,
      title: Text(_isEditing ? 'Update role' : 'Create role'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _idController,
                  readOnly: _isEditing,
                  decoration: const InputDecoration(
                    labelText: 'Role ID',
                    hintText: 'e.g. ROLE_ANALYST',
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a role ID'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Role name'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a role name'
                      : null,
                ),
                const SizedBox(height: 20),
                Text('Assign existing privileges',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 6),
                if (widget.privileges.isEmpty)
                  const Text('No privileges are available in the database.')
                else
                  ...widget.privileges.map((privilege) {
                    return CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _selectedPrivileges.contains(privilege.privilegeId),
                      title: Text(privilege.name),
                      subtitle: Text('ID ${privilege.privilegeId}${privilege.description.isEmpty ? '' : ' · ${privilege.description}'}'),
                      onChanged: _saving
                          ? null
                          : (selected) => setState(() {
                                if (selected == true) {
                                  _selectedPrivileges.add(privilege.privilegeId);
                                } else {
                                  _selectedPrivileges.remove(privilege.privilegeId);
                                }
                                _error = null;
                              }),
                    );
                  }),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving || widget.privileges.isEmpty ? null : _submit,
          child: _saving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEditing ? 'Save changes' : 'Create role'),
        ),
      ],
    );
  }
}
